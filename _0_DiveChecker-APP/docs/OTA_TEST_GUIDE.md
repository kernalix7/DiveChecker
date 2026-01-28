# DiveChecker OTA 펌웨어 업데이트 테스트 가이드

[🇺🇸 English](OTA_TEST_GUIDE.en.md)

## 테스트 환경 준비

### 1. 키 생성 (최초 1회)
```bash
cd 0_Pico2-Firmware/Divechecker
./generate_keys.sh
```
- `keys/divechecker_private.pem`: 펌웨어 서명용 개인키
- `keys/divechecker_public.pem`: 검증용 공개키
- `keys/ecdsa_private_keys.h`: MCU용 키 헤더

### 2. 펌웨어 빌드
```bash
cd 0_Pico2-Firmware/Divechecker
mkdir -p build && cd build
cmake -DPICO_SDK_PATH=$HOME/pico/pico-sdk ..
make -j4
```
결과: `Divechecker.uf2`

### 3. 펌웨어 서명
```bash
cd 0_Pico2-Firmware/Divechecker
./sign_firmware.sh build/Divechecker.uf2
```
결과: `build/Divechecker_signed.bin`

---

## 앱 테스트

### 1. l10n 재생성
```bash
cd _0_DiveChecker-APP
flutter gen-l10n
```

### 2. 앱 실행
```bash
flutter run -d linux  # 또는 macos, windows
```

### 3. 펌웨어 검증 테스트

#### 테스트 케이스 1: 정상 서명된 펌웨어
1. `Divechecker_signed.bin`을 Downloads 폴더에 복사
2. 설정 → 내 기기 → DiveChecker → 펌웨어 업데이트
3. 파일 선택 → ✓ **Signature Valid** 표시 확인

#### 테스트 케이스 2: 잘못된 파일
1. 임의의 `.bin` 파일 선택
2. ✗ **Invalid magic header** 에러 확인

#### 테스트 케이스 3: 손상된 서명
```bash
# 파일 일부 변조
dd if=/dev/urandom of=corrupted.bin bs=1 count=100
cat build/Divechecker_signed.bin >> corrupted.bin
```
- ✗ **Signature verification failed** 확인

#### 테스트 케이스 4: 다른 키로 서명된 펌웨어
```bash
# 새 키 생성 후 서명
openssl ecparam -genkey -name prime256v1 -noout -out fake_key.pem
# ... 이 키로 서명된 펌웨어는 검증 실패
```

---

## BOOTSEL 테스트

### 테스트 절차
1. 기기 연결 상태에서 설정 → 내 기기 → DiveChecker
2. "BOOTSEL 모드" 선택
3. 확인 다이얼로그에서 "재부팅" 선택
4. 결과 확인:
   - USB 연결 해제됨
   - `RPI-RP2` 드라이브 나타남
   - `.uf2` 파일 복사 가능

### 복구 테스트
잘못된 펌웨어 설치 후 복구:
1. 기기 전원 끈 상태에서 BOOTSEL 버튼 누르고 연결
2. `RPI-RP2` 드라이브에 정상 펌웨어 복사

---

## 검증 항목 체크리스트

### 보안
- [x] ECDSA P-256 서명 검증
- [x] SHA-256 해시 계산
- [x] DER 서명 포맷 파싱
- [x] 잘못된 키 거부
- [x] 손상된 파일 거부
- [x] 크기 불일치 감지

### UI/UX
- [x] 파일 목록 표시
- [x] 검증 결과 표시 (성공/실패)
- [x] 파일 정보 표시 (크기, 해시)
- [x] 버전 정보 파싱 (가능한 경우)
- [x] BOOTSEL 재부팅 확인 다이얼로그

### 에러 처리
- [x] 파일 없음 처리
- [x] 파일 읽기 오류 처리
- [x] 네트워크 오류 처리 (향후 GitHub 연동 시)
- [ ] 타임아웃 처리 (대용량 파일)

---

## 제한사항 및 향후 개선

### 현재 제한사항
1. **수동 복사 필요**: BOOTSEL 후 `.uf2` 파일을 직접 복사해야 함
2. **다운그레이드 가능**: 버전 비교 후 경고만 표시
3. **단일 기기만 지원**: 여러 기기 동시 연결 미지원

### 향후 개선 예정
1. GitHub Releases에서 펌웨어 자동 다운로드
2. 펌웨어 버전 비교 및 업그레이드만 허용 옵션
3. USB Mass Storage 자동 복사 (플랫폼별)
4. 업데이트 롤백 지원

---

## 트러블슈팅

### 문제: 서명 검증 항상 실패
**원인**: 앱의 공개키와 서명에 사용된 개인키가 다름
**해결**: `generate_keys.sh` 재실행 후 앱/펌웨어 모두 재빌드

### 문제: BOOTSEL 명령 무응답
**원인**: MIDI 연결 끊김 또는 펌웨어 미지원
**해결**: 기기 재연결 후 재시도, 펌웨어 버전 확인

### 문제: RPI-RP2 드라이브 안 보임
**원인**: USB 연결 문제 또는 이미 플래싱 완료
**해결**: USB 케이블 교체, 기기 전원 재연결
