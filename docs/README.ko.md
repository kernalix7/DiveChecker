<div align="center">

<img src="../website/assets/images/logo-divechecker-blue.svg" alt="DiveChecker" width="280">

### 이퀄라이징을 눈으로 봅니다.

<p>프리다이빙 이퀄라이징 훈련용 실시간 압력 시각화 — 100Hz BMP280 센서,<br>
USB MIDI 제로 레이턴시, 6개 플랫폼 Flutter 앱, ECDSA 인증 RP2350 펌웨어.<br>
두 가지 제품: <strong>DiveChecker</strong> (센서) + <strong>DiveChecker Vent</strong> (지상 마우스필 트레이너).</p>

<pre><code># 앱 받기
Android: https://play.google.com/store/apps/details?id=kr.createch.divechecker
iOS:     https://apps.apple.com/kr/app/divechecker/id6758508799
데스크탑: https://github.com/kernalix7/DiveChecker/releases/latest

# 디바이스 구매
https://smartstore.naver.com/createch/products/13224634919</code></pre>

<a href="../website/assets/images/hero-product.jpg">
  <img src="../website/assets/images/hero-product.jpg" alt="DiveChecker DC-EQ01 — 프리다이빙 이퀄라이징 센서" width="720">
</a>

<sub>DiveChecker DC-EQ01 — 코쪽 압력을 100Hz로 측정하고 프렌젤·발살바·마우스필 곡선을 실시간으로 시각화합니다.</sub>

[![Status](https://img.shields.io/badge/status-shipping-2EA44F?style=for-the-badge)](#-status)
[![Latest](https://img.shields.io/github/v/release/kernalix7/DiveChecker?include_prereleases&style=for-the-badge&label=latest&color=2962FF)](https://github.com/kernalix7/DiveChecker/releases)

[![license](https://img.shields.io/github/license/kernalix7/DiveChecker?style=flat-square&color=blue)](../LICENSE)
[![flutter](https://img.shields.io/badge/flutter-3.10%2B-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![dart](https://img.shields.io/badge/dart-3.10%2B-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![firmware](https://img.shields.io/badge/firmware-RP2350-FF6B00?style=flat-square&logo=raspberrypi&logoColor=white)](../0_Pico2-Firmware/)
[![hardware](https://img.shields.io/badge/hardware-CERN--OHL--S%20v2-1E4E5F?style=flat-square)](../LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/kernalix7/DiveChecker/build.yml?branch=main&style=flat-square&label=CI)](https://github.com/kernalix7/DiveChecker/actions/workflows/build.yml)
[![pages](https://img.shields.io/github/actions/workflow/status/kernalix7/DiveChecker/pages.yml?branch=main&style=flat-square&label=site)](https://divechecker.createch.kr)
[![stars](https://img.shields.io/github/stars/kernalix7/DiveChecker?style=flat-square&color=FFD93D&logo=github&logoColor=white)](https://github.com/kernalix7/DiveChecker/stargazers)
[![downloads](https://img.shields.io/github/downloads/kernalix7/DiveChecker/total?style=flat-square&color=2EA44F)](https://github.com/kernalix7/DiveChecker/releases)

###### 동작 플랫폼

[![Android](https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=android&logoColor=white)](https://play.google.com/store/apps/details?id=kr.createch.divechecker)
[![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=apple&logoColor=white)](https://apps.apple.com/kr/app/divechecker/id6758508799)
[![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://apps.apple.com/kr/app/divechecker/id6758508799)
[![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat-square&logo=windows&logoColor=white)](https://github.com/kernalix7/DiveChecker/releases)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](https://github.com/kernalix7/DiveChecker/releases)
[![Web](https://img.shields.io/badge/Web-4285F4?style=flat-square&logo=googlechrome&logoColor=white)](https://divechecker.createch.kr)

<sub>[English](../README.md) &nbsp;·&nbsp; **한국어** &nbsp;·&nbsp; [사이트](https://divechecker.createch.kr) &nbsp;·&nbsp; [Vent (마우스필)](https://divechecker.createch.kr/vent.html) &nbsp;·&nbsp; [기능](#-기능) &nbsp;·&nbsp; [빠른 시작](#-빠른-시작) &nbsp;·&nbsp; [아키텍처](#-아키텍처)</sub>

</div>

---

> ### Status
> DiveChecker DC-EQ01 (센서)는 **출시 완료** (앱 v8.6.0, 펌웨어 v6.0.0, KC 인증). DiveChecker Vent (마우스필 지상 트레이너)는 **곧 출시** — [마케팅 사이트](https://divechecker.createch.kr/vent.html)에서 출시 알림 신청. 이슈는 <https://github.com/kernalix7/DiveChecker/issues>에 제보.

---

## 🎯 개요

DiveChecker는 프리다이버들이 **이퀄라이징(귀 압력 평형)** 훈련을 효과적으로 수행할 수 있도록 도와주는 전문 모니터링 시스템입니다.

마우스피스에 연결된 압력 센서를 통해 입으로 불거나 빨 때의 미세한 압력 변화(300-1250 hPa 센서 범위)를 **100Hz 내부 샘플링 + 설정 가능한 출력 속도(4-50Hz)**로 정밀하게 측정하고, 실시간 그래프로 시각화합니다.

### 아키텍처 (v8.0.0)

**스마트 MCU + 지능형 앱**

```
[BMP280] → 100Hz → [MCU] → USB MIDI → [Flutter 앱]
    │                   │                      │
        └── 원본 센서       └── IIR + 평균화       └── 모든 로직:
            데이터             펌웨어 필터링            - 표시
                               출력: 4-50Hz            - 분석
                                                       - 저장
```

| 구성요소 | 역할 |
|----------|------|
| **MCU** | 센서 읽기 + IIR/평균화 필터 + 설정 가능한 출력 속도 |
| **앱** | 표시, 분석, 저장 (유연, OTA 업데이트 가능) |

### 지원 하드웨어

| MCU | 센서 | 상태 |
|-----|------|------|
| **Pico RP2350** | BMP280 | ✅ 완전 지원 |

### 왜 DiveChecker인가?

| 문제점 | DiveChecker 솔루션 |
|--------|-------------------|
| 이퀄라이징이 제대로 되는지 확인 불가 | 실시간 압력 그래프로 즉각적 피드백 |
| 훈련 효과 측정 어려움 | 세션 기록 + 피크 분석으로 객관적 평가 |
| 일관성 있는 기술 연습 어려움 | 리듬 점수, 피로도 지수 등 고급 분석 |

---

## ✨ 기능

### 📊 실시간 압력 모니터링

<table>
<tr>
<td width="50%">

**센서 스펙**
- **샘플링**: 100Hz 내부 → 4-50Hz 출력 (설정 가능)
- **펌웨어 필터링**: IIR x2 + 평균화
- **지연 시간**: ~10ms (센서 → 앱)
- **센서 범위**: 300-1250 hPa (BMP280 확장)
- **분해능**: 0.001 hPa (센서 0.0016 hPa)

</td>
<td width="50%">

**시각화**
- 실시간 라인 차트 (fl_chart)
- 핀치 줌 / 드래그 팬 제스처
- 30초 슬라이딩 윈도우
- 동적 Y축 자동 스케일링
- 부드러운 베지어 곡선 차트
- 최대/평균 압력 실시간 표시

</td>
</tr>
</table>


### 🔬 고급 피크 분석

측정 완료 후 상세한 이퀄라이징 품질 분석:

| 지표 | 설명 |
|------|------|
| **리듬 점수** | 피크 간격의 일관성 (CV 기반) |
| **압력 점수** | 피크 강도의 균일성 |
| **테크닉 점수** | 상승/하강 시간, 피크 폭 분석 |
| **피로도 지수** | 세션 중 압력 감소 추세 |
| **종합 등급** | S~F 등급으로 전체 평가 |

**피크 분류**: Weak / Moderate / Strong 강도별 분류

### 💾 데이터 관리

- **SQLite / IndexedDB**: 플랫폼별 자동 선택 (Native/Web)
- **세션 기록**: 날짜, 시간, 최대/평균 압력, 샘플 레이트, 메모
- **그래프 노트**: 특정 시점에 메모 추가 (번호 마커)
- **백업/복원**: JSON 기반 데이터 내보내기/가져오기
- **커서 인디케이터**: 터치 위치에 시간/압력 표시

### 🌐 다국어 지원

- 🇺🇸 English
- 🇰🇷 한국어
- 🇯🇵 日本語
- 🇨🇳 简体中文
- 🇹🇼 繁體中文

### ⚙️ 캘리브레이션 및 설정

- **대기압 캘리브레이션**: 3초간 샘플 수집 후 기준점 설정
- **출력 속도 조절**: F 명령으로 4-50Hz 설정
- **오버샘플링 조절**: 1x ~ 16x (MCU 명령)

---

## 🔐 보안 및 안정성

### 장치 인증 (ECDSA P-256)

| 기능 | 설명 |
|------|------|
| **챌린지-응답** | 32바이트 랜덤 논스 + ECDSA 서명 검증 |
| **개인키 저장** | OTP (One-Time Programmable) 메모리 — 추출 불가 |
| **상수 시간 비교** | 타이밍 공격 방지 |
| **메모리 제로화** | 암호화 작업 후 `mbedtls_platform_zeroize()` |

### PIN 보호

| 기능 | 설명 |
|------|------|
| **Rate Limiting** | 지수 백오프 (1초 → 2초 → ... → 최대 60초) |
| **영구 잠금** | PIN 실패 횟수 재부팅 후에도 유지 (Flash 저장) |
| **상수 시간 PIN 검증** | 타이밍 사이드채널 없음 |

### 데이터 무결성

| 기능 | 설명 |
|------|------|
| **Flash CRC32** | 로드 시 설정 무결성 검사 |
| **레거시 마이그레이션** | 이전 설정(CRC 없음) 저장 시 자동 업그레이드 |
| **마모 평준화** | 4KB 섹터 내 16슬롯 로테이션 |
| **3초 쓰기 디바운스** | 빠른 슬라이더 조작 시 Flash 마모 방지 |

### 자가복구 메커니즘

| 메커니즘 | 트리거 | 복구 동작 |
|----------|--------|-----------|
| **워치독** | 부팅 8초 / 운영 2초 | 자동 재부팅 |
| **센서 자동 재시도** | I2C 실패 | 5초마다 재시도 (Core 1) |
| **앱 자동 재연결** | USB 끊김 | 지수 백오프 (2/4/6초, 3회) |
| **SysEx 파서 타임아웃** | 불완전 메시지 | 500ms → IDLE 리셋 |
| **PIO 폴백** | PIO0 사용 불가 | 자동으로 PIO1 사용 |
| **과범위 복구** | 센서 포화 | 리셋 후 30샘플 폐기 |

### 안정성 기능

| 기능 | 설명 |
|------|------|
| **듀얼코어 분리** | Core 0: USB/MIDI, Core 1: 센서 (100Hz) |
| **I2C 뮤텍스 보호** | 크로스코어 접근 직렬화 |
| **FIFO 통신** | 락프리 코어간 메시지 전달 |
| **포화 카운터** | 진단 카운터 오버플로우 방지 |
| **원자적 설정 업데이트** | volatile + 메모리 배리어로 출력 속도 변경 |

---

## 📱 화면 구성

| 화면 | 설명 |
|------|------|
| 🏠 **홈** | 장치 연결, 실시간 압력 표시, 캘리브레이션 |
|| 📺 **모니터** | 동적 Y축 실시간 스트리밍 차트 |
|| 📈 **측정** | 실시간 그래프, 시작/정지/일시정지, 세션 저장 |
| 📋 **기록** | 세션 목록 → 상세 그래프 → 피크 분석 |
| ⚙️ **설정** | 언어, 백업/복원, 장치 설정, 펌웨어 업데이트 |

---

## 🚀 빠른 시작

### 사전 요구사항

| 구성요소 | 버전 | 비고 |
|----------|------|------|
| Flutter SDK | 3.10.4+ | `flutter --version` |
| Pico SDK | 최신 | RP2350 펌웨어용 |
| USB 케이블 | - | 데이터 전송 지원 케이블 |

### 1. 앱 설치 및 실행

```bash
git clone https://github.com/kernalix7/divechecker.git
cd divechecker/_0_DiveChecker-APP

flutter pub get
flutter gen-l10n
flutter run -d linux    # 또는 android, windows, macos
```

### 2. 펌웨어 업로드

```bash
# Pico SDK로 빌드
cd 0_Pico2-Firmware/Divechecker
mkdir build && cd build
cmake .. && make
# BOOTSEL 모드에서 .uf2 파일을 Pico에 복사
```

### 3. 연결 및 측정

1. MCU를 USB로 PC/Android에 연결
2. 앱 홈 → **장치 연결**
3. 장치 선택 → 연결 완료
4. **캘리브레이션** (센서 안정화)
5. 측정 탭 → **시작**

---


## 🏗️ 아키텍처

```
00_Divechecker/
│
├── 📱 _0_DiveChecker-APP/          # Flutter 크로스플랫폼 앱
│   ├── lib/
│   │   ├── main.dart               # 앱 진입점
│   │   ├── constants/              # 테마, 색상, 앱 설정
│   │   ├── core/                   # DB 인터페이스
│   │   ├── l10n/                   # 다국어 (EN/KO/JA/ZH/ZH_TW)
│   │   ├── models/                 # PressureData, GraphNote
│   │   ├── providers/              # 상태관리 (Provider)
│   │   ├── screens/                # 화면 (장치 설정, 펌웨어 업데이트 포함)
│   │   ├── services/               # DB, 백업, 업데이트 서비스
│   │   ├── utils/                  # 피크 분석 알고리즘
│   │   └── widgets/                # UI 컴포넌트
│   └── pubspec.yaml
│
├── 🔧 0_Pico2-Firmware/            # Pico RP2350 프로젝트
│   └── Divechecker/
│       ├── Divechecker.c           # 메인 펌웨어 (듀얼코어, ~1800줄)
│       ├── midi_sysex.c/h          # USB MIDI SysEx 프로토콜
│       ├── usb_descriptors.c       # TinyUSB 디바이스 디스크립터
│       ├── ws2812.pio              # WS2812 LED PIO 프로그램
│       └── CMakeLists.txt          # 빌드 설정 (Pico SDK 2.2.0)
│
├── 📐 0_CAD/                       # 하드웨어 설계 (FreeCAD)
│
└── 📜 LICENSE                      # Apache 2.0 + CERN-OHL-S v2
```

### 통신 프로토콜 (USB MIDI SysEx)

SysEx 형식: `F0 7D 01 [cmd] [data...] F7`
- 제조사 ID: `0x7D` (교육/개발용)
- 기기 ID: `0x01` (DiveChecker)

**기기 → 앱**

| 명령 | Hex | 설명 |
|------|-----|------|
| Pressure | 0x01 | 차압 (7비트 인코딩 int32, hPa×1000) |
| Device Info | 0x02 | 시리얼, 이름, FW 버전, 센서 상태 |
| Config | 0x03 | 출력 속도 응답 |
| Auth Response | 0x04 | ECDSA 서명 (니블 인코딩) |
| Over-range Alert | 0x06 | 센서 측정 범위 초과 |
| Temperature | 0x07 | BMP280 온도 (int16×100) |
| Diagnostics | 0x08 | 가동시간, 에러 카운트, I2C 복구 |
| Full Config | 0x09 | 모든 설정 파라미터 |
| ACK | 0x0A | 명령 확인 (cmd + 상태) |
| Ping | 0x10 | 킵얼라이브 요청 |
| Pong | 0x11 | 킵얼라이브 응답 |

**앱 → 기기**

| 명령 | Hex | 설명 |
|------|-----|------|
| Ping | 0x10 | 연결 유지 |
| Request Info | 0x20 | 기기 정보 요청 |
| Set Name | 0x21 | 기기 이름 설정 (PIN 필요) |
| Set Output Rate | 0x22 | 출력 속도 설정 (4-50 Hz) |
| Reset Baseline | 0x23 | 압력 기준점 리셋 |
| Get Config | 0x24 | 전체 설정 덤프 요청 |
| Set LED | 0x25 | LED 밝기 설정 (0-100) |
| Reset Sensor | 0x26 | 수동 센서 재초기화 |
| Factory Reset | 0x27 | 공장 초기화 (PIN 필요) |
| Set Noise Floor | 0x28 | 노이즈 임계값 설정 (0-50) |
| Get Temperature | 0x29 | 온도 요청 |
| Enter Bootloader | 0x2A | BOOTSEL 모드 진입 (PIN 필요) |
| Get Diagnostics | 0x2B | 런타임 진단 요청 |
| Set Oversampling | 0x2C | 압력 오버샘플링 설정 (0-5) |
| Set IIR Filter | 0x2D | IIR 필터 계수 설정 (0-4) |
| Soft Reboot | 0x2E | 소프트 재부팅 (PIN 필요) |
| Auth Challenge | 0x30 | ECDSA 인증 (32바이트 논스) |
| Set PIN | 0x31 | PIN 변경 (기존 PIN + 새 PIN) |

---

## 🔧 하드웨어

### 지원 MCU

| MCU | 센서 | 상태 | 비고 |
|-----|------|------|------|
| **Pico RP2350** | BMP280 | ✅ 지원 | 듀얼코어, USB MIDI, ECDSA 인증 |

### 회로 구성

**Pico RP2350 + BMP280:**
```
Pico RP2350         BMP280 (I2C)
────────────        ────────────
3.3V         ────── VCC
GND          ────── GND
GP8 (SDA)    ────── SDA
GP9 (SCL)    ────── SCL
GP16         ────── WS2812 LED
```

### 센서 요구사항

- **압력 센서**: BMP280
- **감도**: ±0.01 hPa 이상 권장
- **마우스피스 연결**: 튜브로 센서와 연결

> 📌 상세 설정은 [0_Pico2-Firmware/Divechecker/README.md](../0_Pico2-Firmware/Divechecker/README.md) 참조

---

## 🔮 로드맵

### ✅ v1.0.0 완료
- [x] 🎯 **실시간 압력 모니터링** - 100Hz 내부 + 설정 가능 출력
- [x] 📊 **피크 분석** - 리듬, 압력, 테크닉 점수
- [x] 💾 **세션 관리** - 기록, 조회, 메모
- [x] 🌐 **다국어** - 영어, 한국어, 일본어, 중국어 (간체/번체)
- [x] 🔧 **장치 설정** - 출력 속도, 오버샘플링 제어
- [x] 🔄 **펌웨어 업데이트** - OTA 업데이트 지원
- [x] 🔐 **인증** - ECDSA 기기 인증

### 🔜 다음 목표
- [ ] ⏸️ **모니터 일시정지 & 범위 저장** - 모니터링 일시정지 및 특정 범위 저장
- [ ] 🫁 **폐활량 측정** - 최대 흡기/호기 용량 체크
- [ ] 🧘 **CO₂ 테이블 트레이너** - 이산화탄소 내성 훈련
- [ ] 💨 **O₂ 테이블 트레이너** - 저산소 적응 훈련
- [ ] 📤 **CSV 내보내기** - 외부 분석 도구 연동
- [ ] 🌐 **클라우드 동기화** - Firebase 기반 백업
- [ ] 🎯 **훈련 프로그램** - 가이드 세션 (8주 코스 등)

---

## 🤝 기여하기

기여를 환영합니다!

```bash
# Fork 후
git clone https://github.com/YOUR_USERNAME/divechecker.git
cd divechecker/_0_DiveChecker-APP
flutter pub get
flutter run
```

자세한 내용은 [CONTRIBUTING.md](../CONTRIBUTING.md)를 참조하세요.

---

## 📄 라이선스

이 프로젝트는 이중 라이선스로 제공됩니다:

| 구성요소 | 라이선스 | 범위 |
|----------|----------|------|
| **소프트웨어** | [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) | 앱, 펌웨어 코드 |
| **하드웨어** | [CERN-OHL-S v2](https://ohwr.org/cern_ohl_s_v2.txt) | 회로, CAD 설계 |

자세한 내용은 [LICENSE](../LICENSE) 파일을 참조하세요.

---

## ⭐ Star History

<a href="https://star-history.com/#kernalix7/DiveChecker&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=kernalix7/DiveChecker&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=kernalix7/DiveChecker&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=kernalix7/DiveChecker&type=Date" />
  </picture>
</a>

## 📊 기여자 & 활동

[![Contributors](https://contrib.rocks/image?repo=kernalix7/DiveChecker)](https://github.com/kernalix7/DiveChecker/graphs/contributors)

[![commit activity](https://img.shields.io/github/commit-activity/m/kernalix7/DiveChecker?style=flat-square&color=2EA44F)](https://github.com/kernalix7/DiveChecker/pulse)
[![last commit](https://img.shields.io/github/last-commit/kernalix7/DiveChecker?style=flat-square&color=2962FF)](https://github.com/kernalix7/DiveChecker/commits/main)
[![issues](https://img.shields.io/github/issues/kernalix7/DiveChecker?style=flat-square&color=orange)](https://github.com/kernalix7/DiveChecker/issues)
[![PRs](https://img.shields.io/github/issues-pr/kernalix7/DiveChecker?style=flat-square&color=blueviolet)](https://github.com/kernalix7/DiveChecker/pulls)
[![repo size](https://img.shields.io/github/repo-size/kernalix7/DiveChecker?style=flat-square)](https://github.com/kernalix7/DiveChecker)

## 💖 후원

DiveChecker는 [@kernalix7](https://github.com/kernalix7) 1인이 하드웨어 + 앱 + 펌웨어 + 사이트까지 통째로 만들고 유지하는 프로젝트입니다. 훈련(또는 다이브샵, 학생, PB)에 도움이 되셨다면, 작은 후원이 다음 펌웨어 빌드 / 번역 / CAD 개정의 동력이 됩니다.

[![Ko-fi](https://img.shields.io/badge/Ko--fi-F16061?logo=ko-fi&logoColor=white&style=for-the-badge)](https://ko-fi.com/kernalix7)
[![Fairy](https://img.shields.io/badge/🧚_Fairy-EE6E73?style=for-the-badge&logoColor=white)](https://fairy.hada.io/@kernalix7)
[![Sponsor](https://img.shields.io/badge/GitHub_Sponsor-EA4AAA?logo=githubsponsors&logoColor=white&style=for-the-badge)](https://github.com/sponsors/kernalix7)

Ko-fi는 해외 카드 / PayPal 결제, fairy.hada.io는 한국 후원 플랫폼, GitHub Sponsor 버튼(저장소 상단)은 두 곳을 함께 연결합니다. 버그 제보, PR, 저장소 별표도 모두 동등하게 감사하며 무료입니다.

설정은 [`.github/FUNDING.yml`](../.github/FUNDING.yml) 참조.

---

<div align="center">

**Made with ❤️ for the Freediving Community**

[⬆ 맨 위로](#-divechecker)

</div>
