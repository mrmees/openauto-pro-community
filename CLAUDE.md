# OpenAuto Pro Community - Project Context

## What This Is

Community revival of OpenAuto Pro, a Raspberry Pi Android Auto head unit app. The original company (BlueWave Studio) shut down without releasing source code. We're reverse-engineering the v16.1 binary to rebuild it as open source.

**GitHub:** https://github.com/mrmees/openauto-pro-community

## Key Architecture

- **Original binary:** `autoapp` — 28MB stripped ARM (armhf) C++ ELF, BuildID `13030d9465b45b7b39c0154fd86783b1c20f90e1`
- **Build env:** Qt 5.11, Boost 1.67, protobuf 17, OpenSSL 1.1, built on Raspberry Pi OS
- **Namespace:** `f1x::openauto::autoapp::` with sub-namespaces: androidauto, autobox, bluetooth, mirroring, obd, audio, ui, api, system
- **Open-source foundation:** f1xpl/openauto + f1xpl/aasdk (both GPLv3, frozen since 2018)
- **UI:** Qt Quick/QML — fully recovered (162 files in `original/qml/`)
- **API:** Protobuf plugin API — fully recovered (34 messages in `original/proto/Api.proto`)

## File Locations (outside repo)

| Path | Contents |
|------|----------|
| `../bluewavestudio-openauto-pro-release-16.1.img` | Original disk image (7.3GB, MBR, FAT32 boot + ext4 root) |
| `../1.img` | Extracted ext4 root partition (browsable with 7-Zip) |
| `../extracted/autoapp` | Main binary (28MB ARM ELF) |
| `../extracted/controller_service` | Companion service binary (457KB) |
| `../extracted/libaasdk.so` | Android Auto SDK shared library (884KB) |
| `../extracted/libaasdk_proto.so` | AA protobuf definitions library (1.3MB) |
| `../upstream/openauto/` | f1xpl/openauto (original, frozen 2018) |
| `../upstream/aasdk/` | f1xpl/aasdk (original, frozen 2018) |
| `../upstream/sonofgib-openauto/` | SonOfGib's fixed fork (branch: sonofgib-newdev) |
| `../upstream/sonofgib-aasdk/` | SonOfGib's fixed fork (branch: sonofgib-newdev) |
| `../extract_qrc.py` | QML/SVG extraction script (also in tools/) |
| `../extract_proto.py` | Protobuf schema extraction script (also in tools/) |

## Repo Layout

```
original/           # Extracted assets from v16.1 binary
  qml/              # 162 QML files (complete UI)
  images/           # 88 SVG icons
  scripts/          # 7 shell/Python utility scripts
  proto/Api.proto   # Complete plugin API (34 messages)
tools/              # Extraction scripts
docs/               # Research and analysis documents
  android-auto-fix-research.md   # AA 12.7+ fix details
  reverse-engineering-notes.md   # Full RE findings
```

## The Android Auto Bug

**Problem:** AA 12.7+ (Sept 2024) sends WiFi credential requests on channel 14 (WIFI) with message ID `0x8001`. OAP's `WirelessServiceChannel::messageHandler()` has a switch case for message ID `0x0002` (BlueWave's own enum value for CREDENTIALS_REQUEST), which doesn't match. The request falls through to "message not handled" and gets dropped. AA interprets silence as failure → no video.

**Root cause confirmed:** Message ID mismatch between BlueWave's proto enum and what AA actually sends. BlueWave's `WirelessMessage::WIRELESS_CREDENTIALS_REQUEST = 0x0002`, but AA sends `0x8001` (matching SonOfGib's `WifiChannelMessage::CREDENTIALS_REQUEST`).

**Fix (SonOfGib):** Proper WIFIServiceChannel in aasdk + WifiService handler in openauto. Confirmed working with AA 12.8–13.1.

**Fix commits:**
- aasdk: SonOfGib/aasdk@284c366
- openauto: SonOfGib/openauto@e3aa777

**Fix approaches for OAP (updated):**
1. **Binary patch libaasdk.so** — change switch constant from `0x0002` to `0x8001` in messageHandler (~2 bytes, needs Ghidra to find offset)
2. **Binary patch libaasdk_proto.so** — change enum value at address `0x132c74` from `2` to `0x8001` (risky if value used elsewhere)
3. **LD_PRELOAD hook** — intercept `WirelessServiceChannel::messageHandler()`, add case for `0x8001`
4. **Rebuild libaasdk.so** — merge SonOfGib's fix, matching BlueWave ABI (Boost 1.67, protobuf 17, OpenSSL 1.1, armhf)
5. **Full rebuild** — ultimate goal

Drop-in library swap is NOT viable — autoapp imports 3 BlueWave-specific channel classes that don't exist in SonOfGib's build. See `docs/abi-compatibility-analysis.md`.

## Key Binary Offsets

| Binary | Offset | Content |
|--------|--------|---------|
| autoapp | 0x5c1378 | Serialized FileDescriptorProto (Api.proto, 6700 bytes) |
| autoapp | .rodata | QML source (null-terminated UTF-8 blocks) |
| autoapp | .rodata | SVG content (`<svg>` to `</svg>` blocks) |
| libaasdk_proto.so | 0x132c74 | `WirelessMessage::WIRELESS_CREDENTIALS_REQUEST` enum (value: 2, should be 0x8001) |
| libaasdk_proto.so | 0x132c70 | `WirelessMessage::WIRELESS_CREDENTIALS_RESPONSE` enum (value: 3) |

## Technical Notes

- **WSL2 loop device mounting is broken on this machine** — use 7-Zip to browse ext4 images instead
- **Binary is stripped but leaky** — C++ template instantiations, Qt meta-object strings, Boost.Log channels, and error messages reveal class hierarchies and control flow
- **Build path:** `/home/pi/workdir/openauto/`
- **54 shared library dependencies** — see `docs/reverse-engineering-notes.md` for full list

## Next Steps

1. **Ghidra decompilation** — priority targets:
   - `WirelessServiceChannel::messageHandler()` in libaasdk.so — find the switch/compare for binary patch
   - `MessageInStream::receiveFrameHeaderHandler()` — check if interleaving is already fixed
   - `WirelessService` in autoapp — understand application-layer response logic
2. **Attempt binary patch** — simplest fix: patch the message ID constant in libaasdk.so
3. **Test on Pi** — need OAP running on a Pi to validate the fix

## Important Context

- The binary links 54 shared libraries. Key: Qt 5.11 (Quick, QML, Multimedia, DBus), Boost 1.67 (filesystem, system, log, thread), libusb, PulseAudio, BlueZ/KF5BluezQt, Broadcom VideoCore (RPi GPU), libgps, libi2c, librtlsdr
- BlueWave added: QML UI, BT telephony, OBD-II, screen mirroring, music player, FM radio, plugin API, Autobox wireless, equalizer, system services — all on top of upstream openauto/aasdk
- The core AA protocol (aasdk) was modified by BlueWave — added WirelessServiceChannel, NavigationServiceChannel, MediaStatusServiceChannel, and new proto messages. Not a simple fork of upstream.
- BlueWave's WirelessService (in autoapp) reads SSID/password and sends credentials — the application logic exists, it's the channel-level message dispatch that's broken
- SonOfGib's aasdk changes are ~500 lines of functional code (plus namespace rename). Clean, surgical fix.
