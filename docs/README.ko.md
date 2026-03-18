# DiveChecker

프리다이빙 균압 훈련을 위한 실시간 압력 모니터링 시스템

[English](../README.md) | **한국어**

## 주요 기능

| 기능 | 설명 |
|------|------|
| 실시간 압력 모니터링 | 100Hz 내부 샘플링, 4-50Hz 설정 가능 출력 |
| 듀얼코어 펌웨어 | Core0: USB/명령, Core1: 센서 샘플링 |
| 크로스플랫폼 앱 | Android, iOS, Linux, Windows, macOS, Web |
| USB MIDI SysEx | 범용 디바이스 통신 프로토콜 |
| ECDSA 인증 | P-256 기반 정품 하드웨어 검증 |
| 피크 분석 | 균압 기술 점수화 및 피드백 |
| 다국어 지원 | 영어, 한국어, 일본어, 중국어 |

## 기술 스택

| 계층 | 기술 |
|------|------|
| App | Flutter/Dart 3.10+, Provider, fl_chart |
| Firmware | C11, Pico SDK 2.2.0, TinyUSB, mbedtls |
| Hardware | RP2350 (Pico2), BMP280 (I2C), WS2812 LED |
| Database | SQLite (네이티브) / IndexedDB (웹) |
| CI/CD | GitHub Actions (6개 플랫폼 빌드) |
| CAD | FreeCAD (인클로저 설계) |

## 빠른 시작

### 사전 요구사항
- Flutter SDK 3.10.4+
- Android Studio / Xcode (모바일)
- DiveChecker V1 하드웨어 + USB-C 케이블

### 설치

```bash
git clone https://github.com/kernalix7/DiveChecker.git
cd DiveChecker/_0_DiveChecker-APP
flutter pub get
flutter gen-l10n
flutter run
```

## 프로젝트 구조

```
00_Divechecker/
├── 0_CAD/                 # FreeCAD 하드웨어 설계
├── _0_DiveChecker-APP/    # Flutter 크로스플랫폼 앱
├── 0_Pico2-Firmware/      # RP2350 C 펌웨어
└── .github/workflows/     # CI/CD 파이프라인
```

## 테스트

```bash
cd _0_DiveChecker-APP
flutter test
flutter analyze --no-fatal-infos
```

## 기여

개발 환경 설정 및 작업 흐름은 [CONTRIBUTING.ko.md](CONTRIBUTING.ko.md)를 참조하세요.

## 보안

보안 이슈는 [SECURITY.ko.md](SECURITY.ko.md)의 절차를 따라 주세요.

## 라이선스

- Software: Apache License 2.0
- Hardware: CERN-OHL-S v2
