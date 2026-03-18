// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'DiveChecker';

  @override
  String get disclaimerTitle => '重要提示';

  @override
  String get disclaimerContent =>
      'DiveChecker 仅用于自由潜水均压训练参考。\n\n⚠️ 本应用不是医疗设备，不可用于医疗诊断或治疗目的。\n\n⚠️ 潜水时请始终将安全放在首位。请勿仅依赖此应用做出潜水决策。\n\n⚠️ 开发者对使用本应用过程中可能发生的事故、伤害或损失不承担任何责任。\n\n使用本应用即视为同意以上条款。';

  @override
  String get disclaimerAgree => '我已理解并同意';

  @override
  String get disclaimerDoNotShowAgain => '不再显示';

  @override
  String get home => '首页';

  @override
  String get monitor => '监测';

  @override
  String get measurement => '测量';

  @override
  String get history => '记录';

  @override
  String get deviceConnected => '设备已连接';

  @override
  String get deviceNotConnected => '未连接';

  @override
  String get deviceDiscovery => '搜索设备';

  @override
  String get searchingDevice => '正在搜索 DiveChecker 设备...';

  @override
  String get measurementReady => '测量准备就绪';

  @override
  String get tapToConnect => '请点击连接按钮开始';

  @override
  String get connectDevice => '连接';

  @override
  String get disconnect => '断开连接';

  @override
  String get searching => '搜索中...';

  @override
  String get makeSureDevicePowered => '请确认 DiveChecker 设备已开机';

  @override
  String get sensorError => '传感器连接错误';

  @override
  String get sensorErrorDescription => '未检测到测量传感器。请检查连接状态。';

  @override
  String get connectionRequired => '需要连接';

  @override
  String get connectionRequiredMessage =>
      '要开始测量，请先连接 DiveChecker 设备。\n\n您可以在首页标签页中连接设备。';

  @override
  String get goToHome => '前往首页';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get ok => '确定';

  @override
  String get close => '关闭';

  @override
  String get add => '添加';

  @override
  String get peakAnalysisDisclaimer => '此分析仅供参考，并非完全准确。请谨慎解读结果。';

  @override
  String get connectedSuccess => 'DiveChecker 设备连接成功！';

  @override
  String get disconnected => 'DiveChecker 设备已断开';

  @override
  String get unsupportedDevice => '不支持的设备';

  @override
  String get onlyDiveCheckerSupported => '仅支持 DiveChecker 设备。此设备无法在本应用中使用。';

  @override
  String get startMeasurement => '开始测量';

  @override
  String get stopMeasurement => '结束测量';

  @override
  String get pauseMeasurement => '暂停';

  @override
  String get resumeMeasurement => '继续';

  @override
  String get measurementStarted => '测量已开始';

  @override
  String get measurementPaused => '测量已暂停';

  @override
  String get measurementResumed => '测量已继续';

  @override
  String get measurementComplete => '测量完成';

  @override
  String get measurementSaved => '测量已保存';

  @override
  String get measurementSettings => '测量设置';

  @override
  String measurementNumber(int number) {
    return '测量 #$number';
  }

  @override
  String get currentPressure => '当前';

  @override
  String get maxPressure => '最大';

  @override
  String get avgPressure => '平均';

  @override
  String get elapsedTime => '时间';

  @override
  String get pressureUnit => '压力单位';

  @override
  String get sampleRate => '采样率';

  @override
  String get msInterval => 'ms 间隔';

  @override
  String get maxPressureLabel => '最大压力';

  @override
  String get avgPressureLabel => '平均压力';

  @override
  String get durationLabel => '测量时长';

  @override
  String get pressureAnalysis => '压力分析';

  @override
  String get saveSession => '保存会话';

  @override
  String get saveSessionQuestion => '是否保存此测量会话？';

  @override
  String get save => '保存';

  @override
  String get discard => '删除';

  @override
  String get sessionSaved => '会话已保存';

  @override
  String get sessionDiscarded => '会话已删除';

  @override
  String get noData => '暂无数据';

  @override
  String get awaitingData => '等待测量数据';

  @override
  String get noMeasurements => '暂无测量记录';

  @override
  String get startMeasuringHint => '请在测量标签页开始首次测量';

  @override
  String get sessionHistory => '会话记录';

  @override
  String get noSessions => '暂无会话';

  @override
  String get startMeasuringToSee => '开始测量后，记录将在此显示';

  @override
  String get deleteSession => '删除会话';

  @override
  String get deleteSessionConfirm => '确定要删除此会话吗？';

  @override
  String get delete => '删除';

  @override
  String get sessionDeleted => '会话已删除';

  @override
  String get deleteRecord => '删除记录';

  @override
  String get deleteRecordConfirm => '确定要删除此测量记录吗？';

  @override
  String get recordDeleted => '记录已删除';

  @override
  String get graphDetails => '图表详情';

  @override
  String get zoomIn => '放大';

  @override
  String get zoomOut => '缩小';

  @override
  String get resetZoom => '重置';

  @override
  String get panLeft => '向左';

  @override
  String get panRight => '向右';

  @override
  String get addNote => '添加备注';

  @override
  String get editNote => '编辑备注';

  @override
  String get noteOptional => '备注（可选）';

  @override
  String get noteHint => '请输入此会话的备注';

  @override
  String get noteContent => '备注内容';

  @override
  String get noteAdded => '备注已添加';

  @override
  String get noteUpdated => '备注已更新';

  @override
  String get notes => '备注';

  @override
  String get noteInfo => '备注信息';

  @override
  String get noNotes => '暂无备注';

  @override
  String get tapGraphToAddNote => '点击图表以添加备注';

  @override
  String timePoint(int seconds) {
    return '$seconds秒处';
  }

  @override
  String get statistics => '统计';

  @override
  String get duration => '测量时长';

  @override
  String get dataPoints => '数据点';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get korean => '韩语';

  @override
  String get appearance => '外观';

  @override
  String get theme => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeDescription => '请选择您偏好的主题';

  @override
  String get notifications => '通知';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get getAlertsForMeasurements => '接收测量通知';

  @override
  String get hapticFeedback => '触觉反馈';

  @override
  String get vibrateOnKeyActions => '关键操作时振动';

  @override
  String get editTitle => '编辑标题';

  @override
  String get sessionTitle => '会话标题';

  @override
  String get about => '关于';

  @override
  String get appVersion => '应用版本';

  @override
  String get helpAndSupport => '帮助与支持';

  @override
  String get licenses => '许可证';

  @override
  String get liveMonitoring => '实时监测';

  @override
  String get currentPressureLabel => '当前压力';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String minutesSeconds(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String secondsOnly(int seconds) {
    return '$seconds秒';
  }

  @override
  String get tapToExpand => '点击展开';

  @override
  String get measurementHistory => '测量记录';

  @override
  String get filterByDevice => '按设备筛选';

  @override
  String get selectDevice => '选择设备';

  @override
  String get allDevices => '全部设备';

  @override
  String sessionsCount(int count) {
    return '$count条记录';
  }

  @override
  String get deviceSettings => '设备设置';

  @override
  String get deviceName => '设备名称';

  @override
  String get changeDeviceName => '更改设备名称';

  @override
  String get enterNewDeviceName => '输入新设备名称';

  @override
  String get devicePin => '设备 PIN';

  @override
  String get changeDevicePin => '更改 PIN';

  @override
  String get enterCurrentPin => '输入当前 PIN';

  @override
  String get enterNewPin => '输入新 PIN（4位数字）';

  @override
  String get confirmNewPin => '确认新 PIN';

  @override
  String get wrongPin => 'PIN 不正确';

  @override
  String get pinChanged => 'PIN 已更改';

  @override
  String get nameChanged => '设备名称已更改';

  @override
  String get pinMustBe4Digits => 'PIN 必须为4位数字';

  @override
  String get pinsMustMatch => '两次输入的 PIN 不一致';

  @override
  String get nameTooLong => '名称过长（最多中文8个字，英文24个字符）';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get stop => '结束';

  @override
  String get liveSensorData => '实时传感器数据';

  @override
  String get recording => '录制中';

  @override
  String get openSourceLicenses => '开源许可证';

  @override
  String get appDescription => '自由潜水均压训练工具';

  @override
  String get samples => '采样';

  @override
  String get points => '分';

  @override
  String get analyticsComingSoon => '高级分析功能即将推出';

  @override
  String get analytics => '分析';

  @override
  String get pressureWaveform => '压力波形';

  @override
  String get peak => '最大';

  @override
  String get average => '平均';

  @override
  String get sec => '秒';

  @override
  String get deviceConnectedReady => '设备已连接 - 测量准备就绪';

  @override
  String get deviceNotConnectedShort => '设备未连接';

  @override
  String get tapToBeginMonitoring => '点击开始压力监测';

  @override
  String sampleCount(int count) {
    return '$count个采样';
  }

  @override
  String get noNotesYetTapEdit => '暂无备注。点击编辑按钮或在图表中添加备注。';

  @override
  String get madeWithFlutter => '使用 Flutter 构建';

  @override
  String get mitLicense => 'Apache License 2.0';

  @override
  String get mitLicenseContent =>
      '可在包含许可证和 NOTICE 的前提下使用、修改和分发，所有软件均按「原样 (AS IS)」提供，不作任何保证。';

  @override
  String get midiCommunication => 'USB MIDI 通信';

  @override
  String get chartVisualization => '图表可视化';

  @override
  String get sqliteDatabase => 'SQLite 数据库';

  @override
  String get stateManagement => '状态管理';

  @override
  String get localStorage => '本地存储';

  @override
  String get internationalization => '多语言支持';

  @override
  String get copyright => '版权';

  @override
  String get allRightsReserved => '保留所有权利';

  @override
  String get tapToViewFullLicense => '点击查看完整许可证';

  @override
  String get analysis => '分析';

  @override
  String get advancedAnalysis => '高级分析';

  @override
  String get peakAnalysis => '峰值分析';

  @override
  String get peakAnalysisDesc => '峰值检测与均压模式分析';

  @override
  String get statisticsDashboard => '统计面板';

  @override
  String get statisticsDashboardDesc => '查看每日/每周/每月统计';

  @override
  String get segmentAnalysis => '区间分析';

  @override
  String get segmentAnalysisDesc => '特定时间区间分析与比较';

  @override
  String get trendGraph => '趋势图';

  @override
  String get trendGraphDesc => '追踪随时间的进步情况';

  @override
  String get patternRecognition => '模式识别';

  @override
  String get patternRecognitionDesc => '与理想 Frenzel 模式对比';

  @override
  String get comingSoon => '即将推出';

  @override
  String get featureInDevelopment => '此功能正在开发中。';

  @override
  String get noSessionsForAnalysis => '没有可分析的会话';

  @override
  String get selectSession => '选择会话';

  @override
  String get backToMenu => '返回菜单';

  @override
  String get keyMetrics => '关键指标';

  @override
  String get totalPeaks => '总峰值数';

  @override
  String get peaksUnit => '次';

  @override
  String get peakFrequency => '频率';

  @override
  String get perMinute => '次/分钟';

  @override
  String get avgPeakInterval => '平均间隔';

  @override
  String get avgPeakPressure => '平均峰值';

  @override
  String get performanceScores => '性能评分';

  @override
  String get consistencyScore => '一致性评分';

  @override
  String get fatigueIndex => '疲劳指数';

  @override
  String get consistencyExcellent => '非常出色！均压技术非常稳定一致。';

  @override
  String get consistencyGood => '很好。压力和节奏有轻微波动。';

  @override
  String get consistencyFair => '一般。一致性方面还有提升空间。';

  @override
  String get consistencyNeedsWork => '需要改进。请多加练习以提高技术稳定性。';

  @override
  String get fatigueMinimal => '几乎没有疲劳感。出色的耐力！';

  @override
  String get fatigueLow => '轻微疲劳。整体表现维持良好。';

  @override
  String get fatigueModerate => '中等疲劳。建议考虑缩短训练时长。';

  @override
  String get fatigueHigh => '高度疲劳。压力明显下降。';

  @override
  String get detailedStats => '详细统计';

  @override
  String get maxPeakPressure => '最大峰值压力';

  @override
  String get minPeakPressure => '最小峰值压力';

  @override
  String get pressureRange => '压力范围';

  @override
  String get peakVisualization => '峰值可视化';

  @override
  String get detectedPeaks => '检测到的峰值';

  @override
  String get dataManagement => '数据管理';

  @override
  String get backupData => '数据备份';

  @override
  String get backupDataDescription => '将所有数据导出为 JSON 文件';

  @override
  String get restoreData => '数据恢复';

  @override
  String get restoreDataDescription => '从备份文件导入数据';

  @override
  String get backupSuccess => '备份已完成';

  @override
  String get backupFailed => '备份失败';

  @override
  String get restoreSuccess => '恢复已完成';

  @override
  String get restoreFailed => '恢复失败';

  @override
  String get restoreConfirm => '确认恢复';

  @override
  String get restoreConfirmMessage => '所有现有数据将被替换。是否继续？';

  @override
  String get restore => '恢复';

  @override
  String get invalidBackupFile => '无效的备份文件';

  @override
  String dataPointsCount(int count) {
    return '$count个数据点';
  }

  @override
  String get appName => 'DiveChecker';

  @override
  String get appSubtitle => '均压压力监测仪';

  @override
  String get appTitleFull => 'DiveChecker Pro';

  @override
  String get statusOnline => '已连接';

  @override
  String get statusOffline => '未连接';

  @override
  String get statusScanning => '搜索中...';

  @override
  String get statusRecording => '录制中';

  @override
  String get measurementScreenTitle => '压力测量';

  @override
  String get historyScreenTitle => '测量记录';

  @override
  String get settingsScreenTitle => '设置';

  @override
  String get segmentAvgPressureComparison => '各区间平均压力比较';

  @override
  String get segmentDetailedAnalysis => '各区间详细分析';

  @override
  String get segmentChangeAnalysis => '区间变化分析';

  @override
  String segmentNumber(int number) {
    return '区间 $number';
  }

  @override
  String segmentTooltip(int index, String avgPressure, int peakCount) {
    return '区间 $index\\n平均: $avgPressure hPa\\n峰值: $peakCount次';
  }

  @override
  String get avgLabel => '平均';

  @override
  String get maxLabel => '最大';

  @override
  String get peakLabel => '峰值';

  @override
  String get countUnit => '次';

  @override
  String get variabilityLabel => '波动性';

  @override
  String get notEnoughSegments => '区间数量不足';

  @override
  String get stablePressureAnalysis => '压力保持稳定！从始至终展现了一致的表现。';

  @override
  String pressureIncreaseAnalysis(String percent) {
    return '后半段压力上升了 $percent%。可能是热身效果显现或均压力度增加。';
  }

  @override
  String pressureDecreaseAnalysis(String percent) {
    return '后半段压力下降了 $percent%。可能是疲劳累积，建议适当休息。';
  }

  @override
  String get trendStable => '稳定';

  @override
  String get trendRising => '上升趋势';

  @override
  String get trendFalling => '下降趋势';

  @override
  String get firstToLast => '首段 → 末段';

  @override
  String get peakCountChange => '峰值数变化';

  @override
  String get trendRising2 => '上升';

  @override
  String get trendFalling2 => '下降';

  @override
  String get trendMaintained => '保持';

  @override
  String overallTrend(String trend) {
    return '整体趋势：$trend';
  }

  @override
  String slopeLabel(String slope) {
    return '斜率：$slope hPa/秒';
  }

  @override
  String get pressureTrendGraph => '压力趋势图';

  @override
  String get originalData => '原始数据';

  @override
  String get movingAverage => '移动平均';

  @override
  String get trendLine => '趋势线';

  @override
  String get trendAnalysis => '趋势分析';

  @override
  String get startPressureTrend => '起始压力（趋势）';

  @override
  String get endPressureTrend => '结束压力（趋势）';

  @override
  String get changeAmount => '变化量';

  @override
  String get changeRate => '变化率';

  @override
  String get strongRisingTrend => '强烈上升趋势';

  @override
  String get strongRisingDesc => '压力随时间显著增加。可能是肌肉热身后均压能力增强，或正在逐渐加大力度。';

  @override
  String get moderateRisingTrend => '缓慢上升趋势';

  @override
  String get moderateRisingDesc => '压力在缓慢上升。这是良好的热身模式。';

  @override
  String get stableMaintained => '稳定保持';

  @override
  String get stableMaintainedDesc => '压力保持恒定。展现了出色的耐力和一致性！';

  @override
  String get moderateFallingTrend => '缓慢下降趋势';

  @override
  String get moderateFallingDesc => '压力在缓慢下降。可能有轻微疲劳累积，建议适当休息。';

  @override
  String get strongFallingTrend => '明显下降趋势';

  @override
  String get strongFallingDesc => '压力显著下降。疲劳已经累积，需要充分休息。';

  @override
  String get continuousPerformanceAnalysis => '持续表现分析';

  @override
  String get patternComparison => '模式对比';

  @override
  String get peakQualityHeatmap => '峰值质量热力图';

  @override
  String get patternCharacteristics => '模式特征';

  @override
  String get customTrainingSuggestions => '个性化训练建议';

  @override
  String get maxConsecutive => '最大连续';

  @override
  String get avgConsecutive => '平均连续';

  @override
  String get qualityPeaks => '优质峰值';

  @override
  String get excellentConsistency => '出色！长时间保持了一致的质量。请继续保持！';

  @override
  String get goodConsistency => '很好！连续性不错。尝试保持更长的连续记录。';

  @override
  String get moderateConsistency => '中等水平。请集中注意力，提高连续优质峰值数量。';

  @override
  String get needsImprovementConsistency => '连续性需要提升。请更专注于每次均压动作。';

  @override
  String get masterPhase => '大师阶段';

  @override
  String get masterPhaseDesc => '高级技术精进与特殊情况应对';

  @override
  String get masterFocuses => '动态均压,高压情境模拟,持续时间延长';

  @override
  String get advancedPhase => '进阶阶段';

  @override
  String get advancedPhaseDesc => '提升一致性与掌握高级技术';

  @override
  String get advancedFocuses => '压力一致性强化,节奏优化,抗疲劳训练';

  @override
  String get intermediatePhase => '中级阶段';

  @override
  String get intermediatePhaseDesc => '基本功巩固与质量提升';

  @override
  String get intermediateFocuses => '精准控制节奏,寻找适当压力,反复练习';

  @override
  String get basicPhase => '基础阶段';

  @override
  String get basicPhaseDesc => '基本动作学习与感觉培养';

  @override
  String get basicFocuses => '基本姿势,呼吸控制,低压练习';

  @override
  String get currentFocusAreas => '当前需要关注的领域：';

  @override
  String peakScore(int index, String score) {
    return '峰值 $index：$score分';
  }

  @override
  String get rhythmImprovementTraining => '节奏改善训练';

  @override
  String get rhythmTip1 => '使用节拍器应用，按照固定节拍进行练习';

  @override
  String get rhythmTip2 => '数数练习：按 1-2-3-4 的节奏进行均压';

  @override
  String get rhythmTip3 => '从慢速开始，逐渐提高速度';

  @override
  String get pressureConsistencyTraining => '压力一致性训练';

  @override
  String get pressureTip1 => '以相同力度连续完成10次均压为目标';

  @override
  String get pressureTip2 => '对着镜子保持面颊和舌头动作的一致性';

  @override
  String get pressureTip3 => '不要过于用力，找到舒适的压力';

  @override
  String get frequencyOptimizationTraining => '频率优化训练';

  @override
  String get frequencyTip1 => '理想频率为每分钟20-40次';

  @override
  String get frequencyTip2 => '确保每次均压都充分到位';

  @override
  String get frequencyTip3 => '避免不必要的快速均压';

  @override
  String get enduranceTraining => '耐力提升训练';

  @override
  String get enduranceTip1 => '逐步延长练习时间';

  @override
  String get enduranceTip2 => '合理分配休息和训练时间';

  @override
  String get enduranceTip3 => '规律练习是提升耐力的关键';

  @override
  String get irregularIntervalSuggestion => '均压间隔不规律。请尝试以稳定的节奏进行练习。';

  @override
  String get irregularPressureSuggestion => '峰值压力不规律。需要练习以一致的力度进行均压。';

  @override
  String get lowFrequencySuggestion => '均压频率偏低。请尝试更频繁地进行均压练习。';

  @override
  String get highFrequencySuggestion => '均压过于频繁。请更专注于每次均压的质量。';

  @override
  String get fatigueDetectedSuggestion => '后半段压力逐渐下降。耐力训练可能会有帮助。';

  @override
  String get excellentPattern => '优秀';

  @override
  String get excellentPatternDesc => '非常接近理想的 Frenzel 模式！';

  @override
  String get minPressureLabel => '最小压力';

  @override
  String get goodPattern => '良好';

  @override
  String get goodPatternDesc => '具备良好的基本功。有一些可以改进的地方。';

  @override
  String get averagePattern => '一般';

  @override
  String get averagePatternDesc => '基本模式已形成，但仍需改进。';

  @override
  String get needsPractice => '需要练习';

  @override
  String get needsPracticeDesc => '需要更多练习。请参考以下建议。';

  @override
  String get excellentPatternKeepUp => '当前模式非常好！请继续保持。';

  @override
  String patternGrade(String grade) {
    return '模式等级：$grade';
  }

  @override
  String get rhythmLabel => '节奏';

  @override
  String get pressureLabel => '压力';

  @override
  String get frequencyLabel => '频率';

  @override
  String get enduranceLabel => '耐力';

  @override
  String get currentPattern => '当前模式';

  @override
  String get idealPattern => '理想模式';

  @override
  String get peakNumber => '峰值编号';

  @override
  String get rhythmConsistency => '节奏一致性';

  @override
  String get pressureConsistency => '压力一致性';

  @override
  String get frequencyAdequacy => '频率适当性';

  @override
  String get veryGood => '非常好';

  @override
  String get good => '好';

  @override
  String get needsImprovement => '需要改进';

  @override
  String get needsMorePractice => '需要大量练习';

  @override
  String get noPeaksDetected => '未检测到峰值';

  @override
  String get selectAll => '全选';

  @override
  String get deselectAll => '取消';

  @override
  String get avgRiseTime => '平均上升时间';

  @override
  String get avgFallTime => '平均下降时间';

  @override
  String get avgPeakWidth => '平均峰值宽度';

  @override
  String get outliers => '异常值';

  @override
  String get peakIntensityDistribution => '峰值强度分布';

  @override
  String get rhythmScore => '节奏评分';

  @override
  String get pressureScoreTitle => '压力评分';

  @override
  String get techniqueScore => '技术评分';

  @override
  String get fatigueResistance => '抗疲劳性';

  @override
  String get strongPeaks => '强峰值';

  @override
  String get moderatePeaks => '中等峰值';

  @override
  String get weakPeaks => '弱峰值';

  @override
  String countWithPercent(int count, String percent) {
    return '$count个（$percent%）';
  }

  @override
  String get overallGrade => '综合等级';

  @override
  String get excellentFrenzel => '卓越的 Frenzel 技术！';

  @override
  String get veryGoodTechnique => '非常好的技术';

  @override
  String get satisfactoryLevel => '良好水平';

  @override
  String get roomForImprovement => '还有提升空间';

  @override
  String get moreTrainingNeeded => '需要更多练习';

  @override
  String get startFromBasics => '请从基础开始练习';

  @override
  String get weak => '弱';

  @override
  String get moderate => '中等';

  @override
  String get strong => '强';

  @override
  String get weakIntensity => '弱（<50hPa）';

  @override
  String get moderateIntensity => '中等（50-100）';

  @override
  String get strongIntensity => '强（>100）';

  @override
  String get stabilityImproving => '稳定性提升中';

  @override
  String get stabilityDecreasing => '稳定性下降中';

  @override
  String get stabilityMaintained => '稳定保持';

  @override
  String get stabilityTrend => '稳定性趋势';

  @override
  String get pressureDistribution => '压力分布';

  @override
  String get basicStats => '基本统计';

  @override
  String get dataPointsLabel => '数据点';

  @override
  String get countUnitItems => '个';

  @override
  String get measurementTime => '测量时间';

  @override
  String get standardDeviation => '标准差';

  @override
  String get advancedStats => '高级统计';

  @override
  String get coefficientOfVariation => '变异系数';

  @override
  String get skewness => '偏度';

  @override
  String get kurtosis => '峰度';

  @override
  String get interquartileRange => '四分位距';

  @override
  String get dataDispersionIndicator => '数据离散度指标';

  @override
  String get pressureRangeLabel => '压力范围';

  @override
  String get rangeLabel => '范围';

  @override
  String outlierCount(int count, String percent) {
    return '$count个（$percent%）';
  }

  @override
  String get percentiles => '百分位数';

  @override
  String get median50 => '中位数（50%）';

  @override
  String get peakSummary => '峰值摘要';

  @override
  String get strongPeakRatio => '强峰值比例';

  @override
  String get dataQuality => '数据质量';

  @override
  String get outliersLabel => '异常值';

  @override
  String get samplingLabel => '采样';

  @override
  String get dataLabel => '数据';

  @override
  String get veryConsistent => '非常一致';

  @override
  String get consistent => '一致';

  @override
  String get averageVariation => '一般';

  @override
  String get highVariation => '波动较大';

  @override
  String get leftSkewed => '左偏分布';

  @override
  String get rightSkewed => '右偏分布';

  @override
  String get normalDistribution => '正态分布';

  @override
  String get excellent => '优秀';

  @override
  String get satisfactory => '良好';

  @override
  String get caution => '注意';

  @override
  String get symmetricDistribution => '对称分布';

  @override
  String get flatDistribution => '平坦分布';

  @override
  String get peakedDistribution => '尖峰分布';

  @override
  String get normalPressureInterpretation => '压力分布正常。Frenzel 动作执行一致。';

  @override
  String get highPressureInterpretation => '高压力值出现频繁。峰值时可能需要控制力度。';

  @override
  String get lowPressureInterpretation => '低压力值较多。需要练习施加更大的压力。';

  @override
  String get concentratedInterpretation => '集中在特定压力区间。展现了良好的一致性。';

  @override
  String get dispersedInterpretation => '压力分布较为分散。需要提高一致性。';

  @override
  String medianLabel(String value) {
    return '中位数：$value hPa';
  }

  @override
  String get selected => '已选择';

  @override
  String get excluded => '已排除';

  @override
  String keyMetricsWithPeaks(String metrics, int count) {
    return '$metrics（基于 $count 个峰值）';
  }

  @override
  String scorePoints(String score) {
    return '$score分';
  }

  @override
  String secondsValue(String value) {
    return '$value秒';
  }

  @override
  String histogramTooltip(String rangeStart, String rangeEnd, int count) {
    return '$rangeStart-$rangeEnd hPa\n$count个';
  }

  @override
  String get selectUsbDevice => '选择 USB 设备';

  @override
  String get rescan => '重新搜索';

  @override
  String get availableDevices => '可用设备';

  @override
  String get noDevicesFound => '未找到 USB MIDI 设备';

  @override
  String get connecting => '连接中...';

  @override
  String get connectionError => '连接错误';

  @override
  String get scanningForDevices => '正在搜索 USB 设备...';

  @override
  String get scanAgain => '重新搜索';

  @override
  String get deviceConnectedSuccessfully => '设备连接成功！';

  @override
  String get clearData => '清除数据';

  @override
  String get deleteAllMeasurementData => '删除所有测量数据';

  @override
  String get exportDbToFile => '导出数据库文件';

  @override
  String get exportDatabaseForDebugging => '导出数据库用于调试';

  @override
  String get deviceAuthenticated => '已通过正品认证';

  @override
  String get deviceNotAuthenticated => '认证失败';

  @override
  String get counterfeitWarning => '无法验证正品';

  @override
  String get counterfeitWarningTitle => '正品认证失败';

  @override
  String get counterfeitWarningMessage =>
      '连接的设备未通过 DiveChecker 正品认证。\n\n使用仿制品可能导致测量值不准确，技术支持也将受到限制。';

  @override
  String get continueAnyway => '继续使用';

  @override
  String get verifyingDevice => '正在验证设备...';

  @override
  String get firmwareUpdate => '固件更新';

  @override
  String get firmwareUpdateDescription => '检查并更新设备固件';

  @override
  String get firmwareVerificationSuccess => '签名验证成功';

  @override
  String get firmwareVerificationFailed => '签名验证失败';

  @override
  String get firmwareInstall => '安装';

  @override
  String get firmwareRebootToBootsel => '重启至 BOOTSEL 模式';

  @override
  String get firmwareRebootDescription =>
      '设备将重启至 BOOTSEL 模式。\n\n重启后：\n1. 将出现 \"RPI-RP2\" 驱动器\n2. 请将 .uf2 固件文件复制到该驱动器\n3. 设备将自动重启';

  @override
  String get currentFirmware => '当前固件';

  @override
  String get dangerZone => '危险区域';

  @override
  String get rebootDevice => '重启设备';

  @override
  String get rebootDeviceDescription => '重启设备';

  @override
  String get rebootConfirmMessage => '确定要重启设备吗？连接将断开。';

  @override
  String get reboot => '重启';

  @override
  String get bootselMode => 'BOOTSEL 模式';

  @override
  String get bootselModeDescription => '手动固件更新模式';

  @override
  String get bootselRebootSent => '已发送 BOOTSEL 重启命令';

  @override
  String get deviceDisconnected => '设备已断开连接';

  @override
  String get pleaseReconnectDevice => '请重新连接设备。';

  @override
  String get connectionLostDuringMeasurement => '测量过程中连接已断开。是否保存已记录的数据？';

  @override
  String get pinMismatch => 'PIN 不一致';

  @override
  String get pinChangeRequested => '已请求更改 PIN';

  @override
  String get nameChangeRequested => '已请求更改名称';

  @override
  String get currentPin => '当前 PIN';

  @override
  String get newPin => '新 PIN';

  @override
  String get confirmPin => '确认 PIN';

  @override
  String get newDeviceName => '新设备名称';

  @override
  String get pinRequiredForChange => '更改设置需要输入 PIN';

  @override
  String get change => '更改';

  @override
  String get myDevices => '我的设备';

  @override
  String get connectedDevices => '已连接的设备';

  @override
  String get noDeviceConnected => '暂无连接的设备';

  @override
  String get displayResolution => '画面刷新率';

  @override
  String get displayResolutionDescription => '图表画面刷新速度';

  @override
  String get outputRate => '输出频率';

  @override
  String get outputRateDescription => '传感器输出频率';

  @override
  String get tapToChange => '点击更改';

  @override
  String get connectDeviceFirst => '请先连接设备';

  @override
  String outputRateChanged(Object rate) {
    return '输出频率已更改为 $rate Hz';
  }

  @override
  String get noiseFilter => '噪声滤波器';

  @override
  String get noiseFilterDescription => '用于降噪的软件滤波器';

  @override
  String get filterStrength => '滤波强度';

  @override
  String get filterStrengthDescription => '数值越高显示越平滑';

  @override
  String get atmosphericCalibrating => '正在测量大气压...';

  @override
  String get atmosphericRecalibrate => '重新测量大气压';

  @override
  String get atmosphericKeepSensorStill => '请将传感器静置于空气中';

  @override
  String secondsRemaining(int seconds) {
    return '剩余 $seconds 秒';
  }

  @override
  String get selectFile => '选择文件';

  @override
  String get backToFileList => '返回文件列表';

  @override
  String get readyToInstall => '准备安装';

  @override
  String get verificationFailed => '验证失败';

  @override
  String get reset => '重置';

  @override
  String get fullscreen => '全屏';

  @override
  String get waitingForData => '等待数据中...';

  @override
  String get overrangeWarningTitle => '超出测量范围！';

  @override
  String get overrangeWarningMessage => '已超出传感器测量范围。请不要过度吹气或吸气！传感器正在恢复中...';

  @override
  String get usbMidiDevicesTitle => 'USB MIDI 设备';

  @override
  String get connectViaCable => '请使用 USB 数据线连接压力传感器';

  @override
  String get noUsbDevicesFound => '未找到 USB 设备';

  @override
  String get connectDeviceViaCable => '请使用 USB 数据线连接设备';

  @override
  String get diveCheckerCompatible => 'DiveChecker 兼容';

  @override
  String scanFailedError(String error) {
    return '搜索失败：$error';
  }

  @override
  String connectionErrorWithMessage(String error) {
    return '连接错误：$error';
  }

  @override
  String get noFirmwareFilesFound => '未找到固件文件';

  @override
  String get lookingForFirmwareFiles => '正在查找 *.bin 或 *_signed.bin 文件';

  @override
  String get deviceNotConnectedError => '设备未连接';

  @override
  String get signatureValid => '签名已验证 ✓';

  @override
  String get signatureInvalid => '签名验证失败 ✗';

  @override
  String get firmwareUntrustedWarning => '此固件未使用有效密钥签名。可能已损坏或来自不可信来源。';

  @override
  String verifiedFirmwareSaved(String filename) {
    return '已保存已验证的固件：$filename';
  }

  @override
  String get calibrationTimedOut => '校准超时 - 传感器数据不足';

  @override
  String get loading => '加载中...';

  @override
  String failedToSaveSession(String error) {
    return '会话保存失败：$error';
  }

  @override
  String failedToDeleteSession(String error) {
    return '会话删除失败：$error';
  }

  @override
  String failedToLoadSessionData(String error) {
    return '会话数据加载失败：$error';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'DiveChecker';

  @override
  String get disclaimerTitle => '重要提醒';

  @override
  String get disclaimerContent =>
      'DiveChecker 僅供自由潛水均壓訓練參考使用。\n\n⚠️ 本應用程式並非醫療器材，不可用於醫療診斷或治療目的。\n\n⚠️ 潛水時請始終將安全放在第一位。請勿僅依賴本應用程式做出潛水決策。\n\n⚠️ 開發者對使用本應用程式期間可能發生的任何事故、傷害或損失概不負責。\n\n使用本應用程式即視為同意上述條款。';

  @override
  String get disclaimerAgree => '我已了解並同意';

  @override
  String get disclaimerDoNotShowAgain => '不再顯示';

  @override
  String get home => '首頁';

  @override
  String get monitor => '監測';

  @override
  String get measurement => '量測';

  @override
  String get history => '紀錄';

  @override
  String get deviceConnected => '主機已連線';

  @override
  String get deviceNotConnected => '未連線';

  @override
  String get deviceDiscovery => '裝置搜尋';

  @override
  String get searchingDevice => '正在搜尋 Divechecker 主機...';

  @override
  String get measurementReady => '量測準備就緒';

  @override
  String get tapToConnect => '請點擊連線按鈕開始';

  @override
  String get connectDevice => '連線';

  @override
  String get disconnect => '中斷連線';

  @override
  String get searching => '搜尋中...';

  @override
  String get makeSureDevicePowered => '請確認 Divechecker 主機已開啟';

  @override
  String get sensorError => '感測器連線錯誤';

  @override
  String get sensorErrorDescription => '未偵測到量測感測器，請檢查連線狀態。';

  @override
  String get connectionRequired => '需要連線';

  @override
  String get connectionRequiredMessage =>
      '請先連接 Divechecker 主機才能開始量測。\n\n您可以在首頁分頁連接裝置。';

  @override
  String get goToHome => '前往首頁';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get ok => '確定';

  @override
  String get close => '關閉';

  @override
  String get add => '新增';

  @override
  String get peakAnalysisDisclaimer => '本分析僅供參考，並非完全精確。請謹慎解讀結果。';

  @override
  String get connectedSuccess => 'Divechecker 主機連線成功！';

  @override
  String get disconnected => 'Divechecker 主機已中斷連線';

  @override
  String get unsupportedDevice => '不支援的裝置';

  @override
  String get onlyDiveCheckerSupported => '僅支援 DiveChecker 裝置。此裝置無法在本應用程式中使用。';

  @override
  String get startMeasurement => '開始量測';

  @override
  String get stopMeasurement => '結束量測';

  @override
  String get pauseMeasurement => '暫停';

  @override
  String get resumeMeasurement => '繼續';

  @override
  String get measurementStarted => '量測已開始';

  @override
  String get measurementPaused => '量測已暫停';

  @override
  String get measurementResumed => '量測已繼續';

  @override
  String get measurementComplete => '量測完成';

  @override
  String get measurementSaved => '量測已儲存';

  @override
  String get measurementSettings => '量測設定';

  @override
  String measurementNumber(int number) {
    return '量測 #$number';
  }

  @override
  String get currentPressure => '目前';

  @override
  String get maxPressure => '最大';

  @override
  String get avgPressure => '平均';

  @override
  String get elapsedTime => '時間';

  @override
  String get pressureUnit => '壓力單位';

  @override
  String get sampleRate => '取樣率';

  @override
  String get msInterval => 'ms 間隔';

  @override
  String get maxPressureLabel => '最大壓力';

  @override
  String get avgPressureLabel => '平均壓力';

  @override
  String get durationLabel => '量測時間';

  @override
  String get pressureAnalysis => '壓力分析';

  @override
  String get saveSession => '儲存紀錄';

  @override
  String get saveSessionQuestion => '是否儲存此量測紀錄？';

  @override
  String get save => '儲存';

  @override
  String get discard => '捨棄';

  @override
  String get sessionSaved => '紀錄已儲存';

  @override
  String get sessionDiscarded => '紀錄已捨棄';

  @override
  String get noData => '無資料';

  @override
  String get awaitingData => '等待量測資料中';

  @override
  String get noMeasurements => '尚無量測紀錄';

  @override
  String get startMeasuringHint => '請至量測分頁開始第一次量測';

  @override
  String get sessionHistory => '歷史紀錄';

  @override
  String get noSessions => '尚無紀錄';

  @override
  String get startMeasuringToSee => '開始量測後，紀錄將顯示在此處';

  @override
  String get deleteSession => '刪除紀錄';

  @override
  String get deleteSessionConfirm => '是否刪除此紀錄？';

  @override
  String get delete => '刪除';

  @override
  String get sessionDeleted => '紀錄已刪除';

  @override
  String get deleteRecord => '刪除記錄';

  @override
  String get deleteRecordConfirm => '是否刪除此量測記錄？';

  @override
  String get recordDeleted => '記錄已刪除';

  @override
  String get graphDetails => '圖表詳情';

  @override
  String get zoomIn => '放大';

  @override
  String get zoomOut => '縮小';

  @override
  String get resetZoom => '重設';

  @override
  String get panLeft => '向左';

  @override
  String get panRight => '向右';

  @override
  String get addNote => '新增備註';

  @override
  String get editNote => '編輯備註';

  @override
  String get noteOptional => '備註（選填）';

  @override
  String get noteHint => '請輸入此紀錄的備註';

  @override
  String get noteContent => '備註內容';

  @override
  String get noteAdded => '備註已新增';

  @override
  String get noteUpdated => '備註已更新';

  @override
  String get notes => '備註';

  @override
  String get noteInfo => '備註資訊';

  @override
  String get noNotes => '無備註';

  @override
  String get tapGraphToAddNote => '點擊圖表以新增備註';

  @override
  String timePoint(int seconds) {
    return '$seconds秒處';
  }

  @override
  String get statistics => '統計';

  @override
  String get duration => '量測時間';

  @override
  String get dataPoints => '資料點';

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get english => '英文';

  @override
  String get korean => '韓文';

  @override
  String get appearance => '外觀';

  @override
  String get theme => '主題';

  @override
  String get themeSystem => '系統設定';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get themeDescription => '請選擇您偏好的主題';

  @override
  String get notifications => '通知';

  @override
  String get enableNotifications => '啟用通知';

  @override
  String get getAlertsForMeasurements => '接收量測通知';

  @override
  String get hapticFeedback => '觸覺回饋';

  @override
  String get vibrateOnKeyActions => '重要操作時震動';

  @override
  String get editTitle => '編輯標題';

  @override
  String get sessionTitle => '紀錄標題';

  @override
  String get about => '關於';

  @override
  String get appVersion => '應用程式版本';

  @override
  String get helpAndSupport => '說明與支援';

  @override
  String get licenses => '授權條款';

  @override
  String get liveMonitoring => '即時監測';

  @override
  String get currentPressureLabel => '目前壓力';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String minutesSeconds(int minutes, int seconds) {
    return '$minutes分 $seconds秒';
  }

  @override
  String secondsOnly(int seconds) {
    return '$seconds秒';
  }

  @override
  String get tapToExpand => '點擊以放大';

  @override
  String get measurementHistory => '量測紀錄';

  @override
  String get filterByDevice => '依裝置篩選';

  @override
  String get selectDevice => '選擇裝置';

  @override
  String get allDevices => '所有裝置';

  @override
  String sessionsCount(int count) {
    return '$count 筆紀錄';
  }

  @override
  String get deviceSettings => '裝置設定';

  @override
  String get deviceName => '裝置名稱';

  @override
  String get changeDeviceName => '變更裝置名稱';

  @override
  String get enterNewDeviceName => '輸入新裝置名稱';

  @override
  String get devicePin => '裝置 PIN';

  @override
  String get changeDevicePin => '變更 PIN';

  @override
  String get enterCurrentPin => '輸入目前 PIN';

  @override
  String get enterNewPin => '輸入新 PIN（4 位數）';

  @override
  String get confirmNewPin => '確認新 PIN';

  @override
  String get wrongPin => 'PIN 錯誤';

  @override
  String get pinChanged => 'PIN 已變更';

  @override
  String get nameChanged => '裝置名稱已變更';

  @override
  String get pinMustBe4Digits => 'PIN 須為 4 位數字';

  @override
  String get pinsMustMatch => 'PIN 不一致';

  @override
  String get nameTooLong => '名稱過長（最多中文 8 字、英文 24 字）';

  @override
  String get pause => '暫停';

  @override
  String get resume => '繼續';

  @override
  String get stop => '結束';

  @override
  String get liveSensorData => '即時感測器資料';

  @override
  String get recording => '錄製中';

  @override
  String get openSourceLicenses => '開源授權條款';

  @override
  String get appDescription => '自由潛水均壓工具';

  @override
  String get samples => '樣本';

  @override
  String get points => '分';

  @override
  String get analyticsComingSoon => '進階分析功能即將推出';

  @override
  String get analytics => '分析';

  @override
  String get pressureWaveform => '壓力波形';

  @override
  String get peak => '最大';

  @override
  String get average => '普通';

  @override
  String get sec => '秒';

  @override
  String get deviceConnectedReady => '裝置已連線 - 量測準備就緒';

  @override
  String get deviceNotConnectedShort => '裝置未連線';

  @override
  String get tapToBeginMonitoring => '點擊以開始壓力監測';

  @override
  String sampleCount(int count) {
    return '$count 個樣本';
  }

  @override
  String get noNotesYetTapEdit => '尚無備註。請點擊編輯按鈕或在圖表上新增備註。';

  @override
  String get madeWithFlutter => '以 Flutter 打造';

  @override
  String get mitLicense => 'Apache 授權條款 2.0';

  @override
  String get mitLicenseContent =>
      '可在包含授權條款與 NOTICE 的情況下使用、修改及散布，所有軟體均以「現狀（AS IS）」提供，不附帶任何擔保。';

  @override
  String get midiCommunication => 'USB MIDI 通訊';

  @override
  String get chartVisualization => '圖表視覺化';

  @override
  String get sqliteDatabase => 'SQLite 資料庫';

  @override
  String get stateManagement => '狀態管理';

  @override
  String get localStorage => '本機儲存';

  @override
  String get internationalization => '多語系支援';

  @override
  String get copyright => '版權';

  @override
  String get allRightsReserved => '保留所有權利';

  @override
  String get tapToViewFullLicense => '點擊以檢視完整授權條款';

  @override
  String get analysis => '分析';

  @override
  String get advancedAnalysis => '進階分析';

  @override
  String get peakAnalysis => '峰值分析';

  @override
  String get peakAnalysisDesc => '峰值偵測與均壓模式分析';

  @override
  String get statisticsDashboard => '統計儀表板';

  @override
  String get statisticsDashboardDesc => '檢視每日/每週/每月統計';

  @override
  String get segmentAnalysis => '區段分析';

  @override
  String get segmentAnalysisDesc => '特定時間區段分析與比較';

  @override
  String get trendGraph => '趨勢圖表';

  @override
  String get trendGraphDesc => '追蹤隨時間的進步狀況';

  @override
  String get patternRecognition => '模式辨識';

  @override
  String get patternRecognitionDesc => '與理想 Frenzel 模式比較';

  @override
  String get comingSoon => '即將推出';

  @override
  String get featureInDevelopment => '此功能目前正在開發中。';

  @override
  String get noSessionsForAnalysis => '無可分析的紀錄';

  @override
  String get selectSession => '選擇紀錄';

  @override
  String get backToMenu => '返回選單';

  @override
  String get keyMetrics => '關鍵指標';

  @override
  String get totalPeaks => '總峰值數';

  @override
  String get peaksUnit => '次';

  @override
  String get peakFrequency => '頻率';

  @override
  String get perMinute => '次/分';

  @override
  String get avgPeakInterval => '平均間隔';

  @override
  String get avgPeakPressure => '平均峰值';

  @override
  String get performanceScores => '表現評分';

  @override
  String get consistencyScore => '一致性評分';

  @override
  String get fatigueIndex => '疲勞指數';

  @override
  String get consistencyExcellent => '非常出色！展現極為一致的均壓技巧。';

  @override
  String get consistencyGood => '表現良好。壓力和節奏有些微變動。';

  @override
  String get consistencyFair => '表現普通。一致性仍有提升空間。';

  @override
  String get consistencyNeedsWork => '需要改進。請多加練習以獲得更一致的技巧。';

  @override
  String get fatigueMinimal => '幾乎沒有疲勞。出色的耐力！';

  @override
  String get fatigueLow => '低度疲勞。表現維持良好。';

  @override
  String get fatigueModerate => '中度疲勞。建議考慮縮短練習時間。';

  @override
  String get fatigueHigh => '高度疲勞。壓力明顯下降。';

  @override
  String get detailedStats => '詳細統計';

  @override
  String get maxPeakPressure => '最大峰值壓力';

  @override
  String get minPeakPressure => '最小峰值壓力';

  @override
  String get pressureRange => '壓力範圍';

  @override
  String get peakVisualization => '峰值視覺化';

  @override
  String get detectedPeaks => '偵測到的峰值';

  @override
  String get dataManagement => '資料管理';

  @override
  String get backupData => '備份資料';

  @override
  String get backupDataDescription => '將所有資料匯出為 JSON 檔案';

  @override
  String get restoreData => '還原資料';

  @override
  String get restoreDataDescription => '從備份檔案匯入資料';

  @override
  String get backupSuccess => '備份已完成';

  @override
  String get backupFailed => '備份失敗';

  @override
  String get restoreSuccess => '還原已完成';

  @override
  String get restoreFailed => '還原失敗';

  @override
  String get restoreConfirm => '確認還原';

  @override
  String get restoreConfirmMessage => '所有現有資料將被取代。是否繼續？';

  @override
  String get restore => '還原';

  @override
  String get invalidBackupFile => '無效的備份檔案';

  @override
  String dataPointsCount(int count) {
    return '$count 個資料點';
  }

  @override
  String get appName => 'DiveChecker';

  @override
  String get appSubtitle => '均壓壓力監測器';

  @override
  String get appTitleFull => 'DiveChecker Pro';

  @override
  String get statusOnline => '已連線';

  @override
  String get statusOffline => '未連線';

  @override
  String get statusScanning => '搜尋中...';

  @override
  String get statusRecording => '錄製中';

  @override
  String get measurementScreenTitle => '壓力量測';

  @override
  String get historyScreenTitle => '量測紀錄';

  @override
  String get settingsScreenTitle => '設定';

  @override
  String get segmentAvgPressureComparison => '各區段平均壓力比較';

  @override
  String get segmentDetailedAnalysis => '各區段詳細分析';

  @override
  String get segmentChangeAnalysis => '區段變化分析';

  @override
  String segmentNumber(int number) {
    return '區段 $number';
  }

  @override
  String segmentTooltip(int index, String avgPressure, int peakCount) {
    return '區段 $index\\n平均：$avgPressure hPa\\n峰值：$peakCount次';
  }

  @override
  String get avgLabel => '平均';

  @override
  String get maxLabel => '最大';

  @override
  String get peakLabel => '峰值';

  @override
  String get countUnit => '次';

  @override
  String get variabilityLabel => '變異性';

  @override
  String get notEnoughSegments => '區段數不足';

  @override
  String get stablePressureAnalysis => '壓力維持穩定！從頭到尾展現一致的表現。';

  @override
  String pressureIncreaseAnalysis(String percent) {
    return '後半段壓力增加了 $percent%。可能是暖身效果顯現，或是施加了更大力量進行均壓。';
  }

  @override
  String pressureDecreaseAnalysis(String percent) {
    return '後半段壓力下降了 $percent%。可能出現疲勞累積，建議考慮休息。';
  }

  @override
  String get trendStable => '穩定';

  @override
  String get trendRising => '上升趨勢';

  @override
  String get trendFalling => '下降趨勢';

  @override
  String get firstToLast => '起始 → 結束';

  @override
  String get peakCountChange => '峰值數變化';

  @override
  String get trendRising2 => '上升';

  @override
  String get trendFalling2 => '下降';

  @override
  String get trendMaintained => '維持';

  @override
  String overallTrend(String trend) {
    return '整體趨勢：$trend';
  }

  @override
  String slopeLabel(String slope) {
    return '斜率：$slope hPa/秒';
  }

  @override
  String get pressureTrendGraph => '壓力趨勢圖表';

  @override
  String get originalData => '原始資料';

  @override
  String get movingAverage => '移動平均';

  @override
  String get trendLine => '趨勢線';

  @override
  String get trendAnalysis => '趨勢分析';

  @override
  String get startPressureTrend => '起始壓力（趨勢）';

  @override
  String get endPressureTrend => '結束壓力（趨勢）';

  @override
  String get changeAmount => '變化量';

  @override
  String get changeRate => '變化率';

  @override
  String get strongRisingTrend => '強烈上升趨勢';

  @override
  String get strongRisingDesc => '壓力隨時間明顯增加。可能是肌肉已暖身而能進行更強的均壓，或者正逐漸加大力量。';

  @override
  String get moderateRisingTrend => '緩和上升趨勢';

  @override
  String get moderateRisingDesc => '壓力正緩慢上升。這是良好的暖身模式。';

  @override
  String get stableMaintained => '穩定維持';

  @override
  String get stableMaintainedDesc => '壓力維持穩定。展現出色的耐力與一致性！';

  @override
  String get moderateFallingTrend => '緩和下降趨勢';

  @override
  String get moderateFallingDesc => '壓力正緩慢下降。可能有些許疲勞累積，建議考慮休息。';

  @override
  String get strongFallingTrend => '強烈下降趨勢';

  @override
  String get strongFallingDesc => '壓力明顯下降。疲勞已經累積，需要充分休息。';

  @override
  String get continuousPerformanceAnalysis => '連續表現分析';

  @override
  String get patternComparison => '模式比較';

  @override
  String get peakQualityHeatmap => '峰值品質熱圖';

  @override
  String get patternCharacteristics => '模式特徵';

  @override
  String get customTrainingSuggestions => '客製化訓練建議';

  @override
  String get maxConsecutive => '最大連續';

  @override
  String get avgConsecutive => '平均連續';

  @override
  String get qualityPeaks => '優質峰值';

  @override
  String get excellentConsistency => '卓越！長時間維持一致的品質。請保持目前的水準。';

  @override
  String get goodConsistency => '良好！連續性佳。試著以更長的連續維持為目標。';

  @override
  String get moderateConsistency => '中等水準。保持專注以增加連續優質峰值。';

  @override
  String get needsImprovementConsistency => '連續性需要提升。請在每次均壓時更加專注。';

  @override
  String get masterPhase => '大師階段';

  @override
  String get masterPhaseDesc => '精進高階技巧與特殊情境應對';

  @override
  String get masterFocuses => '動態均壓,高壓情境模擬,持續時間延長';

  @override
  String get advancedPhase => '進階階段';

  @override
  String get advancedPhaseDesc => '提升一致性與習得進階技巧';

  @override
  String get advancedFocuses => '壓力一致性強化,節奏最佳化,抗疲勞訓練';

  @override
  String get intermediatePhase => '中級階段';

  @override
  String get intermediatePhaseDesc => '穩固基本功與提升品質';

  @override
  String get intermediateFocuses => '精準計時,找到適當壓力,反覆練習';

  @override
  String get basicPhase => '基礎階段';

  @override
  String get basicPhaseDesc => '學習基本動作與開發感覺';

  @override
  String get basicFocuses => '基本姿勢,呼吸控制,低壓力練習';

  @override
  String get currentFocusAreas => '目前應專注的領域：';

  @override
  String peakScore(int index, String score) {
    return '峰值 $index：$score分';
  }

  @override
  String get rhythmImprovementTraining => '節奏改善訓練';

  @override
  String get rhythmTip1 => '使用節拍器應用程式，配合固定節拍練習';

  @override
  String get rhythmTip2 => '數數計時：以 1-2-3-4 的節奏進行均壓';

  @override
  String get rhythmTip3 => '從慢速開始，逐漸加快速度';

  @override
  String get pressureConsistencyTraining => '壓力一致性訓練';

  @override
  String get pressureTip1 => '以相同力道連續進行 10 次均壓為目標';

  @override
  String get pressureTip2 => '對著鏡子練習，保持臉頰和舌頭動作一致';

  @override
  String get pressureTip3 => '不要用力過猛，找到舒適的壓力';

  @override
  String get frequencyOptimizationTraining => '頻率最佳化訓練';

  @override
  String get frequencyTip1 => '理想頻率為每分鐘 20-40 次';

  @override
  String get frequencyTip2 => '每次都進行充分的均壓';

  @override
  String get frequencyTip3 => '避免不必要的過快均壓';

  @override
  String get enduranceTraining => '耐力提升訓練';

  @override
  String get enduranceTip1 => '逐步增加練習時間';

  @override
  String get enduranceTip2 => '均衡分配休息與訓練';

  @override
  String get enduranceTip3 => '規律練習是提升耐力的關鍵';

  @override
  String get irregularIntervalSuggestion => '均壓的間隔不規律。請嘗試以固定節奏練習。';

  @override
  String get irregularPressureSuggestion => '峰值壓力不規律。需要練習以穩定的力道進行均壓。';

  @override
  String get lowFrequencySuggestion => '均壓頻率偏低。請嘗試更頻繁地進行均壓。';

  @override
  String get highFrequencySuggestion => '均壓過於頻繁。請更專注於每次均壓。';

  @override
  String get fatigueDetectedSuggestion => '後半段壓力呈下降趨勢。耐力提升訓練可能會有幫助。';

  @override
  String get excellentPattern => '優秀';

  @override
  String get excellentPatternDesc => '接近理想的 Frenzel 模式！';

  @override
  String get minPressureLabel => '最小壓力';

  @override
  String get goodPattern => '良好';

  @override
  String get goodPatternDesc => '具備良好的基本功。有幾點可以改進。';

  @override
  String get averagePattern => '普通';

  @override
  String get averagePatternDesc => '基本模式已形成，但仍需改善。';

  @override
  String get needsPractice => '需要練習';

  @override
  String get needsPracticeDesc => '需要更多練習。請參考以下建議。';

  @override
  String get excellentPatternKeepUp => '目前的模式非常好！請持續保持。';

  @override
  String patternGrade(String grade) {
    return '模式等級：$grade';
  }

  @override
  String get rhythmLabel => '節奏';

  @override
  String get pressureLabel => '壓力';

  @override
  String get frequencyLabel => '頻率';

  @override
  String get enduranceLabel => '耐力';

  @override
  String get currentPattern => '目前模式';

  @override
  String get idealPattern => '理想模式';

  @override
  String get peakNumber => '峰值編號';

  @override
  String get rhythmConsistency => '節奏一致性';

  @override
  String get pressureConsistency => '壓力一致性';

  @override
  String get frequencyAdequacy => '頻率適當性';

  @override
  String get veryGood => '非常好';

  @override
  String get good => '好';

  @override
  String get needsImprovement => '需要改進';

  @override
  String get needsMorePractice => '需要更多練習';

  @override
  String get noPeaksDetected => '未偵測到峰值';

  @override
  String get selectAll => '全選';

  @override
  String get deselectAll => '取消全選';

  @override
  String get avgRiseTime => '平均上升時間';

  @override
  String get avgFallTime => '平均下降時間';

  @override
  String get avgPeakWidth => '平均峰值寬度';

  @override
  String get outliers => '離群值';

  @override
  String get peakIntensityDistribution => '峰值強度分布';

  @override
  String get rhythmScore => '節奏評分';

  @override
  String get pressureScoreTitle => '壓力評分';

  @override
  String get techniqueScore => '技巧評分';

  @override
  String get fatigueResistance => '抗疲勞性';

  @override
  String get strongPeaks => '強峰值';

  @override
  String get moderatePeaks => '中等峰值';

  @override
  String get weakPeaks => '弱峰值';

  @override
  String countWithPercent(int count, String percent) {
    return '$count 個（$percent%）';
  }

  @override
  String get overallGrade => '綜合等級';

  @override
  String get excellentFrenzel => '卓越的 Frenzel 技巧！';

  @override
  String get veryGoodTechnique => '非常好的技巧';

  @override
  String get satisfactoryLevel => '表現良好';

  @override
  String get roomForImprovement => '仍有改善空間';

  @override
  String get moreTrainingNeeded => '需要更多練習';

  @override
  String get startFromBasics => '請從基礎開始練習';

  @override
  String get weak => '弱';

  @override
  String get moderate => '中等';

  @override
  String get strong => '強';

  @override
  String get weakIntensity => '弱（<50hPa）';

  @override
  String get moderateIntensity => '中等（50-100）';

  @override
  String get strongIntensity => '強（>100）';

  @override
  String get stabilityImproving => '穩定性提升中';

  @override
  String get stabilityDecreasing => '穩定性下降中';

  @override
  String get stabilityMaintained => '穩定維持';

  @override
  String get stabilityTrend => '穩定性趨勢';

  @override
  String get pressureDistribution => '壓力分布';

  @override
  String get basicStats => '基本統計';

  @override
  String get dataPointsLabel => '資料點';

  @override
  String get countUnitItems => '個';

  @override
  String get measurementTime => '量測時間';

  @override
  String get standardDeviation => '標準差';

  @override
  String get advancedStats => '進階統計';

  @override
  String get coefficientOfVariation => '變異係數';

  @override
  String get skewness => '偏度';

  @override
  String get kurtosis => '峰度';

  @override
  String get interquartileRange => '四分位距';

  @override
  String get dataDispersionIndicator => '資料離散指標';

  @override
  String get pressureRangeLabel => '壓力範圍';

  @override
  String get rangeLabel => '範圍';

  @override
  String outlierCount(int count, String percent) {
    return '$count 個（$percent%）';
  }

  @override
  String get percentiles => '百分位數';

  @override
  String get median50 => '中位數（50%）';

  @override
  String get peakSummary => '峰值摘要';

  @override
  String get strongPeakRatio => '強峰值比例';

  @override
  String get dataQuality => '資料品質';

  @override
  String get outliersLabel => '離群值';

  @override
  String get samplingLabel => '取樣';

  @override
  String get dataLabel => '資料';

  @override
  String get veryConsistent => '非常一致';

  @override
  String get consistent => '一致';

  @override
  String get averageVariation => '普通';

  @override
  String get highVariation => '變動大';

  @override
  String get leftSkewed => '左偏分布';

  @override
  String get rightSkewed => '右偏分布';

  @override
  String get normalDistribution => '常態分布';

  @override
  String get excellent => '優秀';

  @override
  String get satisfactory => '良好';

  @override
  String get caution => '注意';

  @override
  String get symmetricDistribution => '對稱分布';

  @override
  String get flatDistribution => '平坦分布';

  @override
  String get peakedDistribution => '尖峰分布';

  @override
  String get normalPressureInterpretation => '壓力分布正常。正在進行一致的 Frenzel 動作。';

  @override
  String get highPressureInterpretation => '高壓力值頻繁出現。峰值時可能需要控制力道。';

  @override
  String get lowPressureInterpretation => '低壓力值偏多。需要練習施加更大壓力。';

  @override
  String get concentratedInterpretation => '集中在特定壓力區間。展現良好的一致性。';

  @override
  String get dispersedInterpretation => '壓力分布範圍較廣。需要提升一致性。';

  @override
  String medianLabel(String value) {
    return '中位數：$value hPa';
  }

  @override
  String get selected => '已選取';

  @override
  String get excluded => '已排除';

  @override
  String keyMetricsWithPeaks(String metrics, int count) {
    return '$metrics（依據 $count 個峰值）';
  }

  @override
  String scorePoints(String score) {
    return '$score分';
  }

  @override
  String secondsValue(String value) {
    return '$value秒';
  }

  @override
  String histogramTooltip(String rangeStart, String rangeEnd, int count) {
    return '$rangeStart-$rangeEnd hPa\n$count個';
  }

  @override
  String get selectUsbDevice => '選擇 USB 裝置';

  @override
  String get rescan => '重新搜尋';

  @override
  String get availableDevices => '可用裝置';

  @override
  String get noDevicesFound => '找不到 USB MIDI 裝置';

  @override
  String get connecting => '連線中...';

  @override
  String get connectionError => '連線錯誤';

  @override
  String get scanningForDevices => '正在搜尋 USB 裝置...';

  @override
  String get scanAgain => '重新搜尋';

  @override
  String get deviceConnectedSuccessfully => '裝置已成功連線！';

  @override
  String get clearData => '清除資料';

  @override
  String get deleteAllMeasurementData => '刪除所有量測資料';

  @override
  String get exportDbToFile => '匯出 DB 檔案';

  @override
  String get exportDatabaseForDebugging => '匯出資料庫供除錯使用';

  @override
  String get deviceAuthenticated => '正品已驗證';

  @override
  String get deviceNotAuthenticated => '驗證失敗';

  @override
  String get counterfeitWarning => '無法確認正品';

  @override
  String get counterfeitWarningTitle => '正品驗證失敗';

  @override
  String get counterfeitWarningMessage =>
      '已連線的裝置未通過 DiveChecker 正品驗證。\n\n使用仿冒品可能導致量測數值不準確，且技術支援將受到限制。';

  @override
  String get continueAnyway => '仍要繼續';

  @override
  String get verifyingDevice => '正在驗證裝置...';

  @override
  String get firmwareUpdate => '韌體更新';

  @override
  String get firmwareUpdateDescription => '檢查與更新裝置韌體';

  @override
  String get firmwareVerificationSuccess => '簽章驗證成功';

  @override
  String get firmwareVerificationFailed => '簽章驗證失敗';

  @override
  String get firmwareInstall => '安裝';

  @override
  String get firmwareRebootToBootsel => '重新啟動至 BOOTSEL 模式';

  @override
  String get firmwareRebootDescription =>
      '裝置將重新啟動至 BOOTSEL 模式。\n\n重新啟動後：\n1. 「RPI-RP2」磁碟機將會出現\n2. 請複製 .uf2 韌體檔案\n3. 裝置將自動重新啟動';

  @override
  String get currentFirmware => '目前韌體';

  @override
  String get dangerZone => '危險區域';

  @override
  String get rebootDevice => '重新啟動裝置';

  @override
  String get rebootDeviceDescription => '重新啟動裝置';

  @override
  String get rebootConfirmMessage => '是否重新啟動裝置？連線將會中斷。';

  @override
  String get reboot => '重新啟動';

  @override
  String get bootselMode => 'BOOTSEL 模式';

  @override
  String get bootselModeDescription => '手動韌體更新模式';

  @override
  String get bootselRebootSent => '已傳送 BOOTSEL 重新啟動指令';

  @override
  String get deviceDisconnected => '裝置已中斷連線';

  @override
  String get pleaseReconnectDevice => '請重新連接裝置。';

  @override
  String get connectionLostDuringMeasurement => '量測期間連線中斷。是否儲存已記錄的資料？';

  @override
  String get pinMismatch => 'PIN 不一致';

  @override
  String get pinChangeRequested => '已提交 PIN 變更請求';

  @override
  String get nameChangeRequested => '已提交名稱變更請求';

  @override
  String get currentPin => '目前 PIN';

  @override
  String get newPin => '新 PIN';

  @override
  String get confirmPin => '確認 PIN';

  @override
  String get newDeviceName => '新裝置名稱';

  @override
  String get pinRequiredForChange => '變更設定需要 PIN';

  @override
  String get change => '變更';

  @override
  String get myDevices => '我的裝置';

  @override
  String get connectedDevices => '已連線裝置';

  @override
  String get noDeviceConnected => '無已連線裝置';

  @override
  String get displayResolution => '畫面更新率';

  @override
  String get displayResolutionDescription => '圖表畫面更新速度';

  @override
  String get outputRate => '輸出頻率';

  @override
  String get outputRateDescription => '感測器輸出頻率';

  @override
  String get tapToChange => '點擊以變更';

  @override
  String get connectDeviceFirst => '請先連接裝置';

  @override
  String outputRateChanged(Object rate) {
    return '輸出頻率已變更為 $rate Hz';
  }

  @override
  String get noiseFilter => '雜訊濾波器';

  @override
  String get noiseFilterDescription => '降低雜訊的軟體濾波器';

  @override
  String get filterStrength => '濾波強度';

  @override
  String get filterStrengthDescription => '數值越高顯示越平滑';

  @override
  String get atmosphericCalibrating => '正在量測大氣壓力...';

  @override
  String get atmosphericRecalibrate => '重新量測大氣壓力';

  @override
  String get atmosphericKeepSensorStill => '請將感測器靜置於空氣中';

  @override
  String secondsRemaining(int seconds) {
    return '剩餘 $seconds 秒';
  }

  @override
  String get selectFile => '選擇檔案';

  @override
  String get backToFileList => '返回檔案清單';

  @override
  String get readyToInstall => '準備安裝';

  @override
  String get verificationFailed => '驗證失敗';

  @override
  String get reset => '重設';

  @override
  String get fullscreen => '全螢幕';

  @override
  String get waitingForData => '等待資料中...';

  @override
  String get overrangeWarningTitle => '超出量測範圍！';

  @override
  String get overrangeWarningMessage => '已超出感測器的量測範圍。請勿過度用力吹氣或吸氣！感測器正在恢復中...';

  @override
  String get usbMidiDevicesTitle => 'USB MIDI 裝置';

  @override
  String get connectViaCable => '請使用 USB 傳輸線連接壓力感測器';

  @override
  String get noUsbDevicesFound => '找不到 USB 裝置';

  @override
  String get connectDeviceViaCable => '請使用 USB 傳輸線連接裝置';

  @override
  String get diveCheckerCompatible => 'DiveChecker 相容';

  @override
  String scanFailedError(String error) {
    return '搜尋失敗：$error';
  }

  @override
  String connectionErrorWithMessage(String error) {
    return '連線錯誤：$error';
  }

  @override
  String get noFirmwareFilesFound => '找不到韌體檔案';

  @override
  String get lookingForFirmwareFiles => '正在尋找 *.bin 或 *_signed.bin 檔案';

  @override
  String get deviceNotConnectedError => '裝置未連線';

  @override
  String get signatureValid => '簽章已驗證 ✓';

  @override
  String get signatureInvalid => '簽章驗證失敗 ✗';

  @override
  String get firmwareUntrustedWarning => '此韌體未以有效金鑰簽署。可能已損毀或來自不可信的來源。';

  @override
  String verifiedFirmwareSaved(String filename) {
    return '已儲存驗證通過的韌體：$filename';
  }

  @override
  String get calibrationTimedOut => '校正逾時 - 感測器資料不足';

  @override
  String get loading => '載入中...';

  @override
  String failedToSaveSession(String error) {
    return '紀錄儲存失敗：$error';
  }

  @override
  String failedToDeleteSession(String error) {
    return '紀錄刪除失敗：$error';
  }

  @override
  String failedToLoadSessionData(String error) {
    return '紀錄資料載入失敗：$error';
  }
}
