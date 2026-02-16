# OpenAuto Pro Community - Project Context

## What This Is

Community revival of OpenAuto Pro, a Raspberry Pi Android Auto head unit app. The original company (BlueWave Studio) shut down without releasing source code. We're reverse-engineering the v16.1 binary to rebuild it as open source.

## Key Architecture

- **Original binary:** 27MB stripped ARM (armhf) C++ executable, Qt 5.11 + Boost 1.67
- **Namespace:** `f1x::openauto::autoapp::` with sub-namespaces for androidauto, autobox, bluetooth, mirroring, obd, audio, ui, api, system
- **UI:** Qt Quick/QML — fully recovered (162 files in `original/qml/`)
- **API:** Protobuf-based plugin API — fully recovered (34 messages in `original/proto/Api.proto`)
- **Open-source foundation:** f1xpl/openauto + f1xpl/aasdk (both frozen since 2018, cloned in `../upstream/`)

## Project Layout

- `original/` — Extracted assets from v16.1 binary (QML, SVGs, scripts, proto)
- `tools/` — Extraction scripts (extract_qrc.py, extract_proto.py)
- `docs/` — Analysis documents and architecture notes

## Important Files

- `original/proto/Api.proto` — Complete BlueWave API definition (recovered from binary)
- `original/qml/MainScreen.qml` — Main application entry point
- `original/qml/applications/android_auto/` — Android Auto UI layer
- `../upstream/openauto/` — Original open-source openauto (reference)
- `../upstream/aasdk/` — Original open-source aasdk (reference)
- `../extracted/autoapp` — The actual binary (not in repo, too large)

## Primary Goal

Fix Android Auto compatibility with current Android versions. The issue is likely in the AA protocol handshake/version negotiation — see `AndroidAutoEntity::onHandshake` and `onVersionResponse` in the binary.

## Build Target

Raspberry Pi (ARM armhf), Raspbian/Raspberry Pi OS based. The v16.1 image was built Feb 2024.
