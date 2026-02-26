# DiveChecker Flutter 앱

프리다이빙 이퀄라이징 훈련을 위한 크로스플랫폼 압력 모니터링 앱입니다.

[🇺🇸 English](README.md)

## 지원 플랫폼

| 플랫폼 | 상태 | 연결 |
|--------|------|------|
| Android | ✅ 지원 | USB MIDI |
| iOS | ✅ 지원 | USB MIDI |
| Linux | ✅ 지원 | USB MIDI |
| Windows | ✅ 지원 | USB MIDI |
| macOS | ✅ 지원 | USB MIDI |
| Web | ⚠️ 제한적 | Web MIDI API |

## 요구사항

- Flutter SDK 3.10.4+
- Dart SDK 3.0+
- DiveChecker V1 기기 (RP2350 Pico2)

## 시작하기

```bash
# 의존성 설치
flutter pub get

# 로컬라이제이션 생성
flutter gen-l10n

# 실행
flutter run -d linux    # 또는 android, windows, macos, ios
```

## 빌드

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release
```

## 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── config/                      # 테마 설정
├── constants/                   # 상수 정의
├── core/                        # DB 인터페이스
│   └── database/
├── l10n/                        # 다국어 지원 (EN/KO)
├── models/                      # 데이터 모델
├── providers/                   # 상태 관리 (Provider)
│   ├── midi_provider.dart       # USB MIDI 연결
│   ├── measurement_controller.dart # 측정 로직
│   ├── session_repository.dart  # 세션 캐시
│   ├── settings_provider.dart   # 앱 설정
│   └── locale_provider.dart     # 언어 설정
├── screens/                     # 화면
│   ├── home_screen.dart         # 홈 (연결 상태)
│   ├── monitor_screen.dart      # 실시간 스트리밍 차트
│   ├── measurement_screen.dart  # 실시간 측정
│   ├── history_screen.dart      # 세션 기록
│   ├── graph_detail_page.dart   # 상세 그래프
│   ├── peak_analysis_page.dart  # 피크 분석
│   ├── settings_screen.dart     # 설정
│   ├── device_selection_screen.dart # 장치 선택
│   ├── device_settings_screen.dart  # 장치 설정
│   └── firmware_update_screen.dart  # OTA 펌웨어 업데이트
├── services/                    # 서비스
│   ├── unified_database_service.dart # DB 통합
│   └── backup_service.dart      # 백업/복원
├── security/                    # 보안
│   └── device_authenticator.dart # ECDSA 기기 인증
├── utils/                       # 유틸리티
│   ├── chart_utils.dart         # 차트 헬퍼 함수
│   └── peak_analyzer.dart       # 피크 분석 알고리즘
└── widgets/                     # UI 컴포넌트
    ├── analysis/                # 분석 위젯
    ├── common/                  # 공통 위젯
    ├── home/                    # 홈 위젯
    ├── measurement/             # 측정 위젯
    └── settings/                # 설정 위젯
```

## 주요 기능

### 🔌 USB MIDI 통신
- 크로스플랫폼 USB MIDI 지원
- ECDSA 기기 인증
- SysEx 기반 데이터 프로토콜
- 출력 속도 설정 가능 (4-50 Hz)

### 📊 실시간 압력 모니터링
- 100Hz 내부 샘플링, 설정 가능 출력 (4-50Hz, 기본 8Hz)
- 실시간 라인 차트 (fl_chart) 부드러운 베지어 곡선
- 측정/모니터 차트 동적 Y축 자동 스케일링
- 핀치 줌 / 드래그 팬 제스처
- Hz 기준 그리드 라인
- 차트 범위 200 hPa까지 확장

### 🔬 피크 분석
- 리듬 점수 (피크 간격 일관성)
- 압력 점수 (강도 균일성)
- 테크닉 점수 (상승/하강 시간)
- 피로도 지수
- 종합 등급 (S, A, B, C, D, F)

### 💾 데이터 관리
- SQLite (Native) / IndexedDB (Web)
- 세션 기록 및 그래프 노트
- JSON 백업/복원

### 🔐 보안 및 안정성
- **ECDSA P-256 인증**: 챌린지-응답 기기 검증
- **자동 재연결**: USB 끊김 시 지수 백오프 (2/4/6초, 최대 3회)
- **재연결 억제**: BOOTSEL/소프트 재부팅 후 자동 재연결 방지
- **비-DiveChecker 기기 차단**: 지원되지 않는 MIDI 기기 경고 다이얼로그
- **입력 검증**: 설정값 범위 제한 (clamp)
- **타이머 정리**: 연결 해제 시 모든 타이머 취소
- **Double-pop 방지**: Navigator.pop 중복 호출 방지
- **MIDI 데이터 보호**: 수신 MIDI 데이터 핸들러 try-catch 래핑

### 🌐 다국어 지원
- 🇺🇸 English
- 🇰🇷 한국어

## 테스트

```bash
# 단위 테스트
flutter test

# 통합 테스트
flutter test integration_test/
```

## 라이선스

Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)

Apache License 2.0에 따라 라이선스가 부여됩니다.

자세한 내용은 프로젝트 루트의 [LICENSE](../LICENSE) 파일을 참조하세요.
