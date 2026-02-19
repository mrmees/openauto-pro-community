# Pixel 6 AA Protocol Extraction Tools

Tools for extracting Android Auto protocol definitions from a rooted Pixel 6.

## Prerequisites

- Rooted Pixel 6 (Magisk or KernelSU)
- USB debugging enabled
- Android Auto app installed from Play Store
- USB cable connecting phone to claude-dev VM

## Quick Start

```bash
# 1. Install dependencies (one-time)
./setup.sh

# 2. Push frida-server to phone
./push-frida-server.sh

# 3. Pull AA APK and extract native libraries
./pull-aa-apk.sh

# 4. Search for proto descriptors (static analysis)
python3 extract_aa_protos.py

# 5. If static extraction finds descriptors, you're done!
#    If not, move to dynamic analysis...

# 6. Hook AA app with Frida (dynamic analysis)
python3 frida_aa_hook.py --spawn

# 7. Capture a live AA session (run while connected to Pi HU)
./capture_aa_session.sh

# 8. Decode captured frames
python3 decode_aap_frames.py output/captures/pi_capture_*.pcap
python3 decode_aap_frames.py output/captures/pi_capture_*.pcap --stats
python3 decode_aap_frames.py output/captures/pi_capture_*.pcap --json > decoded.json
```

## Tool Descriptions

| Script | Purpose |
|--------|---------|
| `setup.sh` | Install all dependencies (adb, frida, protobuf, etc.) |
| `push-frida-server.sh` | Push and start frida-server on the phone |
| `pull-aa-apk.sh` | Pull AA APK, extract native .so files and assets |
| `extract_aa_protos.py` | Scan binaries for FileDescriptorProto blobs (static) |
| `frida_aa_hook.js` | Frida hook script (loaded by frida_aa_hook.py) |
| `frida_aa_hook.py` | Python wrapper that runs Frida hooks with logging |
| `capture_aa_session.sh` | Dual-side tcpdump capture (phone + Pi) |
| `decode_aap_frames.py` | Parse and decode AAP wire format frames |

## Strategy

### Phase 1: Static Extraction (fastest)

`extract_aa_protos.py` scans the AA app's native libraries for embedded
protobuf `FileDescriptorProto` blobs. If the app uses the full protobuf
runtime, these contain complete `.proto` definitions with field numbers,
types, and nesting — the holy grail.

If the app uses protobuf-lite (likely for mobile), descriptors are stripped
and we fall back to Phase 2.

### Phase 2: Dynamic Interception (Frida)

`frida_aa_hook.py` attaches to the running AA app and hooks:
- Protobuf `toByteArray()` / `parseFrom()` — captures every serialized message with its Java class name
- Socket I/O — captures raw AAP frames with channel IDs
- Class discovery — enumerates all AA-related Java classes

Run this while connecting to the Pi head unit to capture a complete session.

### Phase 3: Traffic Capture & Decode

`capture_aa_session.sh` runs tcpdump on both the phone and Pi simultaneously.
`decode_aap_frames.py` parses the captures into human-readable frame descriptions
with proto field breakdown.

Use `--stats` for message frequency analysis, `--json` for machine-readable output,
`--no-av` to filter out noisy audio/video data frames.

## Output Directory Structure

```
output/
  apk/           # Raw APK files and extracted contents
  libs/           # Native .so files from the APK
  protos/         # Recovered .proto files (if found)
  captures/       # Pcap and Frida log files
  decoded/        # Decoded frame analysis
```

## Useful Frida Commands

While `frida_aa_hook.py` is running:

```python
# From a separate terminal with frida REPL:
frida -U com.google.android.projection.gearhead

# In REPL:
rpc.exports.stats()        # Print message statistics
rpc.exports.discover()     # List all AA-related classes
rpc.exports.config("logVideoFrames", True)   # Enable video frame logging
rpc.exports.config("logAudioFrames", True)   # Enable audio frame logging
```

## Decode Examples

```bash
# Decode a pcap, show all frames
python3 decode_aap_frames.py capture.pcap

# Only control channel
python3 decode_aap_frames.py capture.pcap --channel 0

# Stats overview
python3 decode_aap_frames.py capture.pcap --stats

# Skip audio/video noise
python3 decode_aap_frames.py capture.pcap --no-av

# Decode raw hex (e.g. from Wireshark copy)
python3 decode_aap_frames.py --hex "00 0b 03 00 04 0a 02 08 00"

# JSON output for further processing
python3 decode_aap_frames.py capture.pcap --json | python3 -m json.tool
```
