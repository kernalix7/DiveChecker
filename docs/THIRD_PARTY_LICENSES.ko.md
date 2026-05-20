# 서드파티 라이선스

[English](../THIRD_PARTY_LICENSES.md) | **한국어**

DiveChecker 소프트웨어는 [Apache License 2.0](../LICENSE), 하드웨어 설계는 [CERN-OHL-S v2](https://ohwr.org/cern_ohl_s_v2.txt)로 라이선스됩니다. 이 문서는 소스 트리 내 재배포되거나 런타임/빌드 의존성으로 끌어다 쓰는 서드파티 구성요소를 업스트림 라이선스와 함께 나열합니다.

## 펌웨어 — Pico SDK + 사용 라이브러리

### Pico SDK 2.2.0

- Upstream: <https://github.com/raspberrypi/pico-sdk>
- License: BSD-3-Clause
- 역할: RP2350 (Pico 2) 보드 지원 패키지 — `pico_stdlib`, USB 스택, 멀티코어, 하드웨어 페리페럴.

### TinyUSB

- Upstream: <https://github.com/hathach/tinyusb>
- License: MIT
- 벤더링: Pico SDK 경유
- 역할: DiveChecker를 USB MIDI class device로 노출시키는 USB Device 스택. `0_Pico2-Firmware/Divechecker/usb_descriptors.c` 참조.

### Mbed TLS

- Upstream: <https://github.com/Mbed-TLS/mbedtls>
- License: Apache-2.0
- 벤더링: Pico SDK 경유 (`${PICO_SDK_PATH}/lib/mbedtls`)
- 역할: ECDSA P-256 challenge/response 디바이스 인증. 메모리 footprint를 위해 커스텀 `mbedtls_config.h`로 서브셋만 컴파일.

## 앱 — Flutter pub 패키지

`_0_DiveChecker-APP/pubspec.yaml`에서 관리. 각 업스트림 전체 라이선스는 `pub.dev` 및 `.pub-cache` lockfile에서 확인 가능.

| 패키지 | 라이선스 | 용도 |
|--------|---------|------|
| `flutter_midi_command` ^0.5.3 | MIT | Android / iOS / macOS / Windows / Linux에서 USB MIDI SysEx I/O |
| `permission_handler` ^11.3.1 | MIT | 모바일 런타임 권한 |
| `fl_chart` ^0.70.2 | MIT | 실시간 압력 시각화 |
| `sqflite` ^2.4.2 | MIT | 네이티브 SQLite |
| `sqflite_common_ffi` ^2.3.4+5 | MIT | 데스크탑(Linux/Windows/macOS) SQLite |
| `idb_shim` ^2.6.1+1 | BSD-3-Clause | Web IndexedDB shim |
| `path` ^1.9.1 | BSD-3-Clause | 경로 조작 |
| `path_provider` ^2.1.5 | BSD-3-Clause | 플랫폼별 경로 탐지 |
| `file_picker` ^8.1.7 | MIT | JSON 백업/복원 파일 선택 |
| `provider` ^6.1.4 | MIT | 상태 관리 |
| `pointycastle` (transitive) | MIT | 앱 측 ECDSA P-256 서명 검증 |
| `cupertino_icons` ^1.0.8 | MIT | iOS 스타일 아이콘 |

Flutter SDK 자체는 BSD-3-Clause (<https://github.com/flutter/flutter/blob/master/LICENSE>).

## Linux Flutter plugin override

`packages/flutter_midi_command_linux/`는 Linux 데스크탑 ALSA RawMIDI 지원을 위해 커스텀 fork. 원본 `flutter_midi_command_linux` (MIT)에서 fork. 동일 라이선스 유지.

## 마케팅 사이트 (`website/`)

- Inter 폰트 — SIL Open Font License 1.1 (<https://github.com/rsms/inter>)
- Noto Sans KR — SIL Open Font License 1.1 (<https://fonts.google.com/noto>)
- 그 외 자산 (로고, 히어로 렌더, OG 이미지) © 2025-2026 Createch — All rights reserved.

## 하드웨어 (`0_CAD/`)

DiveChecker 케이스 (V4–V11)는 **CERN-OHL-S v2**. FreeCAD 파일은 BME280 5V breakout 모듈 footprint를 참조하며, 독점 심볼은 재배포하지 않음.

## Attribution

패키지 매니저(`flutter pub get` / Pico SDK 설치)로 자동 발견되는 빌드 의존성은 여기에 개별 나열하지 않음. 전체 transitive 목록은 다음을 참조:

- `_0_DiveChecker-APP/pubspec.lock` (Flutter 의존성)
- `${PICO_SDK_PATH}/LICENSE.TXT` 및 `mbedtls/`, `tinyusb/` 서브트리 (펌웨어 의존성)

누락 / 잘못 표기된 의존성을 발견하시면 <https://github.com/kernalix7/DiveChecker/issues>에 이슈 등록 부탁드립니다.
