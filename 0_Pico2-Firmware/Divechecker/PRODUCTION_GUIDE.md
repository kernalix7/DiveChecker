# DiveChecker Production Deployment Guide

## 🔐 보안 키 관리 및 OTP 프로그래밍

### 개요

DiveChecker는 ECDSA P-256 비대칭 암호화를 사용하여 기기 인증을 수행합니다.

| 모드 | 키 저장 위치 | 용도 |
|------|-------------|------|
| Development | Flash (header file) | 개발/테스트 |
| Production | OTP (One-Time Programmable) | 양산 제품 |

### ⚠️ 중요: OTP는 한번 쓰면 변경 불가!

OTP(One-Time Programmable) 메모리는 물리적 퓨즈 기반으로, 한번 프로그래밍되면 **영구적으로 변경할 수 없습니다**.

---

## 1단계: 키 생성 (최초 1회)

```bash
cd 0_Pico2-Firmware/Divechecker
chmod +x generate_keys.sh
./generate_keys.sh
```

생성되는 파일:
- `keys/divechecker_private.pem` - 개인키 (PEM)
- `keys/divechecker_public.pem` - 공개키 (PEM)
- `keys/ecdsa_private_keys.h` - MCU용 (C header)
- `keys/ecdsa_public_key.dart` - App용 (Dart)

**⚠️ 키 백업 필수!** USB 드라이브나 안전한 위치에 보관하세요.

---

## 2단계: 개발 모드 테스트

### 2-1. MCU 빌드 (Flash 키 사용)

```bash
mkdir build && cd build
cmake ..
make
```

### 2-2. Flutter 앱에 공개키 복사

```bash
cp keys/ecdsa_public_key.dart ../_0_DiveChecker-APP/lib/security/
```

### 2-3. 테스트

1. 펌웨어 플래시
2. 앱 빌드 및 설치
3. 기기 연결 → 인증 성공 확인
4. USB 콘솔 로그 확인: `Device authentication: SUCCESS ✓`

---

## 3단계: OTP 프로그래밍 (Production)

### 사전 체크리스트

- [ ] 키 백업 완료
- [ ] 개발 모드에서 인증 테스트 성공
- [ ] Flutter 앱에서 인증 동작 확인
- [ ] **이 기기에 대해 OTP 프로그래밍이 처음임을 확인**

### 3-1. OTP 프로그래밍 실행

```bash
chmod +x program_otp_keys.sh
./program_otp_keys.sh
```

스크립트가 다음을 수행:
1. 키 파일 검증
2. picotool로 기기 확인 (BOOTSEL 모드)
3. 2단계 확인 후 OTP 쓰기

### 3-2. Production 펌웨어 빌드

`Divechecker.c`에서 주석 해제:
```c
// Uncomment for production builds with OTP keys:
#define USE_OTP_KEYS
```

재빌드:
```bash
cd build
make clean
make
```

### 3-3. 최종 테스트

1. Production 펌웨어 플래시
2. 앱에서 인증 테스트
3. USB 콘솔 로그 확인: `INFO:Keys loaded from OTP`

---

## 4단계: 펌웨어 업데이트 (Secure OTA)

### 서명된 펌웨어 생성

```bash
chmod +x sign_firmware.sh
./sign_firmware.sh build/Divechecker.uf2
```

출력:
- `build/Divechecker_signed.bin` - 서명된 펌웨어
- `build/Divechecker.sig` - 서명 파일

### OTA 업데이트 프로세스

1. 서명된 펌웨어를 앱으로 전송
2. MCU가 서명 검증
3. 검증 성공 시에만 업데이트 적용

---

## 보안 고려사항

### 키 보안

| 항목 | 권장 사항 |
|------|----------|
| 개인키 백업 | 오프라인 저장 (USB, 금고) |
| 개인키 삭제 | OTP 프로그래밍 후 PC에서 삭제 |
| 공개키 | 앱에 포함 (노출되어도 안전) |
| Git | keys/ 폴더 절대 커밋 금지 |

### OTP 읽기 보호

추가 보안을 위해 OTP 읽기 보호 설정 가능:
```bash
picotool otp lock OTP_PRIVATE_KEY_ROW
```

⚠️ 읽기 보호 후에는 picotool로도 키를 읽을 수 없음!

---

## 문제 해결

### OTP 프로그래밍 실패

| 오류 | 해결 방법 |
|------|----------|
| "No device found" | BOOTSEL 모드로 진입 |
| "picotool not found" | picotool 설치 확인 |
| "Keys not found" | generate_keys.sh 먼저 실행 |

### 인증 실패

| USB 콘솔 출력 | 원인 | 해결 |
|------------|------|------|
| `WARN:ECDSA keys not configured` | 플레이스홀더 키 | 키 생성/복사 |
| `WARN:OTP keys not programmed` | OTP 미프로그래밍 | OTP 프로그래밍 |
| `AUTH_ERR:Sign failed` | mbedtls 오류 | 키 손상 확인 |

---

## 파일 구조

```
0_Pico2-Firmware/Divechecker/
├── Divechecker.c           # 메인 펌웨어
├── otp_keys.h              # OTP 키 읽기 헤더
├── generate_keys.sh        # 키 생성 스크립트
├── program_otp_keys.sh     # OTP 프로그래밍 스크립트
├── sign_firmware.sh        # 펌웨어 서명 스크립트
└── keys/                   # ⚠️ GITIGNORE!
    ├── divechecker_private.pem
    ├── divechecker_public.pem
    ├── ecdsa_private_keys.h
    └── ecdsa_public_key.dart
```
