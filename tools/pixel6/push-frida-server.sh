#!/usr/bin/env bash
# Push frida-server to rooted Pixel 6 and start it
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRIDA_SERVER="$SCRIPT_DIR/frida-server/frida-server"

if [ ! -f "$FRIDA_SERVER" ]; then
    echo "ERROR: frida-server not found. Run setup.sh first."
    exit 1
fi

echo "Checking for connected device..."
adb wait-for-device
DEVICE=$(adb devices | grep -v "List" | grep "device$" | head -1 | awk '{print $1}')
if [ -z "$DEVICE" ]; then
    echo "ERROR: No device found. Enable USB debugging on the Pixel 6."
    exit 1
fi
echo "Device: $DEVICE"

echo "Pushing frida-server to /data/local/tmp/..."
adb push "$FRIDA_SERVER" /data/local/tmp/frida-server

echo "Setting permissions and starting frida-server..."
adb shell "su -c 'chmod 755 /data/local/tmp/frida-server'"

# Kill existing instance if running
adb shell "su -c 'pkill -f frida-server || true'"
sleep 1

# Start in background
adb shell "su -c '/data/local/tmp/frida-server -D &'" &
sleep 2

# Verify
if frida-ps -U | head -5 >/dev/null 2>&1; then
    echo "Frida server is running. Process list:"
    frida-ps -U | head -10
    echo "..."
else
    echo "WARNING: frida-ps couldn't connect. Check that:"
    echo "  1. Phone is rooted (Magisk/KernelSU)"
    echo "  2. USB debugging is enabled"
    echo "  3. frida-server architecture matches (arm64 for Pixel 6)"
fi
