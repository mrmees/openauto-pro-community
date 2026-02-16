# OpenAuto Prodigy — Project Context

## Project Direction (Updated 2026-02-16)

**This project has shifted from reverse-engineering/patching to a full clean-room rebuild.**

The new project is called **OpenAuto Prodigy** — a complete open-source replacement for OpenAuto Pro, built from scratch on a modern stack. The recovered QML, protobuf API, icons, and manual serve as specification, not literal code.

**Design document:** `docs/plans/2026-02-16-openauto-prodigy-design.md` — READ THIS FIRST.

**Next step:** Create implementation plan for Phase 1 (skeleton + Android Auto). Use the `writing-plans` skill.

**GitHub:** https://github.com/mrmees/openauto-pro-community (current repo — new `openauto-prodigy` repo to be created when implementation starts)

## Key Decisions

- **Clean-room rebuild** using recovered assets as spec, not code
- **Qt 6.8 / C++17 / CMake** on RPi OS Trixie (Debian 13, 64-bit)
- **SonOfGib's aasdk** as git submodule for AA protocol (includes WiFi fix)
- **Fully independent** — don't fork opencardev/openauto or openDsh/dash (use as reference only)
- **Plugin API:** 100% backward-compatible with BlueWave's published API (TCP + protobuf)
- **Config:** INI format backward-compatible with OAP's `openauto_system.ini`
- **Target hardware:** Raspberry Pi 4 (primary), Pi 5 (secondary)
- **Test hardware:** Pi 4 + DFRobot 7" 1024x600 capacitive touchscreen (HDMI + USB)
- **License:** GPLv3

## Build Phases

1. **Skeleton + Android Auto** — Qt 6 app boots, wired/wireless AA works, basic UI, PipeWire audio
2. **Audio + Bluetooth** — A2DP, HFP, PBAP, music player, equalizer
3. **System Integration** — plugin API, app launcher, camera, sensors, hotspot, keyboard
4. **Extended Features** — mirroring, OBD-II, FM radio, wallpaper

## File Locations

### In This Repo
```
original/           # Recovered assets from OAP v16.1 (reference/spec only)
  qml/              # 162 QML files (complete UI specification)
  images/           # 88 SVG icons
  scripts/          # 7 shell/Python utility scripts
  proto/Api.proto   # Complete plugin API (34 messages)
tools/              # Extraction scripts (extract_qrc.py, extract_proto.py)
docs/               # Research, analysis, and design documents
  plans/            # Design and implementation plans
  reverse-engineering-notes.md   # Full RE findings
  android-auto-fix-research.md   # AA 12.7+ bug details
  abi-compatibility-analysis.md  # Library compatibility analysis
```

### Outside This Repo
| Path | Contents |
|------|----------|
| `../bluewavestudio-openauto-pro-release-16.1.img` | Original disk image (7.3GB) |
| `../1.img` | Extracted ext4 root partition (browsable with 7-Zip) |
| `../extracted/autoapp` | Main binary (28MB ARM ELF) |
| `../extracted/controller_service` | Companion service binary (457KB) |
| `../extracted/libaasdk.so` | Android Auto SDK shared library (884KB) |
| `../extracted/libaasdk_proto.so` | AA protobuf definitions library (1.3MB) |
| `../oap_manual_1.pdf` | OpenAuto Pro user manual (43 pages) |
| `../upstream/openauto/` | f1xpl/openauto (original, frozen 2018) |
| `../upstream/aasdk/` | f1xpl/aasdk (original, frozen 2018) |
| `../upstream/sonofgib-openauto/` | SonOfGib's fixed openauto fork |
| `../upstream/sonofgib-aasdk/` | SonOfGib's fixed aasdk fork |
| `../upstream/openauto-pro-api/` | BlueWave's published plugin API (proto + Python examples) |

### Reference Projects (not cloned, use GitHub)
- `github.com/opencardev/openauto` — actively maintained openauto fork (builds on Trixie, has WiFi projection, tests)
- `github.com/openDsh/dash` — Qt-based infotainment UI built on openauto (OBD, camera, BT, theming)

## Reverse Engineering (Completed — Reference Only)

This work informed the design but is no longer the active focus. Key findings preserved for reference:

### Original Binary Architecture
- **Binary:** 28MB stripped ARM armhf ELF, namespace `f1x::openauto::autoapp::`
- **Build:** Qt 5.11, Boost 1.67, protobuf 17, OpenSSL 1.1, Raspbian
- **Build path:** `/home/pi/workdir/openauto/`
- **54 shared library dependencies** (see `docs/reverse-engineering-notes.md`)
- **Sub-namespaces:** androidauto, autobox, bluetooth, mirroring, obd, audio, ui, api, system

### Android Auto Bug (Root Cause)
- **Problem:** AA 12.7+ sends WiFi credentials with message ID `0x8001`. BlueWave's enum has `CREDENTIALS_REQUEST = 0x0002`. Mismatch causes message to be dropped.
- **Ghidra finding:** `WirelessServiceChannel::messageHandler()` in libaasdk.so has NO switch statement at all — every message falls through to "not handled" logging. The actual credential handling may be in the autoapp binary, not the library.
- **Fix in rebuild:** SonOfGib's aasdk uses correct `0x8001` value. Using it as our submodule means the bug is fixed from day one.

### Key Binary Offsets (for reference)
| Binary | Offset | Content |
|--------|--------|---------|
| autoapp | 0x5c1378 | Serialized FileDescriptorProto (Api.proto, 6700 bytes) |
| libaasdk_proto.so | 0x132c74 | `WirelessMessage::WIRELESS_CREDENTIALS_REQUEST` enum (value: 2, should be 0x8001) |

## Technical Notes

- **WSL2 loop device mounting is broken on this machine** — use 7-Zip to browse ext4 images
- **Binary is stripped but leaky** — C++ template instantiations, Qt meta-object strings, and Boost.Log channels reveal class hierarchies
- **OAP config files:** `openauto_system.ini` (all settings including day/night colors, sensor config, hotspot) and `openauto_applications.ini` (external app launcher, up to 8 entries)
- **Plugin API protocol:** TCP/IP, message format: 32-bit size (LE) + 32-bit message ID (LE) + 32-bit flags (LE) + protobuf payload
- **BlueWave's additions over upstream:** QML UI, BT telephony (HFP/PBAP/A2DP), OBD-II, screen mirroring, music player, FM radio (RTL-SDR), plugin API, Autobox wireless, equalizer, system services (GPIO, I2C sensors, day/night)
- **OAP manual documents:** BMW iDrive/IBus/MMI 2G controller support, keyboard mapping table, TSL2561 light sensor I2C config, DS18B20 1-Wire temp sensor, V4L2 rear camera with GPIO trigger
