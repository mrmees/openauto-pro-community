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

**Problem:** AA 12.7+ (Sept 2024) sends WiFi credential requests. OAP's WifiService is a stub that ignores them. AA interprets silence as failure → no video.

**Fix (SonOfGib):** Proper WIFIServiceChannel in aasdk + WifiService handler in openauto. Confirmed working with AA 12.8–13.1.

**Fix commits:**
- aasdk: SonOfGib/aasdk@284c366
- openauto: SonOfGib/openauto@e3aa777

**Approaches for OAP:** (1) binary patch to disable WiFi channel, (2) library swap with rebuilt libaasdk.so, (3) LD_PRELOAD hook, (4) full rebuild. See `docs/android-auto-fix-research.md`.

## Key Binary Offsets

| Offset | Content |
|--------|---------|
| 0x5c1378 | Serialized FileDescriptorProto (Api.proto, 6700 bytes) |
| .rodata section | QML source (null-terminated UTF-8 blocks) |
| .rodata section | SVG content (`<svg>` to `</svg>` blocks) |

## Technical Notes

- **WSL2 loop device mounting is broken on this machine** — use 7-Zip to browse ext4 images instead
- **Binary is stripped but leaky** — C++ template instantiations, Qt meta-object strings, Boost.Log channels, and error messages reveal class hierarchies and control flow
- **Build path:** `/home/pi/workdir/openauto/`
- **54 shared library dependencies** — see `docs/reverse-engineering-notes.md` for full list

## Next Steps

1. **Ghidra decompilation** — focus on ServiceFactory::create(), WifiService::fillFeatures(), AndroidAutoEntity (handshake/version), channel dispatch
2. **Library compatibility check** — can SonOfGib's rebuilt libaasdk.so drop into OAP? (same Boost/protobuf/OpenSSL ABI?)
3. **Choose fix approach** — binary patch vs library swap vs full rebuild
4. **Map BlueWave modifications** vs upstream openauto using SonOfGib's fork as reference

## Important Context

- The binary links 54 shared libraries. Key: Qt 5.11 (Quick, QML, Multimedia, DBus), Boost 1.67 (filesystem, system, log, thread), libusb, PulseAudio, BlueZ/KF5BluezQt, Broadcom VideoCore (RPi GPU), libgps, libi2c, librtlsdr
- BlueWave added: QML UI, BT telephony, OBD-II, screen mirroring, music player, FM radio, plugin API, Autobox wireless, equalizer, system services — all on top of upstream openauto/aasdk
- The core AA protocol (aasdk) is relatively unchanged from upstream
