<div align="center">

# 🌊 DiveChecker

### 프리다이빙 이퀄라이징 압력 모니터

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.10.4+-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Linux%20%7C%20Windows%20%7C%20macOS%20%7C%20Web-lightgrey)]()

**프리다이빙 이퀄라이징 훈련을 위한 실시간 압력 모니터링 시스템**

[기능](#-기능) • [빠른 시작](#-빠른-시작) • [아키텍처](#-아키텍처) • [하드웨어](#-하드웨어) • [기여하기](#-기여하기)

</div>

---

## 🎯 개요

DiveChecker는 프리다이버들이 **이퀄라이징(귀 압력 평형)** 훈련을 효과적으로 수행할 수 있도록 도와주는 전문 모니터링 시스템입니다.

마우스피스에 연결된 압력 센서를 통해 입으로 불거나 빨 때의 미세한 압력 변화(-10~+25 hPa)를 **100Hz 내부 샘플링 + 설정 가능한 출력 속도(4-50Hz)**로 정밀하게 측정하고, 실시간 그래프로 시각화합니다.

### 아키텍처 (v4.5.0)

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
- **압력 범위**: -10 ~ +25 hPa (음압/양압)
- **분해능**: 0.001 hPa (센서 0.0016 hPa)

</td>
<td width="50%">

**시각화**
- 실시간 라인 차트 (fl_chart)
- 핀치 줌 / 드래그 팬 제스처
- 30초 슬라이딩 윈도우
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

### ⚙️ 캘리브레이션 및 설정

- **대기압 캘리브레이션**: 3초간 샘플 수집 후 기준점 설정
- **출력 속도 조절**: F 명령으로 4-50Hz 설정
- **오버샘플링 조절**: 1x ~ 16x (MCU 명령)

---

## 📱 화면 구성

| 화면 | 설명 |
|------|------|
| 🏠 **홈** | 장치 연결, 실시간 압력 표시, 캘리브레이션 |
| 📈 **측정** | 실시간 그래프, 시작/정지/일시정지, 세션 저장 |
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
│   │   ├── l10n/                   # 다국어 (EN/KO)
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
│       ├── Divechecker.c           # 메인 펌웨어
│       ├── CMakeLists.txt
│       ├── 100Hz 내부 샘플링 (BMP280)
│       ├── 듀얼코어 아키텍처
│       ├── IIR x2 + 평균화 필터
│       ├── USB MIDI SysEx 프로토콜
│       └── ECDSA 기기 인증
│
├── 📐 0_CAD/                       # 하드웨어 설계 (FreeCAD)
│
└── 📜 LICENSE                      # Apache 2.0 + CERN-OHL-S v2
```

### 통신 프로토콜 (USB MIDI SysEx)

```
MCU → App (USB MIDI SysEx)
──────────────────────────────────
SysEx Data   압력 데이터 (0.001 hPa 분해능)
CFG:os,hz    설정 응답 (오버샘플링, 출력 Hz)
PONG         핑 응답
AUTH:OK/FAIL 인증 결과
INFO:msg     정보 메시지
ERR:msg      에러 메시지

App → MCU
──────────────────────────────────
P          핑 (연결 확인)
A:nonce    ECDSA 인증
R          베이스라인 리셋
Oxx        오버샘플링 설정 (1/2/4/8/16)
Fxx        출력 속도 설정 (4-50 Hz)
C          설정 요청
B          BOOTSEL 재부팅 (펌웨어 업데이트용)
```

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
GP4 (SDA)    ────── SDA
GP5 (SCL)    ────── SCL
```

### 센서 요구사항

- **압력 센서**: BMP280
- **감도**: ±0.01 hPa 이상 권장
- **마우스피스 연결**: 튜브로 센서와 연결

> 📌 상세 설정은 [0_Pico2-Firmware/Divechecker/README.md](0_Pico2-Firmware/Divechecker/README.md) 참조

---

## 🔮 로드맵

### ✅ v1.0.0 완료
- [x] 🎯 **실시간 압력 모니터링** - 100Hz 내부 + 설정 가능 출력
- [x] 📊 **피크 분석** - 리듬, 압력, 테크닉 점수
- [x] 💾 **세션 관리** - 기록, 조회, 메모
- [x] 🌐 **다국어** - 영어, 한국어
- [x] 🔧 **장치 설정** - 출력 속도, 오버샘플링 제어
- [x] 🔄 **펌웨어 업데이트** - OTA 업데이트 지원
- [x] 🔐 **인증** - ECDSA 기기 인증

### 🔜 다음 목표
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

자세한 내용은 [CONTRIBUTING.md](_0_DiveChecker-APP/CONTRIBUTING.md)를 참조하세요.

---

## 📄 라이선스

이 프로젝트는 이중 라이선스로 제공됩니다:

| 구성요소 | 라이선스 | 범위 |
|----------|----------|------|
| **소프트웨어** | [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) | 앱, 펌웨어 코드 |
| **하드웨어** | [CERN-OHL-S v2](https://ohwr.org/cern_ohl_s_v2.txt) | 회로, CAD 설계 |

자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

<div align="center">

**Made with ❤️ for the Freediving Community**

[⬆ 맨 위로](#-divechecker)

</div>
