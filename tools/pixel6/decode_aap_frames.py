#!/usr/bin/env python3
"""
Decode Android Auto Protocol (AAP) frames from raw binary captures or pcap files.

Parses the AAP wire format (2-byte header + size + message ID + payload) and
outputs human-readable frame descriptions with proto field breakdown.

Supports:
  - Raw TCP stream dumps (from tcpdump -w)
  - PCAP files (via built-in parser, no scapy dependency)
  - Hex dump input (for pasting from Frida or Wireshark)
  - Prodigy-side log parsing

Usage:
    python3 decode_aap_frames.py capture.pcap
    python3 decode_aap_frames.py capture.bin --raw
    python3 decode_aap_frames.py --hex "0a 01 03 00 02 00 ..."
    python3 decode_aap_frames.py capture.pcap --json > decoded.json
    python3 decode_aap_frames.py capture.pcap --stats
"""

import argparse
import json
import struct
import sys
from collections import defaultdict
from pathlib import Path

# Channel names
CHANNELS = {
    0: "CONTROL",
    1: "INPUT",
    2: "SENSOR",
    3: "VIDEO",
    4: "MEDIA_AUDIO",
    5: "SPEECH_AUDIO",
    6: "SYSTEM_AUDIO",
    7: "AV_INPUT",
    8: "BLUETOOTH",
    9: "CH9",
    10: "CH10",
    11: "CH11",
    12: "CH12",
    13: "CH13",
    14: "WIFI",
}

FRAME_TYPES = {0: "MIDDLE", 1: "FIRST", 2: "LAST", 3: "BULK"}
MSG_TYPES = {0: "SPECIFIC", 0x04: "CONTROL"}
ENC_TYPES = {0: "PLAIN", 0x08: "ENCRYPTED"}

# Known control message IDs
CONTROL_MSGS = {
    0x0001: "VERSION_REQUEST",
    0x0002: "VERSION_RESPONSE",
    0x0003: "SSL_HANDSHAKE",
    0x0004: "AUTH_COMPLETE",
    0x0005: "SERVICE_DISCOVERY_REQUEST",
    0x0006: "SERVICE_DISCOVERY_RESPONSE",
    0x0007: "CHANNEL_OPEN_REQUEST",
    0x0008: "CHANNEL_OPEN_RESPONSE",
    0x000b: "PING_REQUEST",
    0x000c: "PING_RESPONSE",
    0x000d: "NAV_FOCUS_REQUEST",
    0x000e: "NAV_FOCUS_RESPONSE",
    0x000f: "SHUTDOWN_REQUEST",
    0x0010: "SHUTDOWN_RESPONSE",
    0x0011: "VOICE_SESSION_REQUEST",
    0x0012: "AUDIO_FOCUS_REQUEST",
    0x0013: "AUDIO_FOCUS_RESPONSE",
}

# Known channel-specific message IDs
CHANNEL_MSGS = {
    0x0000: "AV_MEDIA_WITH_TIMESTAMP",
    0x0001: "AV_MEDIA",
    0x8000: "SETUP_REQUEST",
    0x8001: "START_INDICATION",
    0x8002: "STOP_INDICATION",
    0x8003: "SETUP_RESPONSE",
    0x8004: "AV_MEDIA_ACK",
    0x8005: "AV_INPUT_OPEN_REQUEST",
    0x8006: "AV_INPUT_OPEN_RESPONSE",
    0x8007: "VIDEO_FOCUS_REQUEST",
    0x8008: "VIDEO_FOCUS_INDICATION",
}

# Bluetooth/WiFi channel message IDs (0x8001/0x8002 overlap with AV but context differs)
BT_WIFI_MSGS = {
    0x8001: "BT_PAIRING_REQUEST / WIFI_CREDENTIALS_REQUEST",
    0x8002: "BT_PAIRING_RESPONSE / WIFI_CREDENTIALS_RESPONSE",
}


class AAPFrame:
    """Parsed AAP frame."""
    def __init__(self):
        self.channel_id = 0
        self.flags = 0
        self.frame_type = 0
        self.msg_type = 0
        self.enc_type = 0
        self.frame_size = 0
        self.total_size = 0  # Only for FIRST frames
        self.msg_id = None
        self.payload = b""
        self.offset = 0

    @property
    def channel_name(self):
        return CHANNELS.get(self.channel_id, f"CH{self.channel_id}")

    @property
    def frame_type_name(self):
        return FRAME_TYPES.get(self.frame_type, f"FT{self.frame_type}")

    @property
    def msg_type_name(self):
        return MSG_TYPES.get(self.msg_type, "UNKNOWN")

    @property
    def enc_type_name(self):
        return ENC_TYPES.get(self.enc_type, "UNKNOWN")

    @property
    def msg_name(self):
        if self.msg_id is None:
            return "N/A"
        if self.msg_type == 0x04:  # CONTROL
            return CONTROL_MSGS.get(self.msg_id, f"0x{self.msg_id:04x}")
        if self.channel_id in (8, 14):  # BT or WiFi
            return BT_WIFI_MSGS.get(self.msg_id, CHANNEL_MSGS.get(self.msg_id, f"0x{self.msg_id:04x}"))
        return CHANNEL_MSGS.get(self.msg_id, f"0x{self.msg_id:04x}")

    def to_dict(self):
        d = {
            "offset": self.offset,
            "channel": self.channel_name,
            "channel_id": self.channel_id,
            "frame_type": self.frame_type_name,
            "msg_type": self.msg_type_name,
            "encryption": self.enc_type_name,
            "frame_size": self.frame_size,
            "msg_id": self.msg_name,
            "payload_size": len(self.payload),
        }
        if self.total_size:
            d["total_size"] = self.total_size
        if self.payload and len(self.payload) < 512:
            d["payload_hex"] = self.payload.hex()
            fields = parse_proto_fields(self.payload)
            if fields:
                d["proto_fields"] = fields
        return d

    def __str__(self):
        parts = [
            f"[0x{self.offset:06x}]",
            f"ch={self.channel_name:<14s}",
            f"{self.frame_type_name:<6s}",
            f"{self.enc_type_name:<9s}",
            f"msg={self.msg_name:<30s}",
            f"len={self.frame_size}",
        ]
        if self.total_size:
            parts.append(f"total={self.total_size}")
        return " ".join(parts)


def parse_proto_fields(data: bytes) -> list:
    """Minimal protobuf field parser for display."""
    fields = []
    pos = 0
    while pos < len(data) and len(fields) < 30:
        tag, new_pos = read_varint(data, pos)
        if tag is None or new_pos >= len(data):
            break
        pos = new_pos

        field_num = tag >> 3
        wire_type = tag & 0x07

        if field_num == 0 or field_num > 10000:
            break

        if wire_type == 0:  # varint
            val, pos = read_varint(data, pos)
            if val is None:
                break
            fields.append({"field": field_num, "type": "varint", "value": val})
        elif wire_type == 1:  # 64-bit
            if pos + 8 > len(data):
                break
            pos += 8
            fields.append({"field": field_num, "type": "fixed64"})
        elif wire_type == 2:  # length-delimited
            length, pos = read_varint(data, pos)
            if length is None or pos + length > len(data):
                break
            chunk = data[pos:pos + length]
            pos += length
            # Try string interpretation
            try:
                text = chunk.decode("utf-8")
                if all(0x20 <= ord(c) < 0x7f or c in "\n\r\t" for c in text):
                    fields.append({"field": field_num, "type": "string", "value": text})
                    continue
            except (UnicodeDecodeError, ValueError):
                pass
            # Check if it looks like nested proto
            nested = parse_proto_fields(chunk)
            if nested:
                fields.append({"field": field_num, "type": "message", "fields": nested})
            else:
                fields.append({"field": field_num, "type": "bytes", "length": length})
        elif wire_type == 5:  # 32-bit
            if pos + 4 > len(data):
                break
            pos += 4
            fields.append({"field": field_num, "type": "fixed32"})
        else:
            break

    return fields


def read_varint(data: bytes, pos: int):
    """Read a protobuf varint, return (value, new_pos) or (None, pos) on failure."""
    result = 0
    shift = 0
    while pos < len(data):
        b = data[pos]
        result |= (b & 0x7F) << shift
        pos += 1
        if not (b & 0x80):
            return result, pos
        shift += 7
        if shift > 35:
            return None, pos
    return None, pos


def parse_aap_stream(data: bytes) -> list:
    """Parse a raw AAP byte stream into frames."""
    frames = []
    pos = 0

    while pos + 2 <= len(data):
        frame = AAPFrame()
        frame.offset = pos

        # Frame header (2 bytes)
        frame.channel_id = data[pos]
        frame.flags = data[pos + 1]
        frame.frame_type = frame.flags & 0x03
        frame.msg_type = frame.flags & 0x04
        frame.enc_type = frame.flags & 0x08
        pos += 2

        # Sanity check
        if frame.channel_id > 30:
            # Probably not a valid frame — skip byte and retry
            pos -= 1
            continue

        # Frame size
        if frame.frame_type == 1:  # FIRST — 6-byte extended size
            if pos + 6 > len(data):
                break
            frame.frame_size = struct.unpack(">H", data[pos:pos + 2])[0]
            frame.total_size = struct.unpack(">I", data[pos + 2:pos + 6])[0]
            pos += 6
        else:  # MIDDLE, LAST, BULK — 2-byte size
            if pos + 2 > len(data):
                break
            frame.frame_size = struct.unpack(">H", data[pos:pos + 2])[0]
            pos += 2

        # Payload
        payload_size = frame.frame_size
        if pos + payload_size > len(data):
            # Truncated capture
            frame.payload = data[pos:]
            frames.append(frame)
            break

        raw_payload = data[pos:pos + payload_size]
        pos += payload_size

        # Extract message ID from first frame or bulk frame
        if frame.frame_type in (1, 3) and len(raw_payload) >= 2:  # FIRST or BULK
            frame.msg_id = struct.unpack(">H", raw_payload[:2])[0]
            frame.payload = raw_payload[2:]
        else:
            frame.payload = raw_payload

        frames.append(frame)

    return frames


def parse_pcap(filepath: Path) -> bytes:
    """
    Extract TCP payload from a pcap file.
    Simple parser — handles standard pcap (not pcapng).
    """
    data = filepath.read_bytes()

    if len(data) < 24:
        print("ERROR: File too small for pcap header", file=sys.stderr)
        return b""

    # Pcap global header
    magic = struct.unpack("<I", data[:4])[0]
    if magic == 0xa1b2c3d4:
        endian = "<"
    elif magic == 0xd4c3b2a1:
        endian = ">"
    else:
        print(f"Not a pcap file (magic: 0x{magic:08x}). Treating as raw stream.", file=sys.stderr)
        return data

    # Parse global header
    _, ver_major, ver_minor, _, _, snaplen, link_type = struct.unpack(
        f"{endian}IHHiIII", data[:24]
    )

    # Determine link layer header size
    if link_type == 1:     # Ethernet
        ll_header = 14
    elif link_type == 113:  # Linux cooked capture
        ll_header = 16
    elif link_type == 0:    # Loopback
        ll_header = 4
    else:
        print(f"WARNING: Unknown link type {link_type}, assuming 14-byte header", file=sys.stderr)
        ll_header = 14

    # Extract TCP payloads
    tcp_data = bytearray()
    pos = 24  # After global header

    while pos + 16 <= len(data):
        # Packet header: ts_sec, ts_usec, incl_len, orig_len
        ts_sec, ts_usec, incl_len, orig_len = struct.unpack(
            f"{endian}IIII", data[pos:pos + 16]
        )
        pos += 16

        if pos + incl_len > len(data):
            break

        packet = data[pos:pos + incl_len]
        pos += incl_len

        if len(packet) < ll_header:
            continue

        # Skip link layer header
        ip_start = ll_header

        # Parse IP header
        if ip_start >= len(packet):
            continue
        ip_version = (packet[ip_start] >> 4) & 0x0F
        if ip_version != 4:
            continue

        ip_header_len = (packet[ip_start] & 0x0F) * 4
        ip_protocol = packet[ip_start + 9]

        if ip_protocol != 6:  # Not TCP
            continue

        tcp_start = ip_start + ip_header_len
        if tcp_start + 20 > len(packet):
            continue

        # Parse TCP header
        tcp_header_len = ((packet[tcp_start + 12] >> 4) & 0x0F) * 4
        tcp_payload_start = tcp_start + tcp_header_len

        if tcp_payload_start < len(packet):
            tcp_data.extend(packet[tcp_payload_start:])

    return bytes(tcp_data)


def print_stats(frames: list):
    """Print summary statistics."""
    channel_counts = defaultdict(int)
    msg_counts = defaultdict(int)
    channel_bytes = defaultdict(int)

    for f in frames:
        channel_counts[f.channel_name] += 1
        msg_counts[f"{f.channel_name}:{f.msg_name}"] += 1
        channel_bytes[f.channel_name] += f.frame_size

    print("\n=== Frame Statistics ===\n")
    print(f"Total frames: {len(frames)}")
    print(f"\nBy channel:")
    for ch, count in sorted(channel_counts.items(), key=lambda x: -x[1]):
        print(f"  {ch:<14s}  {count:>6d} frames  {channel_bytes[ch]:>10,d} bytes")

    print(f"\nBy message type:")
    for msg, count in sorted(msg_counts.items(), key=lambda x: -x[1]):
        if count > 1 or "AV_MEDIA" not in msg:  # Skip individual AV frames
            print(f"  {msg:<40s}  {count:>6d}")


def main():
    parser = argparse.ArgumentParser(description="Decode AAP frames")
    parser.add_argument("input", nargs="?", help="Input file (pcap or raw binary)")
    parser.add_argument("--raw", action="store_true", help="Treat input as raw AAP stream (not pcap)")
    parser.add_argument("--hex", type=str, help="Decode hex string instead of file")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    parser.add_argument("--stats", action="store_true", help="Print statistics only")
    parser.add_argument("--no-av", action="store_true", help="Skip AV media frames (reduce noise)")
    parser.add_argument("--channel", type=int, help="Filter to specific channel ID")
    args = parser.parse_args()

    # Get input data
    if args.hex:
        raw = bytes.fromhex(args.hex.replace(" ", "").replace("\n", ""))
        frames = parse_aap_stream(raw)
    elif args.input:
        filepath = Path(args.input)
        if not filepath.exists():
            print(f"ERROR: File not found: {filepath}", file=sys.stderr)
            sys.exit(1)

        if args.raw:
            raw = filepath.read_bytes()
        else:
            raw = parse_pcap(filepath)
            if not raw:
                print("No TCP data extracted from pcap. Try --raw if input is a raw stream.", file=sys.stderr)
                sys.exit(1)

        print(f"Extracted {len(raw):,} bytes of TCP payload", file=sys.stderr)
        frames = parse_aap_stream(raw)
    else:
        parser.print_help()
        sys.exit(1)

    # Apply filters
    if args.no_av:
        frames = [f for f in frames if f.channel_id not in (3, 4, 5, 6, 7) or (f.msg_id is not None and f.msg_id >= 0x8000)]
    if args.channel is not None:
        frames = [f for f in frames if f.channel_id == args.channel]

    print(f"Decoded {len(frames)} frames", file=sys.stderr)

    # Output
    if args.stats:
        print_stats(frames)
    elif args.json:
        output = [f.to_dict() for f in frames]
        print(json.dumps(output, indent=2))
    else:
        for f in frames:
            print(f)
            # Print proto fields for non-AV control/setup messages
            if f.payload and len(f.payload) < 1024 and f.msg_id is not None and f.msg_id >= 0x8000:
                fields = parse_proto_fields(f.payload)
                if fields:
                    for field in fields:
                        print(f"    field {field['field']}: {field.get('value', field.get('type', '?'))}")


if __name__ == "__main__":
    main()
