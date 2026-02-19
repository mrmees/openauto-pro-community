#!/usr/bin/env python3
"""
Extract protobuf definitions from Android Auto APK native libraries and DEX files.

Scans for:
1. Embedded FileDescriptorProto blobs (full runtime — gives complete .proto files)
2. Protobuf descriptor pool registrations (lite runtime — gives partial info)
3. Raw string patterns matching protobuf message/field/enum names

Usage:
    python3 extract_aa_protos.py [--libs-dir DIR] [--apk-dir DIR] [--output-dir DIR]
"""

import argparse
import os
import re
import struct
import sys
from pathlib import Path

# Attempt imports — guide user if missing
try:
    from google.protobuf import descriptor_pb2
    from google.protobuf import text_format
except ImportError:
    print("ERROR: protobuf not installed. Run: pip install protobuf")
    sys.exit(1)


SCRIPT_DIR = Path(__file__).parent
DEFAULT_LIBS = SCRIPT_DIR / "output" / "libs"
DEFAULT_APK = SCRIPT_DIR / "output" / "apk"
DEFAULT_OUTPUT = SCRIPT_DIR / "output" / "protos"

# Known AA-related protobuf markers
AA_PROTO_MARKERS = [
    b"android.auto",
    b"android_auto",
    b"AndroidAuto",
    b"aap.protobuf",
    b"AAP_",
    b"gal.proto",
    b"gearhead",
    b"projection",
    b"ServiceDiscovery",
    b"ChannelDescriptor",
    b"SensorChannel",
    b"AVChannel",
    b"InputChannel",
    b"AudioFocus",
    b"VideoFocus",
    b"NavigationFocus",
    b"BluetoothPairing",
    b"WifiInfoRequest",
    b"WifiInfoResponse",
    b"ByeByeRequest",
    b"MediaBrowser",
    b"RadioEndpoint",
    b"InstrumentCluster",
    b"GenericNotification",
    b"VoiceSession",
    b"NavigationNextTurn",
    b"VendorExtension",
    b".proto",  # proto file references
]


def find_file_descriptor_protos(data: bytes, filename: str) -> list:
    """
    Search binary data for serialized FileDescriptorProto blobs.

    FileDescriptorProto starts with field 1 (name, string) which is
    wire type 2 (length-delimited): tag byte 0x0A followed by a varint length.
    The name typically ends in ".proto".

    Returns list of (offset, FileDescriptorProto) tuples.
    """
    results = []

    # Strategy 1: Search for ".proto" string preceded by a valid protobuf tag
    proto_suffix = b".proto"
    pos = 0
    while True:
        idx = data.find(proto_suffix, pos)
        if idx == -1:
            break
        pos = idx + 1

        # Walk backwards to find the start of the string field
        # The string is preceded by its varint length, preceded by tag 0x0A
        for name_start in range(max(0, idx - 200), idx):
            candidate_name = data[name_start:idx + len(proto_suffix)]
            # Check if this looks like a proto file name (printable, reasonable length)
            if not all(0x20 <= b < 0x7f for b in candidate_name):
                continue
            if len(candidate_name) < 3 or len(candidate_name) > 200:
                continue

            name_len = len(candidate_name)
            # Check for tag byte (0x0A) + varint length before the name
            for tag_offset in range(max(0, name_start - 5), name_start):
                if data[tag_offset] != 0x0A:
                    continue

                # Try to decode varint length
                varint_bytes = data[tag_offset + 1:name_start]
                decoded_len = decode_varint(varint_bytes)
                if decoded_len == name_len:
                    # Found a valid field 1 (name) — try to parse as FileDescriptorProto
                    # Try various lengths for the full message
                    for try_len in [256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072]:
                        end = min(tag_offset + try_len, len(data))
                        chunk = data[tag_offset:end]
                        fdp = try_parse_file_descriptor(chunk)
                        if fdp is not None:
                            results.append((tag_offset, fdp))
                            print(f"  [HIT] FileDescriptorProto at 0x{tag_offset:x}: {fdp.name}")
                            print(f"         Messages: {[m.name for m in fdp.message_type]}")
                            print(f"         Enums: {[e.name for e in fdp.enum_type]}")
                            print(f"         Services: {[s.name for s in fdp.service]}")
                            break
                    break

    return results


def try_parse_file_descriptor(data: bytes):
    """Try to parse bytes as a FileDescriptorProto, with progressive truncation."""
    fdp = descriptor_pb2.FileDescriptorProto()

    # Try parsing the full chunk, then progressively smaller
    for end in range(len(data), max(10, len(data) - 1000), -1):
        try:
            fdp.ParseFromString(data[:end])
            # Validate: must have a name ending in .proto
            if fdp.name and fdp.name.endswith(".proto"):
                # Must have at least one message or enum
                if fdp.message_type or fdp.enum_type:
                    return fdp
        except Exception:
            continue

    return None


def decode_varint(data: bytes) -> int:
    """Decode a protobuf varint from bytes. Returns -1 on failure."""
    result = 0
    for i, byte in enumerate(data):
        result |= (byte & 0x7F) << (7 * i)
        if not (byte & 0x80):
            return result
        if i > 4:
            return -1
    return -1


def find_descriptor_pool_registrations(data: bytes, filename: str) -> list:
    """
    Search for protobuf descriptor pool registration patterns.
    In lite runtime, descriptors are registered via generated code with
    string literals for message names and field info.

    Look for patterns like:
    - "google.protobuf.FileDescriptorProto" (full runtime marker)
    - Sequences of proto message names with field descriptors
    """
    registrations = []

    # Look for full runtime descriptor registration
    if b"google.protobuf.FileDescriptorProto" in data:
        registrations.append(("full_runtime", "google.protobuf.FileDescriptorProto found — full descriptors likely available"))

    if b"google.protobuf.FileDescriptorSet" in data:
        registrations.append(("descriptor_set", "FileDescriptorSet found — may contain bundled proto definitions"))

    # Look for GeneratedMessageReflection (full runtime)
    if b"GeneratedMessageReflection" in data:
        registrations.append(("reflection", "GeneratedMessageReflection found — full runtime confirmed"))

    # Look for lite runtime markers
    if b"MessageLite" in data and b"GeneratedMessageReflection" not in data:
        registrations.append(("lite_runtime", "MessageLite found without reflection — lite runtime, descriptors may be stripped"))

    return registrations


def extract_proto_strings(data: bytes, filename: str) -> dict:
    """
    Extract all AA-related strings that look like protobuf identifiers.
    Groups them by category (message names, field names, enum values, etc.)
    """
    strings = extract_printable_strings(data, min_len=4)

    categories = {
        "proto_files": [],       # .proto file references
        "message_types": [],     # CamelCase message type names
        "enum_values": [],       # UPPER_SNAKE_CASE enum values
        "field_names": [],       # lower_snake_case field names
        "package_names": [],     # dot-separated package names
        "service_names": [],     # Service-related strings
        "aa_specific": [],       # AA-specific identifiers
    }

    seen = set()
    for s in strings:
        if s in seen:
            continue
        seen.add(s)

        if s.endswith(".proto"):
            categories["proto_files"].append(s)
        elif re.match(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$', s):
            categories["package_names"].append(s)
        elif re.match(r'^[A-Z][a-zA-Z0-9]*((Request|Response|Notification|Indication|Status|Config|Channel|Descriptor|Message|Event|Info|Data|Type)$)', s):
            categories["message_types"].append(s)
        elif re.match(r'^[A-Z][A-Z0-9_]+$', s) and len(s) > 3:
            # Check if it's AA-related
            if any(marker in s.encode() for marker in [b"AAP_", b"AUDIO_", b"VIDEO_", b"SENSOR_", b"CHANNEL_", b"BLUETOOTH_", b"WIFI_", b"MEDIA_", b"NAV_", b"RADIO_", b"INSTRUMENT_", b"NOTIFICATION_", b"VOICE_"]):
                categories["enum_values"].append(s)
        elif re.match(r'^[a-z][a-z0-9_]+$', s) and any(kw in s for kw in ["channel", "audio", "video", "sensor", "bluetooth", "wifi", "media", "proto", "message", "service", "radio", "cluster", "notification", "navigation", "voice"]):
            categories["field_names"].append(s)

        # AA-specific markers
        for marker in AA_PROTO_MARKERS:
            if marker in s.encode() and s not in categories["aa_specific"]:
                categories["aa_specific"].append(s)

    return categories


def extract_printable_strings(data: bytes, min_len: int = 4) -> list:
    """Extract printable ASCII strings from binary data."""
    strings = []
    current = []
    for byte in data:
        if 0x20 <= byte < 0x7f:
            current.append(chr(byte))
        else:
            if len(current) >= min_len:
                strings.append("".join(current))
            current = []
    if len(current) >= min_len:
        strings.append("".join(current))
    return strings


def scan_for_file_descriptor_set(data: bytes, filename: str) -> list:
    """
    Search for a serialized FileDescriptorSet (a collection of FileDescriptorProtos).
    Some apps bundle all proto definitions in a single blob.
    """
    results = []

    # FileDescriptorSet has a single repeated field 1 (FileDescriptorProto)
    # Search for what looks like a large serialized blob starting with tag 0x0A
    # that contains multiple .proto references

    # Find regions with high density of ".proto" strings
    proto_positions = []
    pos = 0
    while True:
        idx = data.find(b".proto", pos)
        if idx == -1:
            break
        proto_positions.append(idx)
        pos = idx + 1

    if len(proto_positions) < 2:
        return results

    # Look for clusters of .proto references (within 64KB of each other)
    clusters = []
    current_cluster = [proto_positions[0]]
    for i in range(1, len(proto_positions)):
        if proto_positions[i] - proto_positions[i-1] < 65536:
            current_cluster.append(proto_positions[i])
        else:
            if len(current_cluster) >= 2:
                clusters.append(current_cluster)
            current_cluster = [proto_positions[i]]
    if len(current_cluster) >= 2:
        clusters.append(current_cluster)

    for cluster in clusters:
        start = max(0, cluster[0] - 1024)
        end = min(len(data), cluster[-1] + 1024)
        chunk = data[start:end]

        fds = descriptor_pb2.FileDescriptorSet()
        # Try various start offsets
        for offset in range(min(1024, len(chunk))):
            try:
                fds.ParseFromString(chunk[offset:])
                if len(fds.file) > 0 and all(f.name.endswith(".proto") for f in fds.file):
                    print(f"  [HIT] FileDescriptorSet at 0x{start + offset:x} with {len(fds.file)} proto files:")
                    for f in fds.file:
                        print(f"         - {f.name} ({len(f.message_type)} messages, {len(f.enum_type)} enums)")
                    results.append((start + offset, fds))
                    break
            except Exception:
                continue

    return results


def scan_dex_for_protos(dex_path: Path) -> dict:
    """
    Scan a DEX file for AA-related protobuf class names and string constants.
    DEX files contain the Java/Kotlin layer which may reference proto definitions.
    """
    with open(dex_path, "rb") as f:
        data = f.read()

    results = {
        "proto_classes": [],
        "aa_strings": [],
    }

    strings = extract_printable_strings(data, min_len=6)
    seen = set()
    for s in strings:
        if s in seen:
            continue
        seen.add(s)

        # Java proto generated class names
        if "Proto$" in s or "Proto." in s or s.endswith("Proto"):
            if any(kw in s.lower() for kw in ["auto", "projection", "gearhead", "aap", "gal"]):
                results["proto_classes"].append(s)

        # AA-related string constants
        for marker in AA_PROTO_MARKERS:
            if marker in s.encode():
                results["aa_strings"].append(s)
                break

    return results


def write_proto_file(fdp, output_dir: Path):
    """Write a FileDescriptorProto as a .proto file."""
    proto_text = generate_proto_text(fdp)
    outpath = output_dir / fdp.name.replace("/", "_")
    outpath.write_text(proto_text)
    print(f"  Wrote: {outpath}")
    return outpath


def generate_proto_text(fdp) -> str:
    """Generate .proto file text from a FileDescriptorProto."""
    lines = []
    lines.append(f'// Extracted from Android Auto APK')
    lines.append(f'// Source: {fdp.name}')
    lines.append(f'syntax = "proto2";')
    lines.append("")

    if fdp.package:
        lines.append(f"package {fdp.package};")
        lines.append("")

    for dep in fdp.dependency:
        lines.append(f'import "{dep}";')
    if fdp.dependency:
        lines.append("")

    if fdp.options and fdp.options.java_package:
        lines.append(f'option java_package = "{fdp.options.java_package}";')
    if fdp.options and fdp.options.java_outer_classname:
        lines.append(f'option java_outer_classname = "{fdp.options.java_outer_classname}";')
    if fdp.options:
        lines.append("")

    for enum in fdp.enum_type:
        lines.extend(generate_enum_text(enum, indent=0))
        lines.append("")

    for msg in fdp.message_type:
        lines.extend(generate_message_text(msg, indent=0))
        lines.append("")

    for svc in fdp.service:
        lines.extend(generate_service_text(svc))
        lines.append("")

    return "\n".join(lines)


def generate_enum_text(enum, indent=0):
    """Generate enum definition text."""
    prefix = "  " * indent
    lines = [f"{prefix}enum {enum.name} {{"]
    for val in enum.value:
        lines.append(f"{prefix}  {val.name} = {val.number};")
    lines.append(f"{prefix}}}")
    return lines


def generate_message_text(msg, indent=0):
    """Generate message definition text."""
    prefix = "  " * indent
    lines = [f"{prefix}message {msg.name} {{"]

    TYPE_NAMES = {
        1: "double", 2: "float", 3: "int64", 4: "uint64", 5: "int32",
        6: "fixed64", 7: "fixed32", 8: "bool", 9: "string", 10: "group",
        11: "message", 12: "bytes", 13: "uint32", 14: "enum", 15: "sfixed32",
        16: "sfixed64", 17: "sint32", 18: "sint64",
    }
    LABEL_NAMES = {1: "optional", 2: "required", 3: "repeated"}

    for enum in msg.enum_type:
        lines.extend(generate_enum_text(enum, indent + 1))
        lines.append("")

    for nested in msg.nested_type:
        lines.extend(generate_message_text(nested, indent + 1))
        lines.append("")

    for field in msg.field:
        label = LABEL_NAMES.get(field.label, "")
        if field.type in (11, 14):  # message or enum reference
            type_name = field.type_name.lstrip(".")
        else:
            type_name = TYPE_NAMES.get(field.type, f"unknown_{field.type}")

        default = ""
        if field.default_value:
            if field.type == 9:  # string
                default = f' [default = "{field.default_value}"]'
            else:
                default = f" [default = {field.default_value}]"

        lines.append(f"{prefix}  {label} {type_name} {field.name} = {field.number}{default};")

    for oneof in msg.oneof_decl:
        lines.append(f"{prefix}  oneof {oneof.name} {{")
        for field in msg.field:
            if field.HasField("oneof_index") and msg.oneof_decl[field.oneof_index].name == oneof.name:
                if field.type in (11, 14):
                    type_name = field.type_name.lstrip(".")
                else:
                    type_name = TYPE_NAMES.get(field.type, f"unknown_{field.type}")
                lines.append(f"{prefix}    {type_name} {field.name} = {field.number};")
        lines.append(f"{prefix}  }}")

    lines.append(f"{prefix}}}")
    return lines


def generate_service_text(svc):
    """Generate service definition text."""
    lines = [f"service {svc.name} {{"]
    for method in svc.method:
        lines.append(f"  rpc {method.name} ({method.input_type.lstrip('.')}) returns ({method.output_type.lstrip('.')});")
    lines.append("}")
    return lines


def main():
    parser = argparse.ArgumentParser(description="Extract protobuf definitions from Android Auto APK")
    parser.add_argument("--libs-dir", type=Path, default=DEFAULT_LIBS, help="Directory containing .so files")
    parser.add_argument("--apk-dir", type=Path, default=DEFAULT_APK, help="Directory containing extracted APK")
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT, help="Output directory for .proto files")
    parser.add_argument("--strings-only", action="store_true", help="Only extract strings, skip binary descriptor search")
    args = parser.parse_args()

    args.output_dir.mkdir(parents=True, exist_ok=True)

    all_protos = []
    all_strings = {}
    all_registrations = []

    # Phase 1: Scan native libraries for FileDescriptorProto blobs
    print("=" * 60)
    print("Phase 1: Scanning native libraries for proto descriptors")
    print("=" * 60)

    so_files = sorted(args.libs_dir.glob("**/*.so")) if args.libs_dir.exists() else []
    if not so_files:
        print(f"  No .so files found in {args.libs_dir}")
        print("  Run pull-aa-apk.sh first to extract libraries.")

    for so_file in so_files:
        print(f"\nScanning: {so_file.name} ({so_file.stat().st_size:,} bytes)")
        data = so_file.read_bytes()

        # Check runtime type
        regs = find_descriptor_pool_registrations(data, so_file.name)
        for reg_type, desc in regs:
            print(f"  [{reg_type}] {desc}")
            all_registrations.append((so_file.name, reg_type, desc))

        if not args.strings_only:
            # Search for FileDescriptorSet (bundled protos)
            fds_results = scan_for_file_descriptor_set(data, so_file.name)
            for offset, fds in fds_results:
                for fdp in fds.file:
                    all_protos.append(fdp)
                    write_proto_file(fdp, args.output_dir)

            # Search for individual FileDescriptorProto
            fdp_results = find_file_descriptor_protos(data, so_file.name)
            for offset, fdp in fdp_results:
                all_protos.append(fdp)
                write_proto_file(fdp, args.output_dir)

        # Extract AA-related strings
        categories = extract_proto_strings(data, so_file.name)
        non_empty = {k: v for k, v in categories.items() if v}
        if non_empty:
            all_strings[so_file.name] = categories
            for cat, items in non_empty.items():
                print(f"  {cat}: {len(items)} entries")

    # Phase 2: Scan DEX files
    print("\n" + "=" * 60)
    print("Phase 2: Scanning DEX files for proto class references")
    print("=" * 60)

    dex_files = sorted(args.apk_dir.glob("**/*.dex")) if args.apk_dir.exists() else []
    if not dex_files:
        print(f"  No .dex files found in {args.apk_dir}")

    for dex_file in dex_files:
        print(f"\nScanning: {dex_file} ({dex_file.stat().st_size:,} bytes)")
        results = scan_dex_for_protos(dex_file)
        if results["proto_classes"]:
            print(f"  Proto classes: {len(results['proto_classes'])}")
            for cls in sorted(results["proto_classes"])[:20]:
                print(f"    {cls}")
            if len(results["proto_classes"]) > 20:
                print(f"    ... and {len(results['proto_classes']) - 20} more")
        if results["aa_strings"]:
            print(f"  AA strings: {len(results['aa_strings'])}")

    # Phase 3: Scan asset files
    print("\n" + "=" * 60)
    print("Phase 3: Scanning assets for proto definitions")
    print("=" * 60)

    asset_files = sorted(args.apk_dir.glob("**/assets/**/*")) if args.apk_dir.exists() else []
    proto_assets = [f for f in asset_files if f.suffix in (".proto", ".pb", ".bin", ".desc", ".descriptor")]

    if proto_assets:
        for asset in proto_assets:
            print(f"  Found proto asset: {asset}")
            data = asset.read_bytes()
            # Try parsing as FileDescriptorSet
            fds = descriptor_pb2.FileDescriptorSet()
            try:
                fds.ParseFromString(data)
                if fds.file:
                    print(f"    FileDescriptorSet with {len(fds.file)} protos!")
                    for fdp in fds.file:
                        all_protos.append(fdp)
                        write_proto_file(fdp, args.output_dir)
            except Exception:
                pass
    else:
        print("  No proto assets found.")

    # Summary
    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"Proto files recovered:     {len(all_protos)}")
    print(f"Libraries with AA strings: {len(all_strings)}")
    print(f"Runtime registrations:     {len(all_registrations)}")

    if all_protos:
        print(f"\nRecovered .proto files written to: {args.output_dir}")
        for fdp in all_protos:
            msg_count = sum(1 for _ in fdp.message_type)
            enum_count = sum(1 for _ in fdp.enum_type)
            print(f"  {fdp.name}: {msg_count} messages, {enum_count} enums")

    if all_strings:
        # Write consolidated strings report
        report_path = args.output_dir / "aa_proto_strings_report.txt"
        with open(report_path, "w") as f:
            for lib_name, categories in sorted(all_strings.items()):
                f.write(f"\n{'=' * 60}\n")
                f.write(f"Library: {lib_name}\n")
                f.write(f"{'=' * 60}\n")
                for cat, items in sorted(categories.items()):
                    if items:
                        f.write(f"\n--- {cat} ---\n")
                        for item in sorted(items):
                            f.write(f"  {item}\n")
        print(f"\nStrings report written to: {report_path}")

    if not all_protos:
        print("\nNo complete proto definitions found via binary search.")
        print("This likely means the AA app uses protobuf lite runtime.")
        print("")
        print("Next steps:")
        print("  1. Run Frida hooks to intercept proto messages at runtime:")
        print("     python3 frida_aa_hook.py")
        print("  2. Use the strings report above to identify message types")
        print("  3. Capture a live AA session for message correlation:")
        print("     ./capture_aa_session.sh")


if __name__ == "__main__":
    main()
