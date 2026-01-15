# DiveChecker MCU 펌웨어

프리다이빙 이퀄라이징 압력 측정을 위한 MCU 펌웨어입니다.

> **현재 지원 MCU**: ESP32-C3  
> **계획된 지원**: RP2350

## 아키텍처 (v4.0.0)

**설계 철학: 단순한 MCU + 똑똑한 앱**

| 구성요소 | 역할 |
|----------|------|
| **MCU** | 센서 읽기 + 원본 데이터 전송 (단순, 안정적) |
| **앱** | 모든 처리: 필터링, 분석, 표시 (유연, 업데이트 가능) |

### 주요 특징

- **160Hz 원본 출력** - 진짜 센서 데이터, MCU 처리 없음
- **IIR OFF** - 하드웨어 필터 없음, 피크 신호 보존
- **~6ms 지연** - 실시간 응답을 위한 최소 지연
- **원본 데이터 보존** - 다른 알고리즘으로 재분석 가능

### 성능 스펙

| 항목 | 값 |
|------|-----|
| 출력 속도 | 160 Hz |
| 지연 시간 | ~6 ms |
| 피크 타이밍 정확도 | ±3 ms |
| 원본 노이즈 | ~1.3 Pa RMS |
| 데이터 전송률 | ~1.6 KB/s |
| 분해능 | 0.001 hPa |

## 하드웨어 (ESP32-C3)

- **ESP32-C3** 개발보드
- **BMP280** I2C 압력 센서 모듈

### 배선 (ESP32-C3)

```
ESP32-C3        BMP280
--------        ------
3.3V     ────── VCC
GND      ────── GND
GPIO8    ────── SDA
GPIO9    ────── SCL
```

## 시리얼 프로토콜

### 명령어 (앱 → MCU)

| 명령 | 설명 |
|------|------|
| `P` | 핑 - 연결 확인, `PONG` 응답 |
| `R` | 현재 압력으로 기준점 초기화 |
| `C` | 설정 조회, `CFG:160` 응답 |

### 출력 (MCU → 앱)

| 접두사 | 형식 | 설명 |
|--------|------|------|
| `D:` | `D:1234` | 압력 변화량 (값 × 0.001 hPa) |
| `CFG:` | `CFG:160` | 설정 응답 (샘플링 속도) |
| `PONG` | `PONG` | 핑 응답 |
| `INFO:` | `INFO:msg` | 정보 메시지 |
| `ERR:` | `ERR:msg` | 에러 메시지 |

### 데이터 흐름

```
[BMP280] → 160Hz → [ESP32-C3] → USB Serial → [앱]
   │                    │                       │
   └── 원본 압력        └── D:값               └── 필터/표시
```

## PlatformIO 설정 (VS Code)

### 1. PlatformIO 확장 설치

1. VS Code 열기
2. 확장 탭 (Ctrl+Shift+X)
3. "PlatformIO IDE" 검색 → 설치
4. VS Code 재시작

### 2. 프로젝트 열기

```bash
# VS Code에서 폴더 열기
code 0_MCU_Firmware
```

또는 **File > Open Folder** → `0_MCU_Firmware` 선택

### 3. 빌드 및 업로드

PlatformIO 툴바 (하단 상태바):

| 버튼 | 기능 |
|------|------|
| ✓ | 빌드 (컴파일) |
| → | 업로드 |
| 🔌 | 시리얼 모니터 |
| 🧹 | 클린 |

**또는 단축키:**
- `Ctrl+Alt+B` - 빌드
- `Ctrl+Alt+U` - 업로드
- `Ctrl+Alt+S` - 시리얼 모니터

### 4. 시리얼 모니터

업로드 후 시리얼 모니터 열기 (🔌 버튼 또는 `Ctrl+Alt+S`):

```
================================
  DiveChecker Firmware v4.0.0
  160Hz Raw Output Mode
================================

INFO:I2C GPIO8/9 @1MHz
INFO:I2C scan... 0x76 (BMP280)
INFO:Sensor init... OK
INFO:Test 1013.25 hPa 25.3 C

INFO:Output 160Hz raw data
INFO:IIR OFF (true raw signal)
INFO:Ready
================================
```

## 프로젝트 구조

```
0_MCU_Firmware/
├── platformio.ini      # PlatformIO 설정
├── src/
│   └── main.cpp        # 메인 펌웨어 코드
├── include/            # 헤더 파일 (필요시)
├── lib/                # 커스텀 라이브러리 (필요시)
└── README.md
```

## 문제 해결

### 업로드 실패 (ESP32-C3)

**ESP32-C3 부트로더 모드 진입:**
1. **BOOT** 버튼 누른 상태 유지
2. **RST** 버튼 눌렀다 떼기
3. **BOOT** 버튼 떼기
4. 업로드 재시도

### I2C 감지 안됨

```
Scanning I2C bus...
  ⚠ No I2C devices found!
```

**확인사항:**
- VCC → 3.3V (5V 아님!)
- GND → GND
- SDA → GPIO8
- SCL → GPIO9
- 점퍼선 접촉 상태

### 다른 핀 사용하기

`src/main.cpp`에서:

```cpp
// 기본값
#define I2C_SDA  8
#define I2C_SCL  9

// 대체 핀
#define I2C_SDA  4
#define I2C_SCL  5
```

## 앱 연결

1. ESP32-C3를 USB로 연결
2. 앱에서 **설정 > USB 시리얼**
3. 장치 선택
4. 앱이 `P` (핑) 전송, MCU가 `PONG` 응답
5. 160Hz 데이터 스트리밍 시작!

## 라이선스

Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)

이 펌웨어는 이중 라이선스로 제공됩니다:

| 구성요소 | 라이선스 |
|----------|----------|
| 소프트웨어 (펌웨어 코드) | [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) |
| 하드웨어 (회로 설계) | [CERN-OHL-S v2](https://ohwr.org/cern_ohl_s_v2.txt) |

자세한 내용은 프로젝트 루트의 [LICENSE](../LICENSE) 파일을 참조하세요.
