#!/usr/bin/env bash
# Pull the Android Auto APK and its native libraries from a connected device
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
APK_DIR="$OUTPUT_DIR/apk"
LIB_DIR="$OUTPUT_DIR/libs"

mkdir -p "$APK_DIR" "$LIB_DIR"

AA_PACKAGE="com.google.android.projection.gearhead"

echo "=== Pulling Android Auto APK ==="

# Get the APK path(s) — may be split APKs
echo "Finding APK paths for $AA_PACKAGE..."
APK_PATHS=$(adb shell pm path "$AA_PACKAGE" 2>/dev/null | sed 's/package://')

if [ -z "$APK_PATHS" ]; then
    echo "ERROR: Android Auto not installed on device."
    echo "Install it from Play Store first."
    exit 1
fi

echo "Found APK paths:"
echo "$APK_PATHS"
echo ""

# Pull each APK
for APK_PATH in $APK_PATHS; do
    APK_PATH=$(echo "$APK_PATH" | tr -d '\r')
    FILENAME=$(basename "$APK_PATH")
    echo "Pulling $FILENAME..."
    adb pull "$APK_PATH" "$APK_DIR/$FILENAME"
done

# Get version info
AA_VERSION=$(adb shell dumpsys package "$AA_PACKAGE" | grep "versionName" | head -1 | awk -F= '{print $2}' | tr -d '\r')
AA_VERSION_CODE=$(adb shell dumpsys package "$AA_PACKAGE" | grep "versionCode" | head -1 | awk -F'[ =]' '{for(i=1;i<=NF;i++) if($i=="versionCode") print $(i+1)}' | tr -d '\r')
echo ""
echo "Android Auto version: $AA_VERSION (code: $AA_VERSION_CODE)"
echo "$AA_VERSION" > "$APK_DIR/VERSION"

# Extract native libraries from APKs
echo ""
echo "=== Extracting native libraries ==="
for APK in "$APK_DIR"/*.apk; do
    echo "Extracting from $(basename "$APK")..."
    # Extract lib/ directory from APK (which is a ZIP)
    unzip -o -q "$APK" "lib/*" -d "$APK_DIR/extracted_$(basename "$APK" .apk)" 2>/dev/null || true
    # Extract classes.dex files
    unzip -o -q "$APK" "classes*.dex" -d "$APK_DIR/extracted_$(basename "$APK" .apk)" 2>/dev/null || true
    # Extract assets (may contain proto files or configs)
    unzip -o -q "$APK" "assets/*" -d "$APK_DIR/extracted_$(basename "$APK" .apk)" 2>/dev/null || true
done

# Collect all native .so files into libs/
echo ""
echo "=== Collecting native libraries ==="
find "$APK_DIR" -name "*.so" -exec cp -v {} "$LIB_DIR/" \;

# Also pull from the device's lib directory (may have additional libs)
echo ""
echo "=== Pulling device-side native libraries ==="
DEVICE_LIB_DIR=$(adb shell pm path "$AA_PACKAGE" | head -1 | sed 's|package:||;s|/[^/]*\.apk||' | tr -d '\r')
if [ -n "$DEVICE_LIB_DIR" ]; then
    echo "App lib dir: $DEVICE_LIB_DIR"
    # Pull the app's native lib directory if it exists
    adb pull "$DEVICE_LIB_DIR/lib/" "$LIB_DIR/device_libs/" 2>/dev/null || echo "  No separate lib directory on device."
fi

# Summary
echo ""
echo "=== Summary ==="
echo "APK files:  $(find "$APK_DIR" -name "*.apk" | wc -l)"
echo "DEX files:  $(find "$APK_DIR" -name "*.dex" | wc -l)"
echo "SO files:   $(find "$LIB_DIR" -name "*.so" | wc -l)"
echo "Assets:     $(find "$APK_DIR" -path "*/assets/*" -type f | wc -l)"
echo ""
echo "Native libraries:"
find "$LIB_DIR" -name "*.so" -printf "  %f (%s bytes)\n" | sort
echo ""
echo "Output: $OUTPUT_DIR"
echo ""
echo "Next: python3 extract_aa_protos.py"
