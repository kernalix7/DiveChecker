# Third-Party Licenses

DiveChecker software is licensed under [Apache License 2.0](LICENSE) and the hardware design under [CERN-OHL-S v2](https://ohwr.org/cern_ohl_s_v2.txt). This document lists the third-party components redistributed or pulled in as runtime/build dependencies, together with their upstream licenses.

## Firmware — Pico SDK + pulled libraries

### Pico SDK 2.2.0

- Upstream: <https://github.com/raspberrypi/pico-sdk>
- License: BSD-3-Clause
- Role: RP2350 (Pico 2) board support package — `pico_stdlib`, USB stack glue, multicore, hardware peripherals.

### TinyUSB

- Upstream: <https://github.com/hathach/tinyusb>
- License: MIT
- Vendored via Pico SDK
- Role: USB Device stack used to expose DiveChecker as a USB MIDI class device. See `0_Pico2-Firmware/Divechecker/usb_descriptors.c`.

### Mbed TLS

- Upstream: <https://github.com/Mbed-TLS/mbedtls>
- License: Apache-2.0
- Vendored via Pico SDK (`${PICO_SDK_PATH}/lib/mbedtls`)
- Role: ECDSA P-256 challenge/response device authentication. Subset compiled with custom `mbedtls_config.h` for footprint.

## App — Flutter pub packages

Managed via `_0_DiveChecker-APP/pubspec.yaml`. Each upstream's full license is in `pub.dev` and the `.pub-cache` lockfile.

| Package | License | Use |
|---------|---------|-----|
| `flutter_midi_command` ^0.5.3 | MIT | USB MIDI SysEx I/O on Android / iOS / macOS / Windows / Linux |
| `permission_handler` ^11.3.1 | MIT | Runtime permissions on mobile |
| `fl_chart` ^0.70.2 | MIT | Real-time pressure visualization |
| `sqflite` ^2.4.2 | MIT | Native SQLite |
| `sqflite_common_ffi` ^2.3.4+5 | MIT | SQLite on desktop (Linux/Windows/macOS) |
| `idb_shim` ^2.6.1+1 | BSD-3-Clause | IndexedDB shim on Web |
| `path` ^1.9.1 | BSD-3-Clause | Path manipulation |
| `path_provider` ^2.1.5 | BSD-3-Clause | Platform path discovery |
| `file_picker` ^8.1.7 | MIT | JSON backup/restore file picking |
| `provider` ^6.1.4 | MIT | State management |
| `pointycastle` (transitive) | MIT | ECDSA P-256 signature verification on the app side |
| `cupertino_icons` ^1.0.8 | MIT | iOS-style icons |

Flutter SDK itself is BSD-3-Clause (<https://github.com/flutter/flutter/blob/master/LICENSE>).

## Linux Flutter plugin override

`packages/flutter_midi_command_linux/` is a custom fork to support ALSA RawMIDI on Linux desktop. Forked from `flutter_midi_command_linux` (MIT). Modifications preserved under the same license.

## Marketing site (`website/`)

- Inter font — SIL Open Font License 1.1 (<https://github.com/rsms/inter>)
- Noto Sans KR — SIL Open Font License 1.1 (<https://fonts.google.com/noto>)
- All other assets (logo, hero renders, OG images) © 2025-2026 Createch — All rights reserved.

## Hardware (`0_CAD/`)

DiveChecker enclosure (V4–V11) is **CERN-OHL-S v2**. FreeCAD files reference the BME280 5V breakout module footprint; no proprietary symbols redistributed.

## Attribution

Build dependencies discovered automatically via the package manager (`flutter pub get` / Pico SDK install) are not listed individually here. For an exhaustive transitive list, see:

- `_0_DiveChecker-APP/pubspec.lock` (Flutter deps)
- `${PICO_SDK_PATH}/LICENSE.TXT` and the `mbedtls/`, `tinyusb/` subtrees (firmware deps)

If you find a dependency missing or mis-attributed, please open an issue at <https://github.com/kernalix7/DiveChecker/issues>.
