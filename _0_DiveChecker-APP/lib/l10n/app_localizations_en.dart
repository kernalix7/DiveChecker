// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DiveChecker';

  @override
  String get home => 'Home';

  @override
  String get measurement => 'Measurement';

  @override
  String get history => 'History';

  @override
  String get deviceConnected => 'DIVECHECKER CONNECTED';

  @override
  String get deviceNotConnected => 'NOT CONNECTED';

  @override
  String get deviceDiscovery => 'DEVICE DISCOVERY';

  @override
  String get searchingDevice => 'Searching for Divechecker device...';

  @override
  String get measurementReady => 'Ready for measurement';

  @override
  String get tapToConnect => 'Tap connect to start';

  @override
  String get connectDevice => 'CONNECT';

  @override
  String get disconnect => 'DISCONNECT';

  @override
  String get searching => 'SEARCHING...';

  @override
  String get makeSureDevicePowered =>
      'Make sure your Divechecker device is powered on';

  @override
  String get sensorError => 'Sensor Connection Error';

  @override
  String get sensorErrorDescription =>
      'Measurement sensor not detected. Please check the connection.';

  @override
  String get connectionRequired => 'Connection Required';

  @override
  String get connectionRequiredMessage =>
      'To start measurement, please connect to Divechecker device first.\n\nGo to Home tab and connect the device.';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get add => 'Add';

  @override
  String get connectedSuccess => 'Divechecker connected successfully!';

  @override
  String get disconnected => 'Divechecker disconnected';

  @override
  String get startMeasurement => 'START MEASUREMENT';

  @override
  String get stopMeasurement => 'STOP MEASUREMENT';

  @override
  String get pauseMeasurement => 'PAUSE';

  @override
  String get resumeMeasurement => 'RESUME';

  @override
  String get measurementStarted => 'Measurement started';

  @override
  String get measurementPaused => 'Measurement paused';

  @override
  String get measurementResumed => 'Measurement resumed';

  @override
  String get measurementComplete => 'Measurement Complete';

  @override
  String get measurementSaved => 'Measurement saved successfully';

  @override
  String get measurementSettings => 'MEASUREMENT';

  @override
  String measurementNumber(int number) {
    return 'Measurement #$number';
  }

  @override
  String get currentPressure => 'Current';

  @override
  String get maxPressure => 'Max';

  @override
  String get avgPressure => 'Avg';

  @override
  String get elapsedTime => 'Time';

  @override
  String get pressureUnit => 'Pressure Unit';

  @override
  String get sampleRate => 'Sample Rate';

  @override
  String get msInterval => 'ms interval';

  @override
  String get maxPressureLabel => 'Max Pressure';

  @override
  String get avgPressureLabel => 'Avg Pressure';

  @override
  String get durationLabel => 'Duration';

  @override
  String get pressureAnalysis => 'PRESSURE ANALYSIS';

  @override
  String get saveSession => 'Save Session';

  @override
  String get saveSessionQuestion =>
      'Do you want to save this measurement session?';

  @override
  String get save => 'Save';

  @override
  String get discard => 'Discard';

  @override
  String get sessionSaved => 'Session saved successfully';

  @override
  String get sessionDiscarded => 'Session discarded';

  @override
  String get noData => 'No Data';

  @override
  String get awaitingData => 'Awaiting measurement data';

  @override
  String get noMeasurements => 'No measurements yet';

  @override
  String get startMeasuringHint => 'Start measuring in the Measurement tab';

  @override
  String get sessionHistory => 'Session History';

  @override
  String get noSessions => 'No sessions yet';

  @override
  String get startMeasuringToSee => 'Start measuring to see your history here';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get deleteSessionConfirm =>
      'Are you sure you want to delete this session?';

  @override
  String get delete => 'Delete';

  @override
  String get sessionDeleted => 'Session deleted';

  @override
  String get deleteRecord => 'Delete Record';

  @override
  String get deleteRecordConfirm => 'Delete this measurement record?';

  @override
  String get recordDeleted => 'Record deleted';

  @override
  String get graphDetails => 'Graph Details';

  @override
  String get zoomIn => 'Zoom In';

  @override
  String get zoomOut => 'Zoom Out';

  @override
  String get resetZoom => 'Reset';

  @override
  String get panLeft => 'Pan Left';

  @override
  String get panRight => 'Pan Right';

  @override
  String get addNote => 'Add Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get noteHint => 'Enter a note for this session';

  @override
  String get noteContent => 'Note content';

  @override
  String get noteAdded => 'Note added';

  @override
  String get noteUpdated => 'Note updated';

  @override
  String get notes => 'Notes';

  @override
  String get noteInfo => 'Note Info';

  @override
  String get noNotes => 'No notes';

  @override
  String get tapGraphToAddNote => 'Tap the graph to add notes';

  @override
  String timePoint(int seconds) {
    return '${seconds}s mark';
  }

  @override
  String get statistics => 'Statistics';

  @override
  String get duration => 'Duration';

  @override
  String get dataPoints => 'Data Points';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get korean => 'Korean';

  @override
  String get appearance => 'APPEARANCE';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeDescription => 'Choose your preferred theme';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get getAlertsForMeasurements => 'Get alerts for measurements';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get vibrateOnKeyActions => 'Vibrate on key actions';

  @override
  String get editTitle => 'Edit Title';

  @override
  String get sessionTitle => 'Session Title';

  @override
  String get about => 'ABOUT';

  @override
  String get appVersion => 'App Version';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get licenses => 'Licenses';

  @override
  String get liveMonitoring => 'Live monitoring';

  @override
  String get currentPressureLabel => 'CURRENT PRESSURE';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String minutesSeconds(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String secondsOnly(int seconds) {
    return '${seconds}s';
  }

  @override
  String get tapToExpand => 'Tap to expand';

  @override
  String get measurementHistory => 'MEASUREMENT HISTORY';

  @override
  String get filterByDevice => 'Filter by Device';

  @override
  String get selectDevice => 'Select Device';

  @override
  String get allDevices => 'All Devices';

  @override
  String sessionsCount(int count) {
    return '$count sessions';
  }

  @override
  String get deviceSettings => 'Device Settings';

  @override
  String get deviceName => 'Device Name';

  @override
  String get changeDeviceName => 'Change Device Name';

  @override
  String get enterNewDeviceName => 'Enter new device name';

  @override
  String get devicePin => 'Device PIN';

  @override
  String get changeDevicePin => 'Change PIN';

  @override
  String get enterCurrentPin => 'Enter current PIN';

  @override
  String get enterNewPin => 'Enter new PIN (4 digits)';

  @override
  String get confirmNewPin => 'Confirm new PIN';

  @override
  String get wrongPin => 'Wrong PIN';

  @override
  String get pinChanged => 'PIN changed successfully';

  @override
  String get nameChanged => 'Device name changed';

  @override
  String get pinMustBe4Digits => 'PIN must be 4 digits';

  @override
  String get pinsMustMatch => 'PINs do not match';

  @override
  String get nameTooLong =>
      'Name too long (max 8 Korean chars or 24 English chars)';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get stop => 'Stop';

  @override
  String get liveSensorData => 'LIVE SENSOR DATA';

  @override
  String get recording => 'REC';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get appDescription => 'Freediving Equalizing Tool';

  @override
  String get samples => 'SAMPLES';

  @override
  String get points => 'points';

  @override
  String get analyticsComingSoon => 'Advanced analytics coming soon';

  @override
  String get analytics => 'Analytics';

  @override
  String get pressureWaveform => 'PRESSURE WAVEFORM';

  @override
  String get peak => 'PEAK';

  @override
  String get average => 'Average';

  @override
  String get sec => 'sec';

  @override
  String get deviceConnectedReady => 'Device Connected - Ready to measure';

  @override
  String get deviceNotConnectedShort => 'Device Not Connected';

  @override
  String get tapToBeginMonitoring => 'Tap to begin pressure monitoring';

  @override
  String sampleCount(int count) {
    return '$count samples';
  }

  @override
  String get noNotesYetTapEdit =>
      'No notes yet. Tap edit to add one or add notes on the graph.';

  @override
  String get madeWithFlutter => 'Made with Flutter';

  @override
  String get mitLicense => 'Apache License 2.0';

  @override
  String get mitLicenseContent =>
      'You may use, modify, and distribute with proper attribution and inclusion of the license and NOTICE file; provided \"AS IS\" without warranty.';

  @override
  String get bleConnectivity => 'BLE connectivity';

  @override
  String get chartVisualization => 'Chart visualization';

  @override
  String get sqliteDatabase => 'SQLite database';

  @override
  String get stateManagement => 'State management';

  @override
  String get localStorage => 'Local storage';

  @override
  String get internationalization => 'Internationalization';

  @override
  String get copyright => 'Copyright';

  @override
  String get allRightsReserved => 'All Rights Reserved';

  @override
  String get tapToViewFullLicense => 'Tap to view full license';

  @override
  String get analysis => 'Analysis';

  @override
  String get advancedAnalysis => 'Advanced Analysis';

  @override
  String get peakAnalysis => 'Peak Analysis';

  @override
  String get peakAnalysisDesc =>
      'Detect peaks and analyze equalization patterns';

  @override
  String get statisticsDashboard => 'Statistics Dashboard';

  @override
  String get statisticsDashboardDesc => 'View daily/weekly/monthly statistics';

  @override
  String get segmentAnalysis => 'Segment Analysis';

  @override
  String get segmentAnalysisDesc =>
      'Analyze and compare specific time segments';

  @override
  String get trendGraph => 'Trend Graph';

  @override
  String get trendGraphDesc => 'Track your progress over time';

  @override
  String get patternRecognition => 'Pattern Recognition';

  @override
  String get patternRecognitionDesc => 'Compare with ideal Frenzel patterns';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get featureInDevelopment =>
      'This feature is currently under development.';

  @override
  String get noSessionsForAnalysis => 'No sessions available for analysis';

  @override
  String get selectSession => 'Select Session';

  @override
  String get backToMenu => 'Back to Menu';

  @override
  String get keyMetrics => 'Key Metrics';

  @override
  String get totalPeaks => 'Total Peaks';

  @override
  String get peaksUnit => 'peaks';

  @override
  String get peakFrequency => 'Frequency';

  @override
  String get perMinute => '/min';

  @override
  String get avgPeakInterval => 'Avg Interval';

  @override
  String get avgPeakPressure => 'Avg Peak';

  @override
  String get performanceScores => 'Performance Scores';

  @override
  String get consistencyScore => 'Consistency Score';

  @override
  String get fatigueIndex => 'Fatigue Index';

  @override
  String get consistencyExcellent =>
      'Excellent! Very consistent equalization technique.';

  @override
  String get consistencyGood =>
      'Good. Minor variations in pressure and timing.';

  @override
  String get consistencyFair => 'Fair. Room for improvement in consistency.';

  @override
  String get consistencyNeedsWork =>
      'Needs work. Practice for more consistent technique.';

  @override
  String get fatigueMinimal => 'Minimal fatigue detected. Great endurance!';

  @override
  String get fatigueLow => 'Low fatigue. Performance maintained well.';

  @override
  String get fatigueModerate => 'Moderate fatigue. Consider shorter sessions.';

  @override
  String get fatigueHigh => 'High fatigue. Pressure decreased significantly.';

  @override
  String get detailedStats => 'Detailed Statistics';

  @override
  String get maxPeakPressure => 'Max Peak Pressure';

  @override
  String get minPeakPressure => 'Min Peak Pressure';

  @override
  String get pressureRange => 'Pressure Range';

  @override
  String get peakVisualization => 'Peak Visualization';

  @override
  String get detectedPeaks => 'Detected Peaks';

  @override
  String get dataManagement => 'DATA MANAGEMENT';

  @override
  String get backupData => 'Backup Data';

  @override
  String get backupDataDescription => 'Export all data as JSON file';

  @override
  String get restoreData => 'Restore Data';

  @override
  String get restoreDataDescription => 'Import data from backup file';

  @override
  String get backupSuccess => 'Backup completed successfully';

  @override
  String get backupFailed => 'Backup failed';

  @override
  String get restoreSuccess => 'Restore completed successfully';

  @override
  String get restoreFailed => 'Restore failed';

  @override
  String get restoreConfirm => 'Confirm Restore';

  @override
  String get restoreConfirmMessage =>
      'This will replace all existing data. Continue?';

  @override
  String get restore => 'Restore';

  @override
  String get invalidBackupFile => 'Invalid backup file';

  @override
  String dataPointsCount(int count) {
    return '$count data points';
  }

  @override
  String get appName => 'DiveChecker';

  @override
  String get appSubtitle => 'Equalizing Pressure Monitor';

  @override
  String get appTitleFull => 'DiveChecker Pro';

  @override
  String get statusOnline => 'ONLINE';

  @override
  String get statusOffline => 'OFFLINE';

  @override
  String get statusScanning => 'SCANNING...';

  @override
  String get statusRecording => 'REC';

  @override
  String get measurementScreenTitle => 'PRESSURE MEASUREMENT';

  @override
  String get historyScreenTitle => 'MEASUREMENT HISTORY';

  @override
  String get settingsScreenTitle => 'SETTINGS';

  @override
  String get segmentAvgPressureComparison =>
      'Segment Average Pressure Comparison';

  @override
  String get segmentDetailedAnalysis => 'Segment Detailed Analysis';

  @override
  String get segmentChangeAnalysis => 'Segment Change Analysis';

  @override
  String segmentNumber(int number) {
    return 'Segment $number';
  }

  @override
  String segmentTooltip(int index, String avgPressure, int peakCount) {
    return 'Segment $index\\nAvg: $avgPressure hPa\\nPeaks: $peakCount';
  }

  @override
  String get avgLabel => 'Avg';

  @override
  String get maxLabel => 'Max';

  @override
  String get peakLabel => 'Peak';

  @override
  String get countUnit => 'times';

  @override
  String get variabilityLabel => 'Variability';

  @override
  String get notEnoughSegments => 'Not enough segments';

  @override
  String get stablePressureAnalysis =>
      'Stable pressure! Consistent performance from start to finish.';

  @override
  String pressureIncreaseAnalysis(String percent) {
    return 'Pressure increased by $percent% towards the end. Warmup effect or stronger equalization.';
  }

  @override
  String pressureDecreaseAnalysis(String percent) {
    return 'Pressure decreased by $percent% towards the end. Fatigue may be accumulating. Consider rest.';
  }

  @override
  String get trendStable => 'Stable';

  @override
  String get trendRising => 'Rising trend';

  @override
  String get trendFalling => 'Falling trend';

  @override
  String get firstToLast => 'First → Last';

  @override
  String get peakCountChange => 'Peak count change';

  @override
  String get trendRising2 => 'Rising';

  @override
  String get trendFalling2 => 'Falling';

  @override
  String get trendMaintained => 'Maintained';

  @override
  String overallTrend(String trend) {
    return 'Overall trend: $trend';
  }

  @override
  String slopeLabel(String slope) {
    return 'Slope: $slope hPa/sec';
  }

  @override
  String get pressureTrendGraph => 'Pressure Trend Graph';

  @override
  String get originalData => 'Original data';

  @override
  String get movingAverage => 'Moving average';

  @override
  String get trendLine => 'Trend line';

  @override
  String get trendAnalysis => 'Trend Analysis';

  @override
  String get startPressureTrend => 'Start pressure (trend)';

  @override
  String get endPressureTrend => 'End pressure (trend)';

  @override
  String get changeAmount => 'Change amount';

  @override
  String get changeRate => 'Change rate';

  @override
  String get strongRisingTrend => 'Strong rising trend';

  @override
  String get strongRisingDesc =>
      'Pressure increases significantly over time. Muscles may be warmed up or you are applying more force.';

  @override
  String get moderateRisingTrend => 'Moderate rising trend';

  @override
  String get moderateRisingDesc =>
      'Pressure gradually increases. Good warmup pattern.';

  @override
  String get stableMaintained => 'Stable maintenance';

  @override
  String get stableMaintainedDesc =>
      'Pressure maintained consistently. Shows excellent endurance and consistency!';

  @override
  String get moderateFallingTrend => 'Moderate falling trend';

  @override
  String get moderateFallingDesc =>
      'Pressure gradually decreases. Some fatigue may be accumulating. Consider rest.';

  @override
  String get strongFallingTrend => 'Strong falling trend';

  @override
  String get strongFallingDesc =>
      'Pressure decreases significantly. Fatigue has accumulated. Sufficient rest is needed.';

  @override
  String get continuousPerformanceAnalysis => 'Continuous Performance Analysis';

  @override
  String get patternComparison => 'Pattern Comparison';

  @override
  String get peakQualityHeatmap => 'Peak Quality Heatmap';

  @override
  String get patternCharacteristics => 'Pattern Characteristics';

  @override
  String get customTrainingSuggestions => 'Custom Training Suggestions';

  @override
  String get maxConsecutive => 'Max consecutive';

  @override
  String get avgConsecutive => 'Avg consecutive';

  @override
  String get qualityPeaks => 'Quality peaks';

  @override
  String get excellentConsistency =>
      'Excellent! Maintaining consistent quality over time. Keep up this level.';

  @override
  String get goodConsistency =>
      'Good! Nice continuity. Aim for longer consecutive streaks.';

  @override
  String get moderateConsistency =>
      'Moderate. Maintain focus to increase consecutive quality peaks.';

  @override
  String get needsImprovementConsistency =>
      'Needs improvement. Focus more on each equalization.';

  @override
  String get masterPhase => 'Master phase';

  @override
  String get masterPhaseDesc =>
      'Advanced technique refinement and special situation preparation';

  @override
  String get masterFocuses =>
      'Dynamic equalization,High pressure simulation,Duration extension';

  @override
  String get advancedPhase => 'Advanced phase';

  @override
  String get advancedPhaseDesc =>
      'Consistency improvement and advanced technique acquisition';

  @override
  String get advancedFocuses =>
      'Pressure consistency enhancement,Rhythm optimization,Fatigue resistance training';

  @override
  String get intermediatePhase => 'Intermediate phase';

  @override
  String get intermediatePhaseDesc =>
      'Basic skill stabilization and quality improvement';

  @override
  String get intermediateFocuses =>
      'Accurate timing,Finding optimal pressure,Repeated practice';

  @override
  String get basicPhase => 'Basic phase';

  @override
  String get basicPhaseDesc =>
      'Basic movement acquisition and sensory development';

  @override
  String get basicFocuses =>
      'Basic posture,Breathing control,Low pressure practice';

  @override
  String get currentFocusAreas => 'Current focus areas:';

  @override
  String peakScore(int index, String score) {
    return 'Peak $index: $score points';
  }

  @override
  String get rhythmImprovementTraining => 'Rhythm improvement training';

  @override
  String get rhythmTip1 => 'Use a metronome app to practice at a steady beat';

  @override
  String get rhythmTip2 => 'Count: Equalize to a 1-2-3-4 rhythm';

  @override
  String get rhythmTip3 => 'Start slowly and gradually increase speed';

  @override
  String get pressureConsistencyTraining => 'Pressure consistency training';

  @override
  String get pressureTip1 =>
      'Aim for 10 consecutive equalizations with the same force';

  @override
  String get pressureTip2 =>
      'Watch your cheek and tongue movements in a mirror to keep them consistent';

  @override
  String get pressureTip3 =>
      'Find a comfortable pressure without pushing too hard';

  @override
  String get frequencyOptimizationTraining => 'Frequency optimization training';

  @override
  String get frequencyTip1 => 'Ideal frequency is 20-40 times per minute';

  @override
  String get frequencyTip2 => 'Make each equalization sufficient';

  @override
  String get frequencyTip3 => 'Avoid unnecessarily rapid equalizations';

  @override
  String get enduranceTraining => 'Endurance improvement training';

  @override
  String get enduranceTip1 => 'Gradually increase practice time';

  @override
  String get enduranceTip2 => 'Balance rest and training';

  @override
  String get enduranceTip3 =>
      'Regular practice is key to endurance improvement';

  @override
  String get irregularIntervalSuggestion =>
      'Equalization intervals are irregular. Practice with a consistent rhythm.';

  @override
  String get irregularPressureSuggestion =>
      'Peak pressure is irregular. Practice equalizing with consistent force.';

  @override
  String get lowFrequencySuggestion =>
      'Equalization frequency is low. Practice equalizing more frequently.';

  @override
  String get highFrequencySuggestion =>
      'Equalization is too frequent. Focus more on each equalization.';

  @override
  String get fatigueDetectedSuggestion =>
      'Pressure decreases towards the end. Endurance training may help.';

  @override
  String get excellentPattern => 'Excellent';

  @override
  String get excellentPatternDesc => 'Close to ideal Frenzel pattern!';

  @override
  String get minPressureLabel => 'Min pressure';

  @override
  String get goodPattern => 'Good';

  @override
  String get goodPatternDesc => 'Good basics. There are some improvements.';

  @override
  String get averagePattern => 'Average';

  @override
  String get averagePatternDesc =>
      'Basic pattern formed but needs improvement.';

  @override
  String get needsPractice => 'Needs practice';

  @override
  String get needsPracticeDesc =>
      'More practice needed. See suggestions below.';

  @override
  String get excellentPatternKeepUp =>
      'Your current pattern is excellent! Keep it up.';

  @override
  String patternGrade(String grade) {
    return 'Pattern grade: $grade';
  }

  @override
  String get rhythmLabel => 'Rhythm';

  @override
  String get pressureLabel => 'Pressure';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get enduranceLabel => 'Endurance';

  @override
  String get currentPattern => 'Current pattern';

  @override
  String get idealPattern => 'Ideal pattern';

  @override
  String get peakNumber => 'Peak number';

  @override
  String get rhythmConsistency => 'Rhythm consistency';

  @override
  String get pressureConsistency => 'Pressure consistency';

  @override
  String get frequencyAdequacy => 'Frequency adequacy';

  @override
  String get veryGood => 'Very good';

  @override
  String get good => 'Good';

  @override
  String get needsImprovement => 'Needs improvement';

  @override
  String get needsMorePractice => 'Needs more practice';

  @override
  String get noPeaksDetected => 'No peaks detected';

  @override
  String get selectAll => 'All';

  @override
  String get deselectAll => 'Deselect';

  @override
  String get avgRiseTime => 'Avg rise time';

  @override
  String get avgFallTime => 'Avg fall time';

  @override
  String get avgPeakWidth => 'Avg peak width';

  @override
  String get outliers => 'Outliers';

  @override
  String get peakIntensityDistribution => 'Peak intensity distribution';

  @override
  String get rhythmScore => 'Rhythm score';

  @override
  String get pressureScoreTitle => 'Pressure score';

  @override
  String get techniqueScore => 'Technique score';

  @override
  String get fatigueResistance => 'Fatigue resistance';

  @override
  String get strongPeaks => 'Strong peaks';

  @override
  String get moderatePeaks => 'Moderate peaks';

  @override
  String get weakPeaks => 'Weak peaks';

  @override
  String countWithPercent(int count, String percent) {
    return '$count ($percent%)';
  }

  @override
  String get overallGrade => 'Overall grade';

  @override
  String get excellentFrenzel => 'Excellent Frenzel technique!';

  @override
  String get veryGoodTechnique => 'Very good technique';

  @override
  String get satisfactoryLevel => 'Satisfactory level';

  @override
  String get roomForImprovement => 'Room for improvement';

  @override
  String get moreTrainingNeeded => 'More training needed';

  @override
  String get startFromBasics => 'Start from basics';

  @override
  String get weak => 'Weak';

  @override
  String get moderate => 'Moderate';

  @override
  String get strong => 'Strong';

  @override
  String get weakIntensity => 'Weak (<50hPa)';

  @override
  String get moderateIntensity => 'Moderate (50-100)';

  @override
  String get strongIntensity => 'Strong (>100)';

  @override
  String get stabilityImproving => 'Stability improving';

  @override
  String get stabilityDecreasing => 'Stability decreasing';

  @override
  String get stabilityMaintained => 'Stability maintained';

  @override
  String get stabilityTrend => 'Stability trend';

  @override
  String get pressureDistribution => 'Pressure distribution';

  @override
  String get basicStats => 'Basic statistics';

  @override
  String get dataPointsLabel => 'Data points';

  @override
  String get countUnitItems => 'items';

  @override
  String get measurementTime => 'Measurement time';

  @override
  String get standardDeviation => 'Standard deviation';

  @override
  String get advancedStats => 'Advanced statistics';

  @override
  String get coefficientOfVariation => 'Coefficient of variation';

  @override
  String get skewness => 'Skewness';

  @override
  String get kurtosis => 'Kurtosis';

  @override
  String get interquartileRange => 'Interquartile range';

  @override
  String get dataDispersionIndicator => 'Data dispersion indicator';

  @override
  String get pressureRangeLabel => 'Pressure range';

  @override
  String get rangeLabel => 'Range';

  @override
  String outlierCount(int count, String percent) {
    return '$count ($percent%)';
  }

  @override
  String get percentiles => 'Percentiles';

  @override
  String get median50 => 'Median (50%)';

  @override
  String get peakSummary => 'Peak summary';

  @override
  String get strongPeakRatio => 'Strong peak ratio';

  @override
  String get dataQuality => 'Data quality';

  @override
  String get outliersLabel => 'Outliers';

  @override
  String get samplingLabel => 'Sampling';

  @override
  String get dataLabel => 'Data';

  @override
  String get veryConsistent => 'Very consistent';

  @override
  String get consistent => 'Consistent';

  @override
  String get averageVariation => 'Average';

  @override
  String get highVariation => 'High variation';

  @override
  String get leftSkewed => 'Left-skewed distribution';

  @override
  String get rightSkewed => 'Right-skewed distribution';

  @override
  String get normalDistribution => 'Normal distribution';

  @override
  String get excellent => 'Excellent';

  @override
  String get satisfactory => 'Satisfactory';

  @override
  String get caution => 'Caution';

  @override
  String get symmetricDistribution => 'Symmetric distribution';

  @override
  String get flatDistribution => 'Flat distribution';

  @override
  String get peakedDistribution => 'Peaked distribution';

  @override
  String get normalPressureInterpretation =>
      'Pressure distribution is normal. Performing consistent Frenzel movements.';

  @override
  String get highPressureInterpretation =>
      'High pressure values appear frequently. Force control during peaks may be needed.';

  @override
  String get lowPressureInterpretation =>
      'Low pressure values are common. Practice applying stronger pressure.';

  @override
  String get concentratedInterpretation =>
      'Concentrated in specific pressure range. Shows good consistency.';

  @override
  String get dispersedInterpretation =>
      'Pressure is widely dispersed. Consistency improvement needed.';

  @override
  String medianLabel(String value) {
    return 'Median: $value hPa';
  }

  @override
  String get selected => 'Selected';

  @override
  String get excluded => 'Excluded';

  @override
  String keyMetricsWithPeaks(String metrics, int count) {
    return '$metrics ($count peaks)';
  }

  @override
  String scorePoints(String score) {
    return '$score pts';
  }

  @override
  String secondsValue(String value) {
    return '${value}s';
  }

  @override
  String histogramTooltip(String rangeStart, String rangeEnd, int count) {
    return '$rangeStart-$rangeEnd hPa\n$count';
  }

  @override
  String get selectUsbDevice => 'SELECT USB DEVICE';

  @override
  String get rescan => 'Rescan';

  @override
  String get availableDevices => 'Available Devices';

  @override
  String get noDevicesFound => 'No USB serial devices found';

  @override
  String get connecting => 'Connecting...';

  @override
  String get connectionError => 'Connection error';

  @override
  String get scanningForDevices => 'Scanning for USB devices...';

  @override
  String get scanAgain => 'Scan Again';

  @override
  String get deviceConnectedSuccessfully => 'Device connected successfully!';

  @override
  String get clearData => 'Clear Data';

  @override
  String get deleteAllMeasurementData => 'Delete all measurement data';

  @override
  String get exportDbToFile => 'Export DB to File';

  @override
  String get exportDatabaseForDebugging => 'Export database for debugging';

  @override
  String get deviceAuthenticated => 'Verified';

  @override
  String get deviceNotAuthenticated => 'Not Verified';

  @override
  String get counterfeitWarning => 'Unverified Device';

  @override
  String get counterfeitWarningTitle => 'Device Verification Failed';

  @override
  String get counterfeitWarningMessage =>
      'The connected device could not be verified as a genuine DiveChecker.\n\nUsing counterfeit devices may result in inaccurate measurements and limited technical support.';

  @override
  String get continueAnyway => 'Continue Anyway';

  @override
  String get verifyingDevice => 'Verifying device...';

  @override
  String get firmwareUpdate => 'Firmware Update';

  @override
  String get firmwareUpdateDescription => 'Check and update device firmware';

  @override
  String get firmwareVerificationSuccess => 'Signature verified';

  @override
  String get firmwareVerificationFailed => 'Signature verification failed';

  @override
  String get firmwareInstall => 'Install';

  @override
  String get firmwareRebootToBootsel => 'Reboot to BOOTSEL';

  @override
  String get firmwareRebootDescription =>
      'The device will reboot into BOOTSEL mode.\n\nAfter rebooting:\n1. A new drive \"RPI-RP2\" will appear\n2. Copy the .uf2 firmware file to it\n3. Device will automatically restart';

  @override
  String get currentFirmware => 'Current Firmware';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get rebootDevice => 'Reboot Device';

  @override
  String get rebootDeviceDescription => 'Restart the device';

  @override
  String get rebootConfirmMessage =>
      'Reboot the device? Connection will be lost.';

  @override
  String get reboot => 'Reboot';

  @override
  String get bootselMode => 'BOOTSEL Mode';

  @override
  String get bootselModeDescription => 'Manual firmware update mode';

  @override
  String get bootselRebootSent => 'BOOTSEL reboot command sent';

  @override
  String get deviceDisconnected => 'Device disconnected';

  @override
  String get pinMismatch => 'PINs do not match';

  @override
  String get pinChangeRequested => 'PIN change requested';

  @override
  String get nameChangeRequested => 'Name change requested';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get newPin => 'New PIN';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get newDeviceName => 'New Device Name';

  @override
  String get pinRequiredForChange => 'PIN required for changes';

  @override
  String get change => 'Change';

  @override
  String get myDevices => 'My Devices';

  @override
  String get connectedDevices => 'Connected Devices';

  @override
  String get noDeviceConnected => 'No device connected';

  @override
  String get displayResolution => 'Display Rate';

  @override
  String get displayResolutionDescription => 'Chart display update rate';

  @override
  String get outputRate => 'Output Rate';

  @override
  String get outputRateDescription => 'Sensor output frequency';

  @override
  String get tapToChange => 'Tap to change';

  @override
  String get connectDeviceFirst => 'Connect device first';

  @override
  String outputRateChanged(Object rate) {
    return 'Output rate changed to $rate Hz';
  }

  @override
  String get noiseFilter => 'Noise Filter';

  @override
  String get noiseFilterDescription => 'Software filter to reduce noise';

  @override
  String get filterStrength => 'Filter Strength';

  @override
  String get filterStrengthDescription => 'Higher values = more smoothing';

  @override
  String get atmosphericCalibrating => 'Calibrating atmospheric pressure...';

  @override
  String get atmosphericRecalibrate => 'Recalibrate Atmosphere';

  @override
  String get atmosphericKeepSensorStill => 'Keep sensor still in open air';

  @override
  String secondsRemaining(int seconds) {
    return '$seconds seconds remaining';
  }

  @override
  String get selectFile => 'Select File';

  @override
  String get backToFileList => 'Back to file list';

  @override
  String get readyToInstall => 'Ready to install';

  @override
  String get verificationFailed => 'Verification failed';
}
