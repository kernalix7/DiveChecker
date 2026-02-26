# DiveChecker Pico RP2350 펌웨어

Raspberry Pi Pico 2 (RP2350)용 압력 모니터링 펌웨어입니다.

[🇺🇸 English](README.md)

## 기능

- BMP280 센서로 100Hz 내부 샘플링
- 확장 측정 범위: 300-1250 hPa
- 안정적인 성능을 위한 듀얼코어 아키텍처
- 부드러운 데이터를 위한 IIR + 평균화 필터
- 연결 상태와 분리된 센서 파이프라인 (샘플링 상시 동작)
- 안전한 BOOTSEL 진입 (멀티코어 락아웃 + 인터럽트 비활성화)
- 크로스플랫폼 호환성을 위한 USB MIDI SysEx 프로토콜
- ECDSA 기기 인증
- 설정 가능한 출력 속도 (4-50 Hz)

## 요구사항

- Raspberry Pi Pico 2 (RP2350)
- BMP280 압력 센서 (I2C)
- Pico SDK

## 빌드

```bash
# Pico SDK가 없으면 클론
git clone https://github.com/raspberrypi/pico-sdk.git
cd pico-sdk
git submodule update --init

# 펌웨어 빌드
cd 0_Pico2-Firmware/Divechecker
mkdir -p build && cd build
cmake -DPICO_SDK_PATH=/path/to/pico-sdk ..
make -j4
```

출력: `Divechecker.uf2`

## 플래시

1. BOOTSEL 버튼을 누른 채로 Pico를 USB에 연결
2. `RPI-RP2` 드라이브가 나타남
3. `Divechecker.uf2`를 드라이브에 복사
4. Pico가 자동으로 재부팅

## 회로

```
Pico RP2350         BMP280 (I2C)
────────────        ────────────
3.3V         ────── VCC
GND          ────── GND
GP8 (SDA)    ────── SDA
GP9 (SCL)    ────── SCL
GP16         ────── WS2812 LED (상태 표시기)
```

## 통신 프로토콜

크로스플랫폼 호환성을 위한 USB MIDI SysEx 기반 프로토콜.

SysEx 형식: `F0 7D 01 [cmd] [data...] F7`
- 제조사 ID: `0x7D` (교육/개발용)
- 기기 ID: `0x01` (DiveChecker)

### 기기 → 앱
| 명령 | Hex | 설명 |
|------|-----|------|
| Pressure | 0x01 | 차압 (7비트 인코딩 int32, hPa×1000) |
| Device Info | 0x02 | 시리얼, 이름, FW 버전, 센서 상태 |
| Config | 0x03 | 출력 속도 응답 |
| Auth Response | 0x04 | ECDSA 서명 (니블 인코딩) |
| Over-range Alert | 0x06 | 센서 측정 범위 초과 |
| Temperature | 0x07 | BMP280 온도 (int16×100) |
| Diagnostics | 0x08 | 가동시간, 에러 카운트, I2C 복구 |
| Full Config | 0x09 | 모든 설정 가능한 파라미터 |
| ACK | 0x0A | 명령 확인 (cmd + 상태) |

### 앱 → 기기
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
| Auth Challenge | 0x30 | ECDSA 인증 (64자 hex 논스) |
| Set PIN | 0x31 | PIN 변경 (기존 PIN + 새 PIN) |

## 키 생성

ECDSA 기기 인증용:

```bash
./generate_keys.sh
```

프로덕션 배포는 [PRODUCTION_GUIDE.md](PRODUCTION_GUIDE.md)를 참조하세요.

---

## 보안 및 안정성 기능

### 보안

| 기능 | 구현 |
|------|------|
| **ECDSA P-256 인증** | 32바이트 논스로 챌린지-응답 |
| **OTP에 개인키 저장** | 추출 불가능한 일회성 프로그래머블 저장소 |
| **상수 시간 비교** | PIN 검증으로 타이밍 공격 방지 |
| **암호 버퍼 제로화** | 사용 후 `mbedtls_platform_zeroize()` |
| **PIN Rate Limiting** | 지수 백오프 (1초 → 최대 60초) |
| **영구 잠금** | PIN 실패 횟수 재부팅 후에도 유지 |

### 안정성

| 기능 | 구현 |
|------|------|
| **워치독 타이머** | 부팅 중 8초, 운영 중 2초 |
| **센서 자동 복구** | 실패 시 5초마다 재시도 |
| **BOOTSEL 안전 종료** | 리셋 전 멀티코어 락아웃 + 인터럽트 비활성화 |
| **Flash CRC32** | 로드 시 데이터 무결성 검증 |
| **마모 평준화** | 4KB 섹터 내 16슬롯 로테이션 |
| **Flash 쓰기 디바운스** | 빠른 쓰기 방지를 위한 3초 지연 |
| **부팅 시 Flash 컴팩션** | 랩어라운드 구간의 erase 부담을 부팅 시점으로 이동 |
| **락아웃 후 I2C 유예 구간** | flash lockout 직후 일시적 NaN 샘플 무시 |
| **연속 센서 파이프라인** | 앱 연결 해제 중에도 Core 1 샘플링/필터링 지속 |
| **연결 타임아웃 여유** | UI 지연 허용을 위해 keepalive 타임아웃 10초로 확대 |
| **SysEx 타임아웃** | 500ms 파서 리셋 (모든 상태) |
| **PIO 폴백** | PIO0 사용 불가 시 PIO1로 자동 전환 |

### 성능

| 지표 | 값 |
|------|-----|
| **내부 샘플링** | 100Hz (BMP280) |
| **측정 범위** | 300-1250 hPa (데이터시트 1100 hPa 스펙 초과 확장) |
| **출력 속도** | 4-50Hz (설정 가능) |
| **센서→앱 지연** | ~10ms |
| **Core 0** | USB MIDI + 명령 처리 |
| **Core 1** | 센서 샘플링 + IIR 필터링 |
| **코어간 통신** | 락프리 FIFO 큐 |

### 메모리 레이아웃

```
Flash (총 4MB)
├── 0x000000-0x3FEFFF: 애플리케이션 코드 + 데이터
└── 0x3FF000-0x3FFFFF: 설정 섹터 (4KB)
    └── 16 × 256바이트 슬롯 (마모 평준화)
        ├── magic (4B)
        ├── PIN (5B)
        ├── name (25B)
        ├── config (8B)
        ├── reserved (210B)
        └── CRC32 (4B)
```

## 라이선스

Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)

Apache License 2.0 (소프트웨어) 및 CERN-OHL-S v2 (하드웨어)에 따라 라이선스됩니다.
