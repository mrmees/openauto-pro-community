#!/usr/bin/env python3
"""
Extract and decode the serialized protobuf FileDescriptorProto from the autoapp binary.

Protobuf's generated code embeds a serialized FileDescriptorProto that contains
the complete schema definition. We find it by searching for the file name "Api.proto"
and then scanning backwards to find the start of the serialized descriptor.
"""

import struct
import sys

from google.protobuf import descriptor_pb2


def find_file_descriptor(data, filename=b'Api.proto'):
    """Find serialized FileDescriptorProto in binary data."""
    results = []
    pos = 0

    while True:
        idx = data.find(filename, pos)
        if idx == -1:
            break

        # FileDescriptorProto format:
        # field 1 (name) = tag 0x0a + length + "Api.proto"
        # The tag 0x0a should be right before the length byte

        name_len = len(filename)

        # Check if preceded by tag(0x0a) + length
        for back in range(1, 4):
            check_pos = idx - back
            if check_pos < 0:
                continue

            # Check for varint length encoding
            if back == 1 and data[check_pos] == name_len:
                # Simple case: tag at check_pos - 1
                if check_pos > 0 and data[check_pos - 1] == 0x0a:
                    start = check_pos - 1
                    results.append(start)
                    print(f"  Potential descriptor at 0x{start:x} (tag+len+name)")
            elif back == 2 and data[check_pos] == 0x0a and data[check_pos + 1] == name_len:
                start = check_pos
                results.append(start)
                print(f"  Potential descriptor at 0x{start:x} (tag+len+name)")

        pos = idx + 1

    return results


def try_decode_descriptor(data, start, max_size=50000):
    """Try to decode a FileDescriptorProto starting at the given offset."""
    for size in range(100, max_size, 100):
        try:
            chunk = data[start:start + size]
            desc = descriptor_pb2.FileDescriptorProto()
            consumed = desc.ParseFromString(chunk)

            # Validate: should have name = "Api.proto" and package
            if desc.name == "Api.proto" and desc.package:
                # Check that we got meaningful content
                if len(desc.message_type) > 0 or len(desc.enum_type) > 0:
                    return desc, consumed
        except Exception:
            continue

    return None, 0


def descriptor_to_proto(desc):
    """Convert a FileDescriptorProto to .proto file text."""
    lines = []
    lines.append(f'syntax = "proto2";')
    lines.append(f'')
    lines.append(f'package {desc.package};')
    lines.append(f'')

    # Enums
    for enum in desc.enum_type:
        lines.append(f'enum {enum.name} {{')
        for val in enum.value:
            lines.append(f'    {val.name} = {val.number};')
        lines.append(f'}}')
        lines.append(f'')

    # Messages
    for msg in desc.message_type:
        lines.extend(format_message(msg, indent=0))
        lines.append(f'')

    return '\n'.join(lines)


def format_message(msg, indent=0):
    """Format a DescriptorProto as .proto text."""
    prefix = '    ' * indent
    lines = []
    lines.append(f'{prefix}message {msg.name} {{')

    # Nested enums
    for enum in msg.enum_type:
        lines.append(f'{prefix}    enum {enum.name} {{')
        for val in enum.value:
            lines.append(f'{prefix}        {val.name} = {val.number};')
        lines.append(f'{prefix}    }}')
        lines.append(f'')

    # Nested messages
    for nested in msg.nested_type:
        lines.extend(format_message(nested, indent + 1))
        lines.append(f'')

    # Fields
    type_names = {
        1: 'double', 2: 'float', 3: 'int64', 4: 'uint64', 5: 'int32',
        6: 'fixed64', 7: 'fixed32', 8: 'bool', 9: 'string', 10: 'group',
        11: 'message', 12: 'bytes', 13: 'uint32', 14: 'enum', 15: 'sfixed32',
        16: 'sfixed64', 17: 'sint32', 18: 'sint64'
    }

    label_names = {1: 'optional', 2: 'required', 3: 'repeated'}

    for field in msg.field:
        label = label_names.get(field.label, 'optional')

        if field.type in (11, 14):  # message or enum reference
            type_name = field.type_name
            if type_name.startswith('.'):
                type_name = type_name[1:]
        else:
            type_name = type_names.get(field.type, f'unknown_{field.type}')

        lines.append(f'{prefix}    {label} {type_name} {field.name} = {field.number};')

    lines.append(f'{prefix}}}')
    return lines


def main():
    binary_path = sys.argv[1] if len(sys.argv) > 1 else 'extracted/autoapp'
    output_path = sys.argv[2] if len(sys.argv) > 2 else 'Api.proto'

    print(f"Reading {binary_path}...")
    with open(binary_path, 'rb') as f:
        data = f.read()

    print(f"Searching for FileDescriptorProto...")
    starts = find_file_descriptor(data)

    if not starts:
        print("No FileDescriptorProto found!")
        return

    for start in starts:
        print(f"\nTrying to decode from 0x{start:x}...")
        desc, consumed = try_decode_descriptor(data, start)

        if desc:
            print(f"  SUCCESS! Consumed {consumed} bytes")
            print(f"  Package: {desc.package}")
            print(f"  Messages: {len(desc.message_type)}")
            print(f"  Enums: {len(desc.enum_type)}")

            for msg in desc.message_type:
                print(f"    - {msg.name} ({len(msg.field)} fields, {len(msg.enum_type)} enums)")

            proto_text = descriptor_to_proto(desc)

            with open(output_path, 'w') as f:
                f.write(proto_text)
            print(f"\n  Written to {output_path}")
            print(f"\n--- Proto file content ---")
            print(proto_text)
            return

    print("Could not decode any descriptors")


if __name__ == '__main__':
    main()
