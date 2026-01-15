# DiveChecker Flutter 앱

프리다이빙 이퀄라이징 훈련을 위한 크로스플랫폼 압력 모니터링 앱입니다.

## 지원 플랫폼

| 플랫폼 | 상태 |
|--------|------|
| Android | ✅ 지원 |
| iOS | ✅ 지원 |
| Linux | ✅ 지원 |
| Windows | ✅ 지원 |
| macOS | ✅ 지원 |
| Web | ⚠️ 제한적 (Serial 미지원) |

## 요구사항

- Flutter SDK 3.10.4+
- Dart SDK 3.0+

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

# Linux
flutter build linux --release

# Windows
flutter build windows --release
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
│   ├── serial_provider.dart     # USB Serial 연결
│   ├── measurement_controller.dart # 측정 로직
│   ├── session_repository.dart  # 세션 캐시
│   ├── settings_provider.dart   # 앱 설정
│   └── locale_provider.dart     # 언어 설정
├── screens/                     # 화면
│   ├── home_screen.dart         # 홈 (연결 상태)
│   ├── measurement_screen.dart  # 실시간 측정
│   ├── history_screen.dart      # 세션 기록
│   ├── graph_detail_page.dart   # 상세 그래프
│   ├── peak_analysis_page.dart  # 피크 분석
│   ├── settings_screen.dart     # 설정
│   └── serial_device_screen.dart # 장치 선택
├── services/                    # 서비스
│   ├── unified_database_service.dart # DB 통합
│   └── backup_service.dart      # 백업/복원
├── utils/                       # 유틸리티
│   └── peak_analyzer.dart       # 피크 분석 알고리즘
└── widgets/                     # UI 컴포넌트
    ├── analysis/                # 분석 위젯
    ├── common/                  # 공통 위젯
    ├── home/                    # 홈 위젯
    ├── measurement/             # 측정 위젯
    └── settings/                # 설정 위젯
```

## 주요 기능

### 📊 실시간 압력 모니터링
- 100Hz 내부 샘플링, 8Hz 출력
- 실시간 라인 차트 (fl_chart)
- 핀치 줌 / 드래그 팬 제스처

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

Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)

Apache License 2.0에 따라 라이선스가 부여됩니다.

자세한 내용은 프로젝트 루트의 [LICENSE](../LICENSE) 파일을 참조하세요.
