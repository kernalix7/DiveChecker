# 변경 이력

[English](../CHANGELOG.md) | **한국어**

이 프로젝트의 주요 변경 사항은 이 문서에 기록됩니다.

형식은 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)를 기반으로 하며,
버전 정책은 [Semantic Versioning](https://semver.org/lang/ko/)을 지향합니다.

## [Unreleased]

## [8.1.0] — 2026-03-19

### 추가됨
- CI/CD 파이프라인에 macOS App Store Connect 자동 업로드 추가
- macOS ExportOptions.plist (App Store 배포용)

### 수정됨
- 그래프 상세 페이지: 그래프 노트 로딩에 mounted 체크 및 에러 처리 추가
- 차트 렌더링: 그래프 상세/전체화면 차트에서 이중 패스 → 단일 패스 min/max 계산으로 최적화
- 측정 화면: Consumer → Selector로 교체하여 불필요한 리빌드 감소
- MidiProvider: shutdown 시 StreamController 정리 및 인증 타임아웃 가드 추가

### 보안
- `.gitignore`: `.p12`, `.pfx`, `.p8`, `.mobileprovision`, `.provisionprofile`, `.env` 패턴 추가
- `tmp-igbkp/` 백업 툴킷 git 트래킹에서 제거

## [8.0.0] — 2026-03-18 (RTM 8.0)

### 추가됨
- GitHub 표준 파일: SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, CHANGELOG (영어+한국어)
- GitHub 템플릿: PR 템플릿, 버그 리포트, 기능 요청 이슈 템플릿
- 이중언어 문서 구조 (docs/ 디렉토리 한국어 번역)
- AI 멀티툴 프로젝트 설정 (.priv-storage/)

### 수정됨
- 샘플링 레이트 문서 100Hz → 160Hz 전체 README 수정
- 루트 README의 CONTRIBUTING.md 링크 수정

## [7.2.0] — 2026-03-12 (RTM 7.2)

### 추가됨
- 다국어 지원: 일본어 (ja), 중국어 간체 (zh), 중국어 번체 (zh_TW)
- 로케일 프로바이더 개선: 국가 코드 지원 및 SharedPreferences 영속화

### 수정됨
- 그래프 노트 압력 표시: 타임스탬프를 배열 인덱스로 사용하던 버그 → 최근접 포인트 탐색으로 수정
- 통계 측정 시간: 10배 오차 수정
- 왜도/첨도, 추세 그래프 기울기, 변화율의 0 나누기 방지
- 피크 분석기 `checkStart`가 `lastIdx` 초과 시 RangeError 수정
- GraphNote `fromMap()` 팩토리 타입 안전성 개선
- SessionRepository dispose 후 `notifyListeners()` 방지 가드

### 보안
- 펌웨어 `strcpy` → `strncpy`: 3개 비안전 호출을 바운디드 복사로 교체
- ECDSA 서명 실패 시 에러 카운터 증분 (진단용)

### 변경됨
- 측정/히스토리/설정 화면 하드코딩 문자열 → l10n 전환
- 웹 브랜딩 업데이트 (index.html, manifest.json)

## [7.1.1] — 2026-03-11

### 수정됨
- 마이너 안정성 개선 및 버그 수정

## [7.1.0] — 2026-03-10

### 추가됨
- 히스토리 화면에 세션 삭제 버튼
- 실시간 측정 전체화면 차트 뷰

## [6.0.0] — 2026-03-03 (RTM 6.0)

### 수정됨
- 근본 원인 안정화: 펌웨어 Core 1 샘플링이 앱 연결 상태에 의존하지 않도록 수정
- 재연결 기준점 보존: 일시적 재연결 시 암묵적 기준점 리셋 제거
- 플래시 잠금 해제 후 I2C 유예 창 추가
- 킵얼라이브 복원력: 타임아웃 마진 증가, 일시적 MIDI 스트림 에러 허용
- 크로스코어 메모리 순서: 기준점 및 잠금 플래그에 `__dmb()` 배리어 추가

## [4.0.0] — 2026-02-26 (RTM 4.0)

### 보안
- 백업 무결성 검증 (체크섬 검증)
- 플래시 CRC 검증 강화 (매직 필드 확인)
- MIDI SysEx 압력 인코딩 INT32_MIN 안전 처리
- 크로스코어 출력 속도 변경에 메모리 배리어 추가

### 수정됨
- 피크 분석 시간 계산 (`*0.25` → `/1000.0`)
- GraphNote 클래스 충돌 (모델/DB 레이어 간)
- USB 시리얼 번호를 칩 ID에서 올바르게 설정
- LED 초기화 실패 시 무한 PIO 블로킹 방지

### 변경됨
- 모니터 화면: 타이머 기반 UI 업데이트 (10Hz)
- 피크 분석기: O(1) 집합 탐색으로 개선
- USB 열거: 대기 루프 500ms → 10ms
- SerialProvider 제거; MidiProvider 직접 사용
- Linux/macOS 바이너리/번들 ID를 `io.kodenet.divechecker`로 통일

## [3.0.0] — 2026-02-19 (RTM 3.0)

### 보안
- 소프트 리부트 PIN 보호
- PIN 잠금 영속화 (재부팅 후에도 유지)
- 설정 로드 시 플래시 CRC32 검증
- 인증 후 암호 버퍼 제로화
- 타이밍 공격 방지 상수 시간 hex 검증

### 추가됨
- 자동 재연결: 지수 백오프 (2/4/6초, 최대 3회)
- 센서 자동 복구: BMP280 I2C 실패 시 5초 주기 재시도
- 조기 워치독: 부팅 8초, 운영 2초 타임아웃
- SysEx 타임아웃: 500ms 후 모든 상태에서 파서 리셋
- 측정/모니터 차트 동적 Y축 자동 스케일링
- BMP280 최대 측정 범위 1250 hPa로 확장

### 수정됨
- FIFO 핸드셰이크 버그로 인한 스테일 상태 읽기
- 동시 센서 재초기화 레이스 컨디션
- mbedTLS 컨텍스트 누수
- 저장 대화상자 중 연결 끊김 크래시
- BOOTSEL 안전 종료 시퀀스 (ALSA 크래시 수정)

## [1.2.0] — 2026-01

### 변경됨
- 모바일 차트 성능: LOD 포인트 축소, RepaintBoundary 추가, 애니메이션 비활성화
- LOD 시스템 단순화: 단일 `_lodData`로 통합
- ESP32 펌웨어 제거; Pico RP2350 전용으로 전환

## [1.1.0] — 2026-01-08

### 추가됨
- USB MIDI SysEx 통신 프로토콜
- ECDSA P-256 디바이스 인증
- 뷰포트 기반 차트 렌더링 (LTTB 유사 다운샘플링)
- 핀치 줌 및 팬 제스처
- 증분 통계 (업데이트당 O(1))

## [1.0.0] — 2025-12-17

### 추가됨
- DiveChecker 최초 릴리스
- 100Hz 내부 샘플링 실시간 압력 모니터링
- 줌/팬 지원 인터랙티브 압력 그래프
- SQLite 로컬 데이터 영속화
- USB MIDI 디바이스 연결 지원
- 세션 히스토리 및 분석
- 크로스플랫폼 지원 (Android, iOS, Linux, Windows, macOS)
