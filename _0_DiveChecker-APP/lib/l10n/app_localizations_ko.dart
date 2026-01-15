// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '다이브체커';

  @override
  String get home => '홈';

  @override
  String get measurement => '측정';

  @override
  String get history => '기록';

  @override
  String get deviceConnected => '본체 연결됨';

  @override
  String get deviceNotConnected => '연결 안됨';

  @override
  String get deviceDiscovery => '기기 검색';

  @override
  String get searchingDevice => 'Divechecker 본체를 검색하는 중...';

  @override
  String get measurementReady => '측정 준비 완료';

  @override
  String get tapToConnect => '연결 버튼을 눌러 시작하세요';

  @override
  String get connectDevice => '연결';

  @override
  String get disconnect => '연결 해제';

  @override
  String get searching => '검색 중...';

  @override
  String get makeSureDevicePowered => 'Divechecker 본체가 켜져 있는지 확인하세요';

  @override
  String get sensorError => '센서 연결 오류';

  @override
  String get sensorErrorDescription => '측정 센서가 감지되지 않습니다. 연결 상태를 확인해주세요.';

  @override
  String get connectionRequired => '연결 필요';

  @override
  String get connectionRequiredMessage =>
      '측정을 시작하려면 먼저 Divechecker 본체에 연결하세요.\n\n홈 탭에서 기기를 연결할 수 있습니다.';

  @override
  String get goToHome => '홈으로 이동';

  @override
  String get cancel => '취소';

  @override
  String get ok => '확인';

  @override
  String get close => '닫기';

  @override
  String get add => '추가';

  @override
  String get connectedSuccess => 'Divechecker 본체 연결 성공!';

  @override
  String get disconnected => 'Divechecker 본체 연결 해제됨';

  @override
  String get startMeasurement => '측정 시작';

  @override
  String get stopMeasurement => '측정 종료';

  @override
  String get pauseMeasurement => '일시정지';

  @override
  String get resumeMeasurement => '재개';

  @override
  String get measurementStarted => '측정이 시작되었습니다';

  @override
  String get measurementPaused => '측정이 일시정지되었습니다';

  @override
  String get measurementResumed => '측정이 재개되었습니다';

  @override
  String get measurementComplete => '측정 완료';

  @override
  String get measurementSaved => '측정이 저장되었습니다';

  @override
  String get measurementSettings => '측정 설정';

  @override
  String measurementNumber(int number) {
    return '측정 #$number';
  }

  @override
  String get currentPressure => '현재';

  @override
  String get maxPressure => '최대';

  @override
  String get avgPressure => '평균';

  @override
  String get elapsedTime => '시간';

  @override
  String get pressureUnit => '압력 단위';

  @override
  String get sampleRate => '샘플링 레이트';

  @override
  String get msInterval => 'ms 간격';

  @override
  String get maxPressureLabel => '최대 압력';

  @override
  String get avgPressureLabel => '평균 압력';

  @override
  String get durationLabel => '측정 시간';

  @override
  String get pressureAnalysis => '압력 분석';

  @override
  String get saveSession => '세션 저장';

  @override
  String get saveSessionQuestion => '이 측정 세션을 저장하시겠습니까?';

  @override
  String get save => '저장';

  @override
  String get discard => '삭제';

  @override
  String get sessionSaved => '세션이 저장되었습니다';

  @override
  String get sessionDiscarded => '세션이 삭제되었습니다';

  @override
  String get noData => '데이터 없음';

  @override
  String get awaitingData => '측정 데이터 대기 중';

  @override
  String get noMeasurements => '아직 측정 기록이 없습니다';

  @override
  String get startMeasuringHint => '측정 탭에서 첫 측정을 시작하세요';

  @override
  String get sessionHistory => '세션 기록';

  @override
  String get noSessions => '아직 세션이 없습니다';

  @override
  String get startMeasuringToSee => '측정을 시작하면 여기에 기록이 표시됩니다';

  @override
  String get deleteSession => '세션 삭제';

  @override
  String get deleteSessionConfirm => '이 세션을 삭제하시겠습니까?';

  @override
  String get delete => '삭제';

  @override
  String get sessionDeleted => '세션이 삭제되었습니다';

  @override
  String get deleteRecord => '기록 삭제';

  @override
  String get deleteRecordConfirm => '이 측정 기록을 삭제하시겠습니까?';

  @override
  String get recordDeleted => '기록이 삭제되었습니다';

  @override
  String get graphDetails => '그래프 상세';

  @override
  String get zoomIn => '확대';

  @override
  String get zoomOut => '축소';

  @override
  String get resetZoom => '초기화';

  @override
  String get panLeft => '왼쪽으로';

  @override
  String get panRight => '오른쪽으로';

  @override
  String get addNote => '메모 추가';

  @override
  String get editNote => '메모 수정';

  @override
  String get noteOptional => '메모 (선택사항)';

  @override
  String get noteHint => '이 세션에 대한 메모를 입력하세요';

  @override
  String get noteContent => '메모 내용';

  @override
  String get noteAdded => '메모가 추가되었습니다';

  @override
  String get noteUpdated => '메모가 수정되었습니다';

  @override
  String get notes => '메모';

  @override
  String get noteInfo => '메모 정보';

  @override
  String get noNotes => '메모가 없습니다';

  @override
  String get tapGraphToAddNote => '그래프를 탭하여 메모를 추가하세요';

  @override
  String timePoint(int seconds) {
    return '$seconds초 지점';
  }

  @override
  String get statistics => '통계';

  @override
  String get duration => '측정 시간';

  @override
  String get dataPoints => '데이터 포인트';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get english => '영어';

  @override
  String get korean => '한국어';

  @override
  String get appearance => '외관';

  @override
  String get theme => '테마';

  @override
  String get themeSystem => '시스템 설정';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get themeDescription => '선호하는 테마를 선택하세요';

  @override
  String get notifications => '알림';

  @override
  String get enableNotifications => '알림 활성화';

  @override
  String get getAlertsForMeasurements => '측정 알림 받기';

  @override
  String get hapticFeedback => '햅틱 피드백';

  @override
  String get vibrateOnKeyActions => '주요 동작 시 진동';

  @override
  String get editTitle => '제목 수정';

  @override
  String get sessionTitle => '세션 제목';

  @override
  String get about => '정보';

  @override
  String get appVersion => '앱 버전';

  @override
  String get helpAndSupport => '도움말 및 지원';

  @override
  String get licenses => '라이선스';

  @override
  String get liveMonitoring => '실시간 모니터링';

  @override
  String get currentPressureLabel => '현재 압력';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String minutesSeconds(int minutes, int seconds) {
    return '$minutes분 $seconds초';
  }

  @override
  String secondsOnly(int seconds) {
    return '$seconds초';
  }

  @override
  String get tapToExpand => '탭하여 확대';

  @override
  String get measurementHistory => '측정 기록';

  @override
  String get filterByDevice => '기기별 필터';

  @override
  String get selectDevice => '기기 선택';

  @override
  String get allDevices => '모든 기기';

  @override
  String sessionsCount(int count) {
    return '$count개 세션';
  }

  @override
  String get deviceSettings => '기기 설정';

  @override
  String get deviceName => '기기 이름';

  @override
  String get changeDeviceName => '기기 이름 변경';

  @override
  String get enterNewDeviceName => '새 기기 이름 입력';

  @override
  String get devicePin => '기기 PIN';

  @override
  String get changeDevicePin => 'PIN 변경';

  @override
  String get enterCurrentPin => '현재 PIN 입력';

  @override
  String get enterNewPin => '새 PIN 입력 (4자리)';

  @override
  String get confirmNewPin => '새 PIN 확인';

  @override
  String get wrongPin => '잘못된 PIN입니다';

  @override
  String get pinChanged => 'PIN이 변경되었습니다';

  @override
  String get nameChanged => '기기 이름이 변경되었습니다';

  @override
  String get pinMustBe4Digits => 'PIN은 4자리 숫자여야 합니다';

  @override
  String get pinsMustMatch => 'PIN이 일치하지 않습니다';

  @override
  String get nameTooLong => '이름이 너무 깁니다 (최대 한글 8자, 영어 24자)';

  @override
  String get pause => '일시정지';

  @override
  String get resume => '재개';

  @override
  String get stop => '종료';

  @override
  String get liveSensorData => '실시간 센서 데이터';

  @override
  String get recording => '녹화';

  @override
  String get openSourceLicenses => '오픈소스 라이선스';

  @override
  String get appDescription => '프리다이빙 이퀄라이징 도구';

  @override
  String get samples => '샘플';

  @override
  String get points => '점';

  @override
  String get analyticsComingSoon => '고급 분석 기능 추가 예정';

  @override
  String get analytics => '분석';

  @override
  String get pressureWaveform => '압력 파형';

  @override
  String get peak => '최대';

  @override
  String get average => '보통';

  @override
  String get sec => '초';

  @override
  String get deviceConnectedReady => '기기 연결됨 - 측정 준비 완료';

  @override
  String get deviceNotConnectedShort => '기기 연결 안됨';

  @override
  String get tapToBeginMonitoring => '탭하여 압력 모니터링 시작';

  @override
  String sampleCount(int count) {
    return '$count개 샘플';
  }

  @override
  String get noNotesYetTapEdit => '아직 메모가 없습니다. 수정 버튼을 탭하거나 그래프에서 메모를 추가하세요.';

  @override
  String get madeWithFlutter => 'Flutter로 제작됨';

  @override
  String get mitLicense => 'Apache 라이선스 2.0';

  @override
  String get mitLicenseContent =>
      '라이선스와 NOTICE를 포함해 사용·수정·배포할 수 있으며, 모든 소프트웨어는 보증 없이 \"있는 그대로(AS IS)\" 제공됩니다.';

  @override
  String get bleConnectivity => '블루투스 연결';

  @override
  String get chartVisualization => '차트 시각화';

  @override
  String get sqliteDatabase => 'SQLite 데이터베이스';

  @override
  String get stateManagement => '상태 관리';

  @override
  String get localStorage => '로컬 저장소';

  @override
  String get internationalization => '다국어 지원';

  @override
  String get copyright => '저작권';

  @override
  String get allRightsReserved => '모든 권리 보유';

  @override
  String get tapToViewFullLicense => '탭하여 라이선스 전문 보기';

  @override
  String get analysis => '분석';

  @override
  String get advancedAnalysis => '고급 분석';

  @override
  String get peakAnalysis => '피크 분석';

  @override
  String get peakAnalysisDesc => '피크 감지 및 이퀄라이제이션 패턴 분석';

  @override
  String get statisticsDashboard => '통계 대시보드';

  @override
  String get statisticsDashboardDesc => '일별/주별/월별 통계 보기';

  @override
  String get segmentAnalysis => '구간 분석';

  @override
  String get segmentAnalysisDesc => '특정 시간 구간 분석 및 비교';

  @override
  String get trendGraph => '추세 그래프';

  @override
  String get trendGraphDesc => '시간에 따른 발전 추적';

  @override
  String get patternRecognition => '패턴 인식';

  @override
  String get patternRecognitionDesc => '이상적인 Frenzel 패턴과 비교';

  @override
  String get comingSoon => '준비 중';

  @override
  String get featureInDevelopment => '이 기능은 현재 개발 중입니다.';

  @override
  String get noSessionsForAnalysis => '분석할 세션이 없습니다';

  @override
  String get selectSession => '세션 선택';

  @override
  String get backToMenu => '메뉴로 돌아가기';

  @override
  String get keyMetrics => '주요 지표';

  @override
  String get totalPeaks => '총 피크 수';

  @override
  String get peaksUnit => '회';

  @override
  String get peakFrequency => '빈도';

  @override
  String get perMinute => '회/분';

  @override
  String get avgPeakInterval => '평균 간격';

  @override
  String get avgPeakPressure => '평균 피크';

  @override
  String get performanceScores => '성능 점수';

  @override
  String get consistencyScore => '일관성 점수';

  @override
  String get fatigueIndex => '피로도 지수';

  @override
  String get consistencyExcellent => '훌륭합니다! 매우 일관된 이퀄라이제이션 기술입니다.';

  @override
  String get consistencyGood => '좋습니다. 압력과 타이밍에 약간의 변동이 있습니다.';

  @override
  String get consistencyFair => '보통입니다. 일관성 향상의 여지가 있습니다.';

  @override
  String get consistencyNeedsWork => '개선 필요. 더 일관된 기술을 위해 연습하세요.';

  @override
  String get fatigueMinimal => '피로도가 거의 없습니다. 훌륭한 지구력!';

  @override
  String get fatigueLow => '낮은 피로도. 성능이 잘 유지되었습니다.';

  @override
  String get fatigueModerate => '중간 피로도. 더 짧은 세션을 고려하세요.';

  @override
  String get fatigueHigh => '높은 피로도. 압력이 크게 감소했습니다.';

  @override
  String get detailedStats => '상세 통계';

  @override
  String get maxPeakPressure => '최대 피크 압력';

  @override
  String get minPeakPressure => '최소 피크 압력';

  @override
  String get pressureRange => '압력 범위';

  @override
  String get peakVisualization => '피크 시각화';

  @override
  String get detectedPeaks => '감지된 피크';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get backupData => '데이터 백업';

  @override
  String get backupDataDescription => '모든 데이터를 JSON 파일로 내보내기';

  @override
  String get restoreData => '데이터 복원';

  @override
  String get restoreDataDescription => '백업 파일에서 데이터 가져오기';

  @override
  String get backupSuccess => '백업이 완료되었습니다';

  @override
  String get backupFailed => '백업 실패';

  @override
  String get restoreSuccess => '복원이 완료되었습니다';

  @override
  String get restoreFailed => '복원 실패';

  @override
  String get restoreConfirm => '복원 확인';

  @override
  String get restoreConfirmMessage => '모든 기존 데이터가 교체됩니다. 계속하시겠습니까?';

  @override
  String get restore => '복원';

  @override
  String get invalidBackupFile => '잘못된 백업 파일';

  @override
  String dataPointsCount(int count) {
    return '$count개 데이터 포인트';
  }

  @override
  String get appName => '다이브체커';

  @override
  String get appSubtitle => '이퀄라이징 압력 모니터';

  @override
  String get appTitleFull => '다이브체커 프로';

  @override
  String get statusOnline => '연결됨';

  @override
  String get statusOffline => '미연결';

  @override
  String get statusScanning => '검색 중...';

  @override
  String get statusRecording => '녹화';

  @override
  String get measurementScreenTitle => '압력 측정';

  @override
  String get historyScreenTitle => '측정 기록';

  @override
  String get settingsScreenTitle => '설정';

  @override
  String get segmentAvgPressureComparison => '구간별 평균 압력 비교';

  @override
  String get segmentDetailedAnalysis => '구간별 상세 분석';

  @override
  String get segmentChangeAnalysis => '구간 변화 분석';

  @override
  String segmentNumber(int number) {
    return '구간 $number';
  }

  @override
  String segmentTooltip(int index, String avgPressure, int peakCount) {
    return '구간 $index\\n평균: $avgPressure hPa\\n피크: $peakCount회';
  }

  @override
  String get avgLabel => '평균';

  @override
  String get maxLabel => '최대';

  @override
  String get peakLabel => '피크';

  @override
  String get countUnit => '회';

  @override
  String get variabilityLabel => '변동성';

  @override
  String get notEnoughSegments => '구간이 충분하지 않습니다';

  @override
  String get stablePressureAnalysis =>
      '안정적인 압력 유지! 처음부터 끝까지 일관된 성능을 보여주고 있습니다.';

  @override
  String pressureIncreaseAnalysis(String percent) {
    return '후반부로 갈수록 압력이 $percent% 증가했습니다. 워밍업 효과가 나타났거나 더 강하게 이퀄라이징하고 있습니다.';
  }

  @override
  String pressureDecreaseAnalysis(String percent) {
    return '후반부로 갈수록 압력이 $percent% 감소했습니다. 피로도가 누적되고 있을 수 있습니다. 휴식을 고려하세요.';
  }

  @override
  String get trendStable => '안정적';

  @override
  String get trendRising => '상승 추세';

  @override
  String get trendFalling => '하락 추세';

  @override
  String get firstToLast => '처음 → 마지막';

  @override
  String get peakCountChange => '피크 수 변화';

  @override
  String get trendRising2 => '상승';

  @override
  String get trendFalling2 => '하락';

  @override
  String get trendMaintained => '유지';

  @override
  String overallTrend(String trend) {
    return '전체 추세: $trend';
  }

  @override
  String slopeLabel(String slope) {
    return '기울기: $slope hPa/초';
  }

  @override
  String get pressureTrendGraph => '압력 추세 그래프';

  @override
  String get originalData => '원본 데이터';

  @override
  String get movingAverage => '이동 평균';

  @override
  String get trendLine => '추세선';

  @override
  String get trendAnalysis => '추세 분석';

  @override
  String get startPressureTrend => '시작 압력 (추세)';

  @override
  String get endPressureTrend => '종료 압력 (추세)';

  @override
  String get changeAmount => '변화량';

  @override
  String get changeRate => '변화율';

  @override
  String get strongRisingTrend => '강한 상승 추세';

  @override
  String get strongRisingDesc =>
      '압력이 시간이 지남에 따라 크게 증가하고 있습니다. 근육이 워밍업되어 더 강한 이퀄라이제이션이 가능해졌거나, 점점 더 힘을 주고 있습니다.';

  @override
  String get moderateRisingTrend => '완만한 상승 추세';

  @override
  String get moderateRisingDesc => '압력이 서서히 증가하고 있습니다. 좋은 워밍업 패턴입니다.';

  @override
  String get stableMaintained => '안정적인 유지';

  @override
  String get stableMaintainedDesc => '압력이 일정하게 유지되고 있습니다. 훌륭한 지구력과 일관성을 보여줍니다!';

  @override
  String get moderateFallingTrend => '완만한 하락 추세';

  @override
  String get moderateFallingDesc =>
      '압력이 서서히 감소하고 있습니다. 약간의 피로도가 누적될 수 있으니 휴식을 고려하세요.';

  @override
  String get strongFallingTrend => '강한 하락 추세';

  @override
  String get strongFallingDesc =>
      '압력이 크게 감소하고 있습니다. 피로도가 누적되었습니다. 충분한 휴식이 필요합니다.';

  @override
  String get continuousPerformanceAnalysis => '연속 수행 분석';

  @override
  String get patternComparison => '패턴 비교';

  @override
  String get peakQualityHeatmap => '피크 품질 히트맵';

  @override
  String get patternCharacteristics => '패턴 특성';

  @override
  String get customTrainingSuggestions => '맞춤형 훈련 제안';

  @override
  String get maxConsecutive => '최대 연속';

  @override
  String get avgConsecutive => '평균 연속';

  @override
  String get qualityPeaks => '품질 피크';

  @override
  String get excellentConsistency =>
      '탁월합니다! 장시간 일관된 품질을 유지하고 있습니다. 현재 수준을 유지하세요.';

  @override
  String get goodConsistency => '좋습니다! 연속성이 좋습니다. 더 긴 연속 유지를 목표로 해보세요.';

  @override
  String get moderateConsistency => '중간 수준입니다. 집중력을 유지하여 연속 품질 피크를 늘려보세요.';

  @override
  String get needsImprovementConsistency =>
      '연속성 향상이 필요합니다. 각 이퀄라이제이션에 더 집중해보세요.';

  @override
  String get masterPhase => '마스터 단계';

  @override
  String get masterPhaseDesc => '고급 기술 연마 및 특수 상황 대비';

  @override
  String get masterFocuses => '다이나믹 이퀄라이제이션,고압 상황 시뮬레이션,지속시간 연장';

  @override
  String get advancedPhase => '심화 단계';

  @override
  String get advancedPhaseDesc => '일관성 향상 및 고급 기술 습득';

  @override
  String get advancedFocuses => '압력 일관성 강화,리듬 최적화,피로 저항 훈련';

  @override
  String get intermediatePhase => '중급 단계';

  @override
  String get intermediatePhaseDesc => '기본기 안정화 및 품질 향상';

  @override
  String get intermediateFocuses => '정확한 타이밍,적정 압력 찾기,반복 연습';

  @override
  String get basicPhase => '기초 단계';

  @override
  String get basicPhaseDesc => '기본 동작 습득 및 감각 개발';

  @override
  String get basicFocuses => '기본 자세,호흡 조절,낮은 압력 연습';

  @override
  String get currentFocusAreas => '현재 집중해야 할 영역:';

  @override
  String peakScore(int index, String score) {
    return '피크 $index: $score점';
  }

  @override
  String get rhythmImprovementTraining => '리듬 개선 훈련';

  @override
  String get rhythmTip1 => '메트로놈 앱을 사용하여 일정한 박자에 맞춰 연습하세요';

  @override
  String get rhythmTip2 => '숫자 세기: 1-2-3-4 리듬으로 이퀄라이제이션하세요';

  @override
  String get rhythmTip3 => '천천히 시작하여 점차 속도를 높여보세요';

  @override
  String get pressureConsistencyTraining => '압력 일관성 훈련';

  @override
  String get pressureTip1 => '같은 힘으로 10회 연속 이퀄라이제이션을 목표로 하세요';

  @override
  String get pressureTip2 => '거울을 보며 볼과 혀의 움직임을 일정하게 유지하세요';

  @override
  String get pressureTip3 => '너무 세게 하지 말고 편안한 압력을 찾으세요';

  @override
  String get frequencyOptimizationTraining => '빈도 최적화 훈련';

  @override
  String get frequencyTip1 => '이상적인 빈도는 분당 20-40회입니다';

  @override
  String get frequencyTip2 => '한 번에 충분한 이퀄라이제이션을 하세요';

  @override
  String get frequencyTip3 => '불필요하게 빠른 이퀄라이제이션을 피하세요';

  @override
  String get enduranceTraining => '지구력 향상 훈련';

  @override
  String get enduranceTip1 => '점진적으로 연습 시간을 늘려보세요';

  @override
  String get enduranceTip2 => '휴식과 훈련을 균형있게 배분하세요';

  @override
  String get enduranceTip3 => '규칙적인 연습이 지구력 향상의 핵심입니다';

  @override
  String get irregularIntervalSuggestion =>
      '이퀄라이제이션 간격이 불규칙합니다. 일정한 리듬으로 연습해보세요.';

  @override
  String get irregularPressureSuggestion =>
      '피크 압력이 불규칙합니다. 일정한 힘으로 이퀄라이징하는 연습이 필요합니다.';

  @override
  String get lowFrequencySuggestion =>
      '이퀄라이제이션 빈도가 낮습니다. 더 자주 이퀄라이징하는 연습을 해보세요.';

  @override
  String get highFrequencySuggestion =>
      '이퀄라이제이션이 너무 빈번합니다. 각 이퀄라이제이션에 더 집중해보세요.';

  @override
  String get fatigueDetectedSuggestion =>
      '후반부로 갈수록 압력이 감소합니다. 지구력 향상 훈련이 도움될 수 있습니다.';

  @override
  String get excellentPattern => '우수';

  @override
  String get excellentPatternDesc => '이상적인 Frenzel 패턴에 가깝습니다!';

  @override
  String get minPressureLabel => '최소 압력';

  @override
  String get goodPattern => '양호';

  @override
  String get goodPatternDesc => '좋은 기본기를 갖추고 있습니다. 몇 가지 개선점이 있습니다.';

  @override
  String get averagePattern => '보통';

  @override
  String get averagePatternDesc => '기본 패턴은 형성되었으나 개선이 필요합니다.';

  @override
  String get needsPractice => '연습 필요';

  @override
  String get needsPracticeDesc => '더 많은 연습이 필요합니다. 아래 제안을 참고하세요.';

  @override
  String get excellentPatternKeepUp => '현재 패턴이 매우 좋습니다! 꾸준히 유지하세요.';

  @override
  String patternGrade(String grade) {
    return '패턴 등급: $grade';
  }

  @override
  String get rhythmLabel => '리듬';

  @override
  String get pressureLabel => '압력';

  @override
  String get frequencyLabel => '빈도';

  @override
  String get enduranceLabel => '지구력';

  @override
  String get currentPattern => '현재 패턴';

  @override
  String get idealPattern => '이상적인 패턴';

  @override
  String get peakNumber => '피크 번호';

  @override
  String get rhythmConsistency => '리듬 일관성';

  @override
  String get pressureConsistency => '압력 일관성';

  @override
  String get frequencyAdequacy => '빈도 적절성';

  @override
  String get veryGood => '매우 좋음';

  @override
  String get good => '좋음';

  @override
  String get needsImprovement => '개선 필요';

  @override
  String get needsMorePractice => '많은 연습 필요';

  @override
  String get noPeaksDetected => '피크가 감지되지 않았습니다';

  @override
  String get selectAll => '전체';

  @override
  String get deselectAll => '해제';

  @override
  String get avgRiseTime => '평균 상승시간';

  @override
  String get avgFallTime => '평균 하강시간';

  @override
  String get avgPeakWidth => '평균 피크폭';

  @override
  String get outliers => '이상치';

  @override
  String get peakIntensityDistribution => '피크 강도 분포';

  @override
  String get rhythmScore => '리듬 점수';

  @override
  String get pressureScoreTitle => '압력 점수';

  @override
  String get techniqueScore => '기술 점수';

  @override
  String get fatigueResistance => '피로 저항';

  @override
  String get strongPeaks => '강한 피크';

  @override
  String get moderatePeaks => '보통 피크';

  @override
  String get weakPeaks => '약한 피크';

  @override
  String countWithPercent(int count, String percent) {
    return '$count개 ($percent%)';
  }

  @override
  String get overallGrade => '종합 등급';

  @override
  String get excellentFrenzel => '탁월한 프렌젤 기법!';

  @override
  String get veryGoodTechnique => '매우 좋은 기법입니다';

  @override
  String get satisfactoryLevel => '양호한 수준입니다';

  @override
  String get roomForImprovement => '개선 여지가 있습니다';

  @override
  String get moreTrainingNeeded => '더 연습이 필요합니다';

  @override
  String get startFromBasics => '기초부터 연습하세요';

  @override
  String get weak => '약함';

  @override
  String get moderate => '보통';

  @override
  String get strong => '강함';

  @override
  String get weakIntensity => '약함 (<50hPa)';

  @override
  String get moderateIntensity => '보통 (50-100)';

  @override
  String get strongIntensity => '강함 (>100)';

  @override
  String get stabilityImproving => '안정성 향상 중';

  @override
  String get stabilityDecreasing => '안정성 저하 중';

  @override
  String get stabilityMaintained => '안정적 유지';

  @override
  String get stabilityTrend => '안정성 추세';

  @override
  String get pressureDistribution => '압력 분포';

  @override
  String get basicStats => '기본 통계';

  @override
  String get dataPointsLabel => '데이터 포인트';

  @override
  String get countUnitItems => '개';

  @override
  String get measurementTime => '측정 시간';

  @override
  String get standardDeviation => '표준편차';

  @override
  String get advancedStats => '고급 통계';

  @override
  String get coefficientOfVariation => '변동계수';

  @override
  String get skewness => '왜도';

  @override
  String get kurtosis => '첨도';

  @override
  String get interquartileRange => '사분위 범위';

  @override
  String get dataDispersionIndicator => '데이터 산포 지표';

  @override
  String get pressureRangeLabel => '압력 범위';

  @override
  String get rangeLabel => '범위';

  @override
  String outlierCount(int count, String percent) {
    return '$count개 ($percent%)';
  }

  @override
  String get percentiles => '백분위수';

  @override
  String get median50 => '중앙값 (50%)';

  @override
  String get peakSummary => '피크 요약';

  @override
  String get strongPeakRatio => '강한 피크 비율';

  @override
  String get dataQuality => '데이터 품질';

  @override
  String get outliersLabel => '이상치';

  @override
  String get samplingLabel => '샘플링';

  @override
  String get dataLabel => '데이터';

  @override
  String get veryConsistent => '매우 일관적';

  @override
  String get consistent => '일관적';

  @override
  String get averageVariation => '보통';

  @override
  String get highVariation => '변동 큼';

  @override
  String get leftSkewed => '왼쪽 꼬리 분포';

  @override
  String get rightSkewed => '오른쪽 꼬리 분포';

  @override
  String get normalDistribution => '정규 분포';

  @override
  String get excellent => '우수';

  @override
  String get satisfactory => '양호';

  @override
  String get caution => '주의';

  @override
  String get symmetricDistribution => '대칭 분포';

  @override
  String get flatDistribution => '평평한 분포';

  @override
  String get peakedDistribution => '뾰족한 분포';

  @override
  String get normalPressureInterpretation =>
      '압력 분포가 정상적입니다. 일관된 프렌젤 동작을 수행하고 있습니다.';

  @override
  String get highPressureInterpretation =>
      '높은 압력 값이 자주 나타납니다. 피크 시 힘 조절이 필요할 수 있습니다.';

  @override
  String get lowPressureInterpretation =>
      '낮은 압력 값이 많습니다. 더 강한 압력을 가하는 연습이 필요합니다.';

  @override
  String get concentratedInterpretation => '특정 압력대에 집중되어 있습니다. 좋은 일관성을 보여줍니다.';

  @override
  String get dispersedInterpretation => '압력이 넓게 분산되어 있습니다. 일관성 향상이 필요합니다.';

  @override
  String medianLabel(String value) {
    return '중앙값: $value hPa';
  }

  @override
  String get selected => '선택됨';

  @override
  String get excluded => '제외됨';

  @override
  String keyMetricsWithPeaks(String metrics, int count) {
    return '$metrics ($count개 피크 기준)';
  }

  @override
  String scorePoints(String score) {
    return '$score점';
  }

  @override
  String secondsValue(String value) {
    return '$value초';
  }

  @override
  String histogramTooltip(String rangeStart, String rangeEnd, int count) {
    return '$rangeStart-$rangeEnd hPa\n$count개';
  }

  @override
  String get selectUsbDevice => 'USB 장치 선택';

  @override
  String get rescan => '다시 검색';

  @override
  String get availableDevices => '사용 가능한 장치';

  @override
  String get noDevicesFound => 'USB 시리얼 장치를 찾을 수 없습니다';

  @override
  String get connecting => '연결 중...';

  @override
  String get connectionError => '연결 오류';

  @override
  String get scanningForDevices => 'USB 장치 검색 중...';

  @override
  String get scanAgain => '다시 검색';

  @override
  String get deviceConnectedSuccessfully => '장치가 성공적으로 연결되었습니다!';

  @override
  String get clearData => '데이터 삭제';

  @override
  String get deleteAllMeasurementData => '모든 측정 데이터 삭제';

  @override
  String get exportDbToFile => 'DB 파일 내보내기';

  @override
  String get exportDatabaseForDebugging => '디버깅용 데이터베이스 내보내기';

  @override
  String get deviceAuthenticated => '정품 인증됨';

  @override
  String get deviceNotAuthenticated => '인증 실패';

  @override
  String get counterfeitWarning => '정품 확인 불가';

  @override
  String get counterfeitWarningTitle => '정품 인증 실패';

  @override
  String get counterfeitWarningMessage =>
      '연결된 장치가 정품 DiveChecker로 인증되지 않았습니다.\n\n복제품 사용 시 정확하지 않은 측정값이 나올 수 있으며, 기술 지원이 제한됩니다.';

  @override
  String get continueAnyway => '계속 사용';

  @override
  String get verifyingDevice => '기기 인증 중...';

  @override
  String get firmwareUpdate => '펌웨어 업데이트';

  @override
  String get firmwareUpdateDescription => '기기 펌웨어 확인 및 업데이트';

  @override
  String get firmwareVerificationSuccess => '서명 검증 성공';

  @override
  String get firmwareVerificationFailed => '서명 검증 실패';

  @override
  String get firmwareInstall => '설치';

  @override
  String get firmwareRebootToBootsel => 'BOOTSEL 모드로 재부팅';

  @override
  String get firmwareRebootDescription =>
      '기기가 BOOTSEL 모드로 재부팅됩니다.\n\n재부팅 후:\n1. \"RPI-RP2\" 드라이브가 나타납니다\n2. .uf2 펌웨어 파일을 복사하세요\n3. 기기가 자동으로 재시작됩니다';

  @override
  String get currentFirmware => '현재 펌웨어';

  @override
  String get dangerZone => '위험 영역';

  @override
  String get rebootDevice => '기기 재시작';

  @override
  String get rebootDeviceDescription => '기기를 재시작합니다';

  @override
  String get rebootConfirmMessage => '기기를 재시작하시겠습니까? 연결이 끊어집니다.';

  @override
  String get reboot => '재시작';

  @override
  String get bootselMode => 'BOOTSEL 모드';

  @override
  String get bootselModeDescription => '펌웨어 수동 업데이트 모드';

  @override
  String get bootselRebootSent => 'BOOTSEL 재부팅 명령 전송됨';

  @override
  String get deviceDisconnected => '기기 연결이 해제되었습니다';

  @override
  String get pinMismatch => 'PIN이 일치하지 않습니다';

  @override
  String get pinChangeRequested => 'PIN 변경 요청됨';

  @override
  String get nameChangeRequested => '이름 변경 요청됨';

  @override
  String get currentPin => '현재 PIN';

  @override
  String get newPin => '새 PIN';

  @override
  String get confirmPin => 'PIN 확인';

  @override
  String get newDeviceName => '새 기기 이름';

  @override
  String get pinRequiredForChange => '설정 변경에 PIN 필요';

  @override
  String get change => '변경';

  @override
  String get myDevices => '내 기기';

  @override
  String get connectedDevices => '연결된 기기';

  @override
  String get noDeviceConnected => '연결된 기기 없음';

  @override
  String get displayResolution => '화면 갱신률';

  @override
  String get displayResolutionDescription => '차트 화면 갱신 속도';

  @override
  String get outputRate => '출력 주파수';

  @override
  String get outputRateDescription => '센서 출력 주파수';

  @override
  String get tapToChange => '탭하여 변경';

  @override
  String get connectDeviceFirst => '기기를 먼저 연결하세요';

  @override
  String outputRateChanged(Object rate) {
    return '출력 주파수가 $rate Hz로 변경되었습니다';
  }

  @override
  String get noiseFilter => '노이즈 필터';

  @override
  String get noiseFilterDescription => '노이즈 감소를 위한 소프트웨어 필터';

  @override
  String get filterStrength => '필터 강도';

  @override
  String get filterStrengthDescription => '값이 높을수록 더 부드럽게 표시';
}
