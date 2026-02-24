#!/usr/bin/env python3
"""
Extract Qt Compiled Resources (qrc/rcc) from an ELF binary.

Qt's rcc compiler embeds resources as three data structures:
1. Resource tree (directory/file structure)
2. Resource names (UTF-16 encoded filenames)
3. Resource data (file contents with size prefix)

These are registered via qt_resource_struct, qt_resource_name, qt_resource_data
symbols, but since the binary is stripped we find them by pattern matching.
"""

import struct
import sys
import os

def find_rcc_data(data):
    """
    Find Qt resource registration function patterns.

    Qt resources are registered with qRegisterResourceData() which takes:
    - version (int, usually 1, 2, or 3)
    - tree pointer
    - name pointer
    - data pointer

    The resource tree entries are 14 bytes each (v1) or 22 bytes (v2/v3):
    v1: name_offset(4) flags(2) child_count(4) first_child(4) -- directory
    v1: name_offset(4) flags(2) country(2) language(2) data_offset(4) -- file
    """
    results = []

    # Search for the resource name table patterns
    # Qt resource names are stored as: hash(4) + length(2) + utf16_chars
    # Look for sequences of printable UTF-16 strings preceded by hash+length

    # Alternative: search for known resource paths we found in strings
    known_paths = [
        b'fonts/NotoSans-Regular.ttf',
        b'fonts/NotoColorEmoji.ttf',
        b'images/ico_navigation.svg',
        b'images/ico_androidauto.svg',
    ]

    for path in known_paths:
        offset = data.find(path)
        if offset != -1:
            print(f"  Found '{path.decode()}' at offset 0x{offset:x}")

    return results


def extract_qml_from_strings(data):
    """
    Extract QML file content by finding contiguous blocks of QML code.

    Qt's qrc compiler stores file data as: length(4 bytes BE) + raw content
    QML files start with 'import' statements.
    """
    qml_files = []

    # Find all positions where QML imports start
    search = b'import QtQuick'
    pos = 0
    while True:
        idx = data.find(search, pos)
        if idx == -1:
            break

        # Walk backwards to find the start of this resource data blob
        # Qt resource data entries are prefixed with a 4-byte big-endian length
        # Try reading 4 bytes before the start of the QML content

        # First, find the actual start of this QML file
        # Walk backwards to find either the length prefix or another boundary
        start = idx
        for back in range(1, 256):
            if idx - back < 0:
                break
            ch = data[idx - back]
            # Look for the length prefix - should be followed immediately by content
            if back <= 8:
                # Check if 4 bytes before content start is a valid length
                potential_len_offset = idx - back
                if potential_len_offset >= 4:
                    length = struct.unpack('>I', data[potential_len_offset-4:potential_len_offset])[0]
                    # Sanity check: length should be reasonable (100 bytes to 100KB)
                    if 100 < length < 100000:
                        content = data[potential_len_offset:potential_len_offset + length]
                        # Verify it looks like QML
                        try:
                            text = content.decode('utf-8', errors='strict')
                            if 'import' in text and ('QtQuick' in text or 'OpenAuto' in text):
                                qml_files.append((potential_len_offset, length, text))
                                break
                        except:
                            pass

        # Also try: just grab from import to the next null or non-QML boundary
        if not any(offset == idx for offset, _, _ in qml_files):
            # Grab a chunk and find the end
            chunk = data[idx:idx+100000]
            # Find end by looking for null bytes or binary data
            end = len(chunk)
            for i in range(len(chunk)):
                b = chunk[i]
                if b == 0:
                    end = i
                    break

            if end > 50:  # minimum viable QML
                try:
                    text = chunk[:end].decode('utf-8', errors='replace')
                    if 'import' in text:
                        qml_files.append((idx, end, text))
                except:
                    pass

        pos = idx + 1

    return qml_files


def extract_rcc_v2(data):
    """
    Try to find and parse Qt RCC version 2/3 resource structures.

    The compiled resource data has three sections registered together.
    We look for the resource tree structure by its characteristic pattern.
    """

    # In Qt's compiled resources, the tree structure is an array of 14-byte entries (v1)
    # or 22-byte entries (v2). Each entry has:
    # - name_offset: 4 bytes (offset into name table)
    # - flags: 2 bytes (0x0000 for files, 0x0002 for directories, 0x0001 for compressed)
    # - For directories: child_count(4) + first_child_offset(4)
    # - For files: country(2) + language(2) + data_offset(4)
    # v2 adds: last_modified(8)

    # Search for the resource data section marker
    # Resource data entries are: length(4 BE) + content
    # We look for known font file signatures preceded by a length

    # TTF files start with 0x00010000 or 'true' or 'OTTO'
    ttf_magic = b'\x00\x01\x00\x00'

    print("\nSearching for embedded TTF fonts (resource data markers)...")
    pos = 0
    font_locations = []
    while True:
        idx = data.find(ttf_magic, pos)
        if idx == -1 or idx > len(data) - 8:
            break

        # Check if preceded by a 4-byte BE length that makes sense
        if idx >= 4:
            length = struct.unpack('>I', data[idx-4:idx])[0]
            if 10000 < length < 20000000:  # fonts are typically 10KB-20MB
                # Verify by checking tables after the header
                num_tables = struct.unpack('>H', data[idx+4:idx+6])[0]
                if 5 < num_tables < 50:  # reasonable number of font tables
                    print(f"  Likely font at 0x{idx:x}, declared length={length}, tables={num_tables}")
                    font_locations.append((idx-4, length))

        pos = idx + 1
        if len(font_locations) > 20:
            break

    return font_locations


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <binary> [output_dir]")
        sys.exit(1)

    binary_path = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else 'extracted_resources'

    print(f"Reading {binary_path}...")
    with open(binary_path, 'rb') as f:
        data = f.read()
    print(f"  Size: {len(data):,} bytes")

    # Step 1: Find known resource paths
    print("\n=== Searching for known resource paths ===")
    find_rcc_data(data)

    # Step 2: Extract QML content
    print("\n=== Extracting embedded QML files ===")
    qml_files = extract_qml_from_strings(data)
    print(f"  Found {len(qml_files)} QML blocks")

    os.makedirs(os.path.join(output_dir, 'qml'), exist_ok=True)
    for i, (offset, length, content) in enumerate(qml_files):
        # Try to determine filename from content
        fname = f'qml/unknown_{i:03d}_0x{offset:x}.qml'

        # Look for component names in the content
        for line in content.split('\n'):
            line = line.strip()
            if line.startswith('id:'):
                component_id = line.split(':')[1].strip()
                if component_id and len(component_id) < 50:
                    fname = f'qml/{component_id}.qml'
                    break

        filepath = os.path.join(output_dir, fname)
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  [{i}] Offset 0x{offset:x}, {length} bytes -> {fname}")
        # Print first 2 lines as preview
        preview = content.split('\n')[:3]
        for line in preview:
            print(f"       {line.rstrip()[:100]}")

    # Step 3: Look for resource data structure
    print("\n=== Searching for resource data structures ===")
    extract_rcc_v2(data)

    # Step 4: Extract SVG content
    print("\n=== Extracting embedded SVGs ===")
    os.makedirs(os.path.join(output_dir, 'images'), exist_ok=True)
    svg_start = b'<svg '
    svg_alt = b'<?xml'
    pos = 0
    svg_count = 0
    while True:
        idx = data.find(svg_start, pos)
        if idx == -1:
            break

        # Find the closing </svg> tag
        end_tag = data.find(b'</svg>', idx)
        if end_tag != -1:
            end_tag += 6  # include the closing tag
            svg_data = data[idx:end_tag]
            try:
                svg_text = svg_data.decode('utf-8')
                filepath = os.path.join(output_dir, f'images/svg_{svg_count:03d}_0x{idx:x}.svg')
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(svg_text)
                print(f"  SVG at 0x{idx:x}, {len(svg_data)} bytes -> {filepath}")
                svg_count += 1
            except:
                pass

        pos = idx + 1
        if svg_count > 100:
            break

    print(f"\n=== Summary ===")
    print(f"  QML files: {len(qml_files)}")
    print(f"  SVG files: {svg_count}")
    print(f"  Output directory: {output_dir}")


if __name__ == '__main__':
    main()
