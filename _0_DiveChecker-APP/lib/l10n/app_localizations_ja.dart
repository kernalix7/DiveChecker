// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ダイブチェッカー';

  @override
  String get disclaimerTitle => '重要なお知らせ';

  @override
  String get disclaimerContent =>
      'DiveCheckerはフリーダイビングのイコライゼーション練習の参考用として設計されています。\n\n⚠️ 本アプリは医療機器ではなく、医療診断や治療目的には使用できません。\n\n⚠️ ダイビング時は常に安全を最優先にしてください。本アプリのみに頼ってダイビングの判断を行わないでください。\n\n⚠️ 開発者は本アプリの使用中に発生した事故、怪我、損害について一切の責任を負いません。\n\n本アプリを使用することにより、上記の条件に同意したものとみなします。';

  @override
  String get disclaimerAgree => '理解し、同意します';

  @override
  String get disclaimerDoNotShowAgain => '今後表示しない';

  @override
  String get home => 'ホーム';

  @override
  String get monitor => 'モニター';

  @override
  String get measurement => '測定';

  @override
  String get history => '履歴';

  @override
  String get deviceConnected => '本体接続済み';

  @override
  String get deviceNotConnected => '未接続';

  @override
  String get deviceDiscovery => 'デバイス検索';

  @override
  String get searchingDevice => 'Divechecker本体を検索しています...';

  @override
  String get measurementReady => '測定準備完了';

  @override
  String get tapToConnect => '接続ボタンを押して開始してください';

  @override
  String get connectDevice => '接続';

  @override
  String get disconnect => '接続解除';

  @override
  String get searching => '検索中...';

  @override
  String get makeSureDevicePowered => 'Divechecker本体の電源が入っているか確認してください';

  @override
  String get sensorError => 'センサー接続エラー';

  @override
  String get sensorErrorDescription => '測定センサーが検出されません。接続状態を確認してください。';

  @override
  String get connectionRequired => '接続が必要です';

  @override
  String get connectionRequiredMessage =>
      '測定を開始するには、まずDivechecker本体に接続してください。\n\nホームタブからデバイスを接続できます。';

  @override
  String get goToHome => 'ホームへ移動';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get ok => 'OK';

  @override
  String get close => '閉じる';

  @override
  String get add => '追加';

  @override
  String get peakAnalysisDisclaimer => 'この分析は参考値であり、完全ではありません。結果の解釈にはご注意ください。';

  @override
  String get connectedSuccess => 'Divechecker本体の接続に成功しました！';

  @override
  String get disconnected => 'Divechecker本体の接続が解除されました';

  @override
  String get unsupportedDevice => '非対応デバイス';

  @override
  String get onlyDiveCheckerSupported =>
      'DiveCheckerデバイスのみ対応しています。このデバイスはアプリで使用できません。';

  @override
  String get startMeasurement => '測定開始';

  @override
  String get stopMeasurement => '測定終了';

  @override
  String get pauseMeasurement => '一時停止';

  @override
  String get resumeMeasurement => '再開';

  @override
  String get measurementStarted => '測定を開始しました';

  @override
  String get measurementPaused => '測定を一時停止しました';

  @override
  String get measurementResumed => '測定を再開しました';

  @override
  String get measurementComplete => '測定完了';

  @override
  String get measurementSaved => '測定を保存しました';

  @override
  String get measurementSettings => '測定設定';

  @override
  String measurementNumber(int number) {
    return '測定 #$number';
  }

  @override
  String get currentPressure => '現在';

  @override
  String get maxPressure => '最大';

  @override
  String get avgPressure => '平均';

  @override
  String get elapsedTime => '時間';

  @override
  String get pressureUnit => '圧力単位';

  @override
  String get sampleRate => 'サンプリングレート';

  @override
  String get msInterval => 'ms間隔';

  @override
  String get maxPressureLabel => '最大圧力';

  @override
  String get avgPressureLabel => '平均圧力';

  @override
  String get durationLabel => '測定時間';

  @override
  String get pressureAnalysis => '圧力分析';

  @override
  String get saveSession => 'セッション保存';

  @override
  String get saveSessionQuestion => 'この測定セッションを保存しますか？';

  @override
  String get save => '保存';

  @override
  String get discard => '破棄';

  @override
  String get sessionSaved => 'セッションを保存しました';

  @override
  String get sessionDiscarded => 'セッションを破棄しました';

  @override
  String get noData => 'データなし';

  @override
  String get awaitingData => '測定データ待機中';

  @override
  String get noMeasurements => '測定履歴がまだありません';

  @override
  String get startMeasuringHint => '測定タブから最初の測定を開始してください';

  @override
  String get sessionHistory => 'セッション履歴';

  @override
  String get noSessions => 'セッションがまだありません';

  @override
  String get startMeasuringToSee => '測定を開始すると、ここに履歴が表示されます';

  @override
  String get deleteSession => 'セッション削除';

  @override
  String get deleteSessionConfirm => 'このセッションを削除しますか？';

  @override
  String get delete => '削除';

  @override
  String get sessionDeleted => 'セッションを削除しました';

  @override
  String get deleteRecord => '記録削除';

  @override
  String get deleteRecordConfirm => 'この測定記録を削除しますか？';

  @override
  String get recordDeleted => '記録を削除しました';

  @override
  String get graphDetails => 'グラフ詳細';

  @override
  String get zoomIn => '拡大';

  @override
  String get zoomOut => '縮小';

  @override
  String get resetZoom => 'リセット';

  @override
  String get panLeft => '左へ';

  @override
  String get panRight => '右へ';

  @override
  String get addNote => 'メモ追加';

  @override
  String get editNote => 'メモ編集';

  @override
  String get noteOptional => 'メモ（任意）';

  @override
  String get noteHint => 'このセッションに関するメモを入力してください';

  @override
  String get noteContent => 'メモ内容';

  @override
  String get noteAdded => 'メモを追加しました';

  @override
  String get noteUpdated => 'メモを更新しました';

  @override
  String get notes => 'メモ';

  @override
  String get noteInfo => 'メモ情報';

  @override
  String get noNotes => 'メモがありません';

  @override
  String get tapGraphToAddNote => 'グラフをタップしてメモを追加してください';

  @override
  String timePoint(int seconds) {
    return '$seconds秒地点';
  }

  @override
  String get statistics => '統計';

  @override
  String get duration => '測定時間';

  @override
  String get dataPoints => 'データポイント';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get english => '英語';

  @override
  String get korean => '韓国語';

  @override
  String get appearance => '外観';

  @override
  String get theme => 'テーマ';

  @override
  String get themeSystem => 'システム設定';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeDescription => 'お好みのテーマを選択してください';

  @override
  String get notifications => '通知';

  @override
  String get enableNotifications => '通知を有効にする';

  @override
  String get getAlertsForMeasurements => '測定通知を受け取る';

  @override
  String get hapticFeedback => '触覚フィードバック';

  @override
  String get vibrateOnKeyActions => '主要操作時に振動';

  @override
  String get editTitle => 'タイトル編集';

  @override
  String get sessionTitle => 'セッションタイトル';

  @override
  String get about => '情報';

  @override
  String get appVersion => 'アプリバージョン';

  @override
  String get helpAndSupport => 'ヘルプとサポート';

  @override
  String get licenses => 'ライセンス';

  @override
  String get liveMonitoring => 'リアルタイムモニタリング';

  @override
  String get currentPressureLabel => '現在の圧力';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String minutesSeconds(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String secondsOnly(int seconds) {
    return '$seconds秒';
  }

  @override
  String get tapToExpand => 'タップして拡大';

  @override
  String get measurementHistory => '測定履歴';

  @override
  String get filterByDevice => 'デバイス別フィルター';

  @override
  String get selectDevice => 'デバイス選択';

  @override
  String get allDevices => 'すべてのデバイス';

  @override
  String sessionsCount(int count) {
    return '$count件の記録';
  }

  @override
  String get deviceSettings => 'デバイス設定';

  @override
  String get deviceName => 'デバイス名';

  @override
  String get changeDeviceName => 'デバイス名変更';

  @override
  String get enterNewDeviceName => '新しいデバイス名を入力';

  @override
  String get devicePin => 'デバイスPIN';

  @override
  String get changeDevicePin => 'PIN変更';

  @override
  String get enterCurrentPin => '現在のPINを入力';

  @override
  String get enterNewPin => '新しいPINを入力（4桁）';

  @override
  String get confirmNewPin => '新しいPINの確認';

  @override
  String get wrongPin => 'PINが正しくありません';

  @override
  String get pinChanged => 'PINを変更しました';

  @override
  String get nameChanged => 'デバイス名を変更しました';

  @override
  String get pinMustBe4Digits => 'PINは4桁の数字でなければなりません';

  @override
  String get pinsMustMatch => 'PINが一致しません';

  @override
  String get nameTooLong => '名前が長すぎます（最大全角8文字、半角24文字）';

  @override
  String get pause => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get stop => '終了';

  @override
  String get liveSensorData => 'リアルタイムセンサーデータ';

  @override
  String get recording => '録画';

  @override
  String get openSourceLicenses => 'オープンソースライセンス';

  @override
  String get appDescription => 'フリーダイビング イコライジングツール';

  @override
  String get samples => 'サンプル';

  @override
  String get points => '点';

  @override
  String get analyticsComingSoon => '高度な分析機能を追加予定';

  @override
  String get analytics => '分析';

  @override
  String get pressureWaveform => '圧力波形';

  @override
  String get peak => '最大';

  @override
  String get average => '普通';

  @override
  String get sec => '秒';

  @override
  String get deviceConnectedReady => 'デバイス接続済み - 測定準備完了';

  @override
  String get deviceNotConnectedShort => 'デバイス未接続';

  @override
  String get tapToBeginMonitoring => 'タップして圧力モニタリングを開始';

  @override
  String sampleCount(int count) {
    return '$count個のサンプル';
  }

  @override
  String get noNotesYetTapEdit => 'まだメモがありません。編集ボタンをタップするか、グラフからメモを追加してください。';

  @override
  String get madeWithFlutter => 'Flutterで開発';

  @override
  String get mitLicense => 'Apache License 2.0';

  @override
  String get mitLicenseContent =>
      'ライセンスとNOTICEを含めて使用・修正・配布が可能であり、すべてのソフトウェアは保証なく「現状のまま（AS IS）」で提供されます。';

  @override
  String get midiCommunication => 'USB MIDI通信';

  @override
  String get chartVisualization => 'チャート可視化';

  @override
  String get sqliteDatabase => 'SQLiteデータベース';

  @override
  String get stateManagement => '状態管理';

  @override
  String get localStorage => 'ローカルストレージ';

  @override
  String get internationalization => '多言語対応';

  @override
  String get copyright => '著作権';

  @override
  String get allRightsReserved => '全著作権所有';

  @override
  String get tapToViewFullLicense => 'タップしてライセンス全文を表示';

  @override
  String get analysis => '分析';

  @override
  String get advancedAnalysis => '高度な分析';

  @override
  String get peakAnalysis => 'ピーク分析';

  @override
  String get peakAnalysisDesc => 'ピーク検出およびイコライゼーションパターン分析';

  @override
  String get statisticsDashboard => '統計ダッシュボード';

  @override
  String get statisticsDashboardDesc => '日別/週別/月別の統計表示';

  @override
  String get segmentAnalysis => '区間分析';

  @override
  String get segmentAnalysisDesc => '特定の時間区間の分析と比較';

  @override
  String get trendGraph => 'トレンドグラフ';

  @override
  String get trendGraphDesc => '時間の経過に伴う上達の追跡';

  @override
  String get patternRecognition => 'パターン認識';

  @override
  String get patternRecognitionDesc => '理想的なFrenzelパターンとの比較';

  @override
  String get comingSoon => '準備中';

  @override
  String get featureInDevelopment => 'この機能は現在開発中です。';

  @override
  String get noSessionsForAnalysis => '分析するセッションがありません';

  @override
  String get selectSession => 'セッション選択';

  @override
  String get backToMenu => 'メニューに戻る';

  @override
  String get keyMetrics => '主要指標';

  @override
  String get totalPeaks => '総ピーク数';

  @override
  String get peaksUnit => '回';

  @override
  String get peakFrequency => '頻度';

  @override
  String get perMinute => '回/分';

  @override
  String get avgPeakInterval => '平均間隔';

  @override
  String get avgPeakPressure => '平均ピーク';

  @override
  String get performanceScores => 'パフォーマンススコア';

  @override
  String get consistencyScore => '一貫性スコア';

  @override
  String get fatigueIndex => '疲労度指数';

  @override
  String get consistencyExcellent => '素晴らしい！非常に一貫したイコライゼーション技術です。';

  @override
  String get consistencyGood => '良好です。圧力とタイミングにわずかな変動があります。';

  @override
  String get consistencyFair => '普通です。一貫性の向上の余地があります。';

  @override
  String get consistencyNeedsWork => '改善が必要です。より一貫した技術を目指して練習しましょう。';

  @override
  String get fatigueMinimal => '疲労度はほぼありません。素晴らしい持久力です！';

  @override
  String get fatigueLow => '低い疲労度。パフォーマンスがよく維持されています。';

  @override
  String get fatigueModerate => '中程度の疲労度。より短いセッションを検討してください。';

  @override
  String get fatigueHigh => '高い疲労度。圧力が大幅に低下しました。';

  @override
  String get detailedStats => '詳細統計';

  @override
  String get maxPeakPressure => '最大ピーク圧力';

  @override
  String get minPeakPressure => '最小ピーク圧力';

  @override
  String get pressureRange => '圧力範囲';

  @override
  String get peakVisualization => 'ピーク可視化';

  @override
  String get detectedPeaks => '検出されたピーク';

  @override
  String get dataManagement => 'データ管理';

  @override
  String get backupData => 'データバックアップ';

  @override
  String get backupDataDescription => 'すべてのデータをJSONファイルにエクスポート';

  @override
  String get restoreData => 'データ復元';

  @override
  String get restoreDataDescription => 'バックアップファイルからデータをインポート';

  @override
  String get backupSuccess => 'バックアップが完了しました';

  @override
  String get backupFailed => 'バックアップ失敗';

  @override
  String get restoreSuccess => '復元が完了しました';

  @override
  String get restoreFailed => '復元失敗';

  @override
  String get restoreConfirm => '復元の確認';

  @override
  String get restoreConfirmMessage => '既存のデータがすべて置き換えられます。続行しますか？';

  @override
  String get restore => '復元';

  @override
  String get invalidBackupFile => '無効なバックアップファイル';

  @override
  String dataPointsCount(int count) {
    return '$count個のデータポイント';
  }

  @override
  String get appName => 'DiveChecker';

  @override
  String get appSubtitle => 'イコライゼーション圧力モニター';

  @override
  String get appTitleFull => 'DiveChecker Pro';

  @override
  String get statusOnline => '接続済み';

  @override
  String get statusOffline => '未接続';

  @override
  String get statusScanning => '検索中...';

  @override
  String get statusRecording => '録画';

  @override
  String get measurementScreenTitle => '圧力測定';

  @override
  String get historyScreenTitle => '測定履歴';

  @override
  String get settingsScreenTitle => '設定';

  @override
  String get segmentAvgPressureComparison => '区間別平均圧力比較';

  @override
  String get segmentDetailedAnalysis => '区間別詳細分析';

  @override
  String get segmentChangeAnalysis => '区間変化分析';

  @override
  String segmentNumber(int number) {
    return '区間 $number';
  }

  @override
  String segmentTooltip(int index, String avgPressure, int peakCount) {
    return '区間 $index\\n平均: $avgPressure hPa\\nピーク: $peakCount回';
  }

  @override
  String get avgLabel => '平均';

  @override
  String get maxLabel => '最大';

  @override
  String get peakLabel => 'ピーク';

  @override
  String get countUnit => '回';

  @override
  String get variabilityLabel => '変動性';

  @override
  String get notEnoughSegments => '区間が十分ではありません';

  @override
  String get stablePressureAnalysis => '安定した圧力を維持しています！最初から最後まで一貫したパフォーマンスです。';

  @override
  String pressureIncreaseAnalysis(String percent) {
    return '後半にかけて圧力が$percent%増加しました。ウォームアップ効果が現れたか、より強くイコライゼーションしています。';
  }

  @override
  String pressureDecreaseAnalysis(String percent) {
    return '後半にかけて圧力が$percent%減少しました。疲労が蓄積している可能性があります。休息を検討してください。';
  }

  @override
  String get trendStable => '安定';

  @override
  String get trendRising => '上昇傾向';

  @override
  String get trendFalling => '下降傾向';

  @override
  String get firstToLast => '最初 → 最後';

  @override
  String get peakCountChange => 'ピーク数の変化';

  @override
  String get trendRising2 => '上昇';

  @override
  String get trendFalling2 => '下降';

  @override
  String get trendMaintained => '維持';

  @override
  String overallTrend(String trend) {
    return '全体の傾向: $trend';
  }

  @override
  String slopeLabel(String slope) {
    return '傾き: $slope hPa/秒';
  }

  @override
  String get pressureTrendGraph => '圧力トレンドグラフ';

  @override
  String get originalData => '元データ';

  @override
  String get movingAverage => '移動平均';

  @override
  String get trendLine => 'トレンドライン';

  @override
  String get trendAnalysis => 'トレンド分析';

  @override
  String get startPressureTrend => '開始圧力（トレンド）';

  @override
  String get endPressureTrend => '終了圧力（トレンド）';

  @override
  String get changeAmount => '変化量';

  @override
  String get changeRate => '変化率';

  @override
  String get strongRisingTrend => '強い上昇傾向';

  @override
  String get strongRisingDesc =>
      '時間の経過とともに圧力が大幅に増加しています。筋肉がウォームアップし、より強いイコライゼーションが可能になったか、徐々に力を入れています。';

  @override
  String get moderateRisingTrend => '緩やかな上昇傾向';

  @override
  String get moderateRisingDesc => '圧力が徐々に増加しています。良いウォームアップパターンです。';

  @override
  String get stableMaintained => '安定した維持';

  @override
  String get stableMaintainedDesc => '圧力が一定に維持されています。素晴らしい持久力と一貫性です！';

  @override
  String get moderateFallingTrend => '緩やかな下降傾向';

  @override
  String get moderateFallingDesc =>
      '圧力が徐々に減少しています。わずかに疲労が蓄積している可能性があります。休息を検討してください。';

  @override
  String get strongFallingTrend => '強い下降傾向';

  @override
  String get strongFallingDesc => '圧力が大幅に減少しています。疲労が蓄積しました。十分な休息が必要です。';

  @override
  String get continuousPerformanceAnalysis => '連続パフォーマンス分析';

  @override
  String get patternComparison => 'パターン比較';

  @override
  String get peakQualityHeatmap => 'ピーク品質ヒートマップ';

  @override
  String get patternCharacteristics => 'パターン特性';

  @override
  String get customTrainingSuggestions => 'カスタムトレーニング提案';

  @override
  String get maxConsecutive => '最大連続';

  @override
  String get avgConsecutive => '平均連続';

  @override
  String get qualityPeaks => '高品質ピーク';

  @override
  String get excellentConsistency =>
      '卓越しています！長時間にわたり一貫した品質を維持しています。現在のレベルを維持しましょう。';

  @override
  String get goodConsistency => '良好です！連続性が優れています。より長い連続維持を目指しましょう。';

  @override
  String get moderateConsistency => '中程度です。集中力を維持し、連続した高品質ピークを増やしましょう。';

  @override
  String get needsImprovementConsistency =>
      '連続性の向上が必要です。各イコライゼーションにもっと集中しましょう。';

  @override
  String get masterPhase => 'マスター段階';

  @override
  String get masterPhaseDesc => '高度なテクニックの磨き上げと特殊状況への備え';

  @override
  String get masterFocuses => 'ダイナミックイコライゼーション,高圧状況シミュレーション,持続時間の延長';

  @override
  String get advancedPhase => '上級段階';

  @override
  String get advancedPhaseDesc => '一貫性の向上と高度なテクニックの習得';

  @override
  String get advancedFocuses => '圧力の一貫性強化,リズムの最適化,疲労耐性トレーニング';

  @override
  String get intermediatePhase => '中級段階';

  @override
  String get intermediatePhaseDesc => '基本技術の安定化と品質向上';

  @override
  String get intermediateFocuses => '正確なタイミング,適正圧力の把握,反復練習';

  @override
  String get basicPhase => '基礎段階';

  @override
  String get basicPhaseDesc => '基本動作の習得と感覚の開発';

  @override
  String get basicFocuses => '基本姿勢,呼吸コントロール,低圧力での練習';

  @override
  String get currentFocusAreas => '現在注力すべき領域:';

  @override
  String peakScore(int index, String score) {
    return 'ピーク $index: $score点';
  }

  @override
  String get rhythmImprovementTraining => 'リズム改善トレーニング';

  @override
  String get rhythmTip1 => 'メトロノームアプリを使って一定のリズムに合わせて練習しましょう';

  @override
  String get rhythmTip2 => 'カウント法: 1-2-3-4のリズムでイコライゼーションしましょう';

  @override
  String get rhythmTip3 => 'ゆっくり始めて、徐々にスピードを上げましょう';

  @override
  String get pressureConsistencyTraining => '圧力一貫性トレーニング';

  @override
  String get pressureTip1 => '同じ力で10回連続のイコライゼーションを目標にしましょう';

  @override
  String get pressureTip2 => '鏡を見ながら頬と舌の動きを一定に保ちましょう';

  @override
  String get pressureTip3 => '強すぎず、快適な圧力を見つけましょう';

  @override
  String get frequencyOptimizationTraining => '頻度最適化トレーニング';

  @override
  String get frequencyTip1 => '理想的な頻度は毎分20〜40回です';

  @override
  String get frequencyTip2 => '1回ごとに十分なイコライゼーションを行いましょう';

  @override
  String get frequencyTip3 => '不必要に速いイコライゼーションは避けましょう';

  @override
  String get enduranceTraining => '持久力向上トレーニング';

  @override
  String get enduranceTip1 => '段階的に練習時間を延ばしましょう';

  @override
  String get enduranceTip2 => '休息とトレーニングをバランスよく配分しましょう';

  @override
  String get enduranceTip3 => '規則的な練習が持久力向上の鍵です';

  @override
  String get irregularIntervalSuggestion =>
      'イコライゼーションの間隔が不規則です。一定のリズムで練習しましょう。';

  @override
  String get irregularPressureSuggestion =>
      'ピーク圧力が不規則です。一定の力でイコライゼーションする練習が必要です。';

  @override
  String get lowFrequencySuggestion =>
      'イコライゼーションの頻度が低いです。より頻繁にイコライゼーションする練習をしましょう。';

  @override
  String get highFrequencySuggestion =>
      'イコライゼーションが頻繁すぎます。各イコライゼーションにもっと集中しましょう。';

  @override
  String get fatigueDetectedSuggestion =>
      '後半にかけて圧力が低下しています。持久力向上トレーニングが役立つかもしれません。';

  @override
  String get excellentPattern => '優秀';

  @override
  String get excellentPatternDesc => '理想的なFrenzelパターンに近いです！';

  @override
  String get minPressureLabel => '最小圧力';

  @override
  String get goodPattern => '良好';

  @override
  String get goodPatternDesc => '良い基礎力を持っています。いくつかの改善点があります。';

  @override
  String get averagePattern => '普通';

  @override
  String get averagePatternDesc => '基本パターンは形成されていますが、改善が必要です。';

  @override
  String get needsPractice => '練習が必要';

  @override
  String get needsPracticeDesc => 'さらなる練習が必要です。以下の提案を参考にしてください。';

  @override
  String get excellentPatternKeepUp => '現在のパターンはとても良いです！引き続き維持しましょう。';

  @override
  String patternGrade(String grade) {
    return 'パターン等級: $grade';
  }

  @override
  String get rhythmLabel => 'リズム';

  @override
  String get pressureLabel => '圧力';

  @override
  String get frequencyLabel => '頻度';

  @override
  String get enduranceLabel => '持久力';

  @override
  String get currentPattern => '現在のパターン';

  @override
  String get idealPattern => '理想的なパターン';

  @override
  String get peakNumber => 'ピーク番号';

  @override
  String get rhythmConsistency => 'リズムの一貫性';

  @override
  String get pressureConsistency => '圧力の一貫性';

  @override
  String get frequencyAdequacy => '頻度の適切さ';

  @override
  String get veryGood => '非常に良い';

  @override
  String get good => '良い';

  @override
  String get needsImprovement => '改善が必要';

  @override
  String get needsMorePractice => 'さらなる練習が必要';

  @override
  String get noPeaksDetected => 'ピークが検出されませんでした';

  @override
  String get selectAll => '全選択';

  @override
  String get deselectAll => '選択解除';

  @override
  String get avgRiseTime => '平均上昇時間';

  @override
  String get avgFallTime => '平均下降時間';

  @override
  String get avgPeakWidth => '平均ピーク幅';

  @override
  String get outliers => '外れ値';

  @override
  String get peakIntensityDistribution => 'ピーク強度分布';

  @override
  String get rhythmScore => 'リズムスコア';

  @override
  String get pressureScoreTitle => '圧力スコア';

  @override
  String get techniqueScore => 'テクニックスコア';

  @override
  String get fatigueResistance => '疲労耐性';

  @override
  String get strongPeaks => '強いピーク';

  @override
  String get moderatePeaks => '中程度のピーク';

  @override
  String get weakPeaks => '弱いピーク';

  @override
  String countWithPercent(int count, String percent) {
    return '$count個 ($percent%)';
  }

  @override
  String get overallGrade => '総合等級';

  @override
  String get excellentFrenzel => '卓越したFrenzel技法！';

  @override
  String get veryGoodTechnique => '非常に良い技法です';

  @override
  String get satisfactoryLevel => '良好なレベルです';

  @override
  String get roomForImprovement => '改善の余地があります';

  @override
  String get moreTrainingNeeded => 'さらなる練習が必要です';

  @override
  String get startFromBasics => '基礎から練習しましょう';

  @override
  String get weak => '弱い';

  @override
  String get moderate => '中程度';

  @override
  String get strong => '強い';

  @override
  String get weakIntensity => '弱い (<50hPa)';

  @override
  String get moderateIntensity => '中程度 (50-100)';

  @override
  String get strongIntensity => '強い (>100)';

  @override
  String get stabilityImproving => '安定性が向上中';

  @override
  String get stabilityDecreasing => '安定性が低下中';

  @override
  String get stabilityMaintained => '安定を維持';

  @override
  String get stabilityTrend => '安定性の傾向';

  @override
  String get pressureDistribution => '圧力分布';

  @override
  String get basicStats => '基本統計';

  @override
  String get dataPointsLabel => 'データポイント';

  @override
  String get countUnitItems => '個';

  @override
  String get measurementTime => '測定時間';

  @override
  String get standardDeviation => '標準偏差';

  @override
  String get advancedStats => '高度な統計';

  @override
  String get coefficientOfVariation => '変動係数';

  @override
  String get skewness => '歪度';

  @override
  String get kurtosis => '尖度';

  @override
  String get interquartileRange => '四分位範囲';

  @override
  String get dataDispersionIndicator => 'データ散布指標';

  @override
  String get pressureRangeLabel => '圧力範囲';

  @override
  String get rangeLabel => '範囲';

  @override
  String outlierCount(int count, String percent) {
    return '$count個 ($percent%)';
  }

  @override
  String get percentiles => 'パーセンタイル';

  @override
  String get median50 => '中央値 (50%)';

  @override
  String get peakSummary => 'ピーク要約';

  @override
  String get strongPeakRatio => '強いピークの割合';

  @override
  String get dataQuality => 'データ品質';

  @override
  String get outliersLabel => '外れ値';

  @override
  String get samplingLabel => 'サンプリング';

  @override
  String get dataLabel => 'データ';

  @override
  String get veryConsistent => '非常に一貫的';

  @override
  String get consistent => '一貫的';

  @override
  String get averageVariation => '普通';

  @override
  String get highVariation => '変動が大きい';

  @override
  String get leftSkewed => '左に偏った分布';

  @override
  String get rightSkewed => '右に偏った分布';

  @override
  String get normalDistribution => '正規分布';

  @override
  String get excellent => '優秀';

  @override
  String get satisfactory => '良好';

  @override
  String get caution => '注意';

  @override
  String get symmetricDistribution => '対称分布';

  @override
  String get flatDistribution => '平坦な分布';

  @override
  String get peakedDistribution => '尖った分布';

  @override
  String get normalPressureInterpretation => '圧力分布は正常です。一貫したFrenzel動作を行っています。';

  @override
  String get highPressureInterpretation =>
      '高い圧力値が頻繁に現れています。ピーク時の力の加減が必要かもしれません。';

  @override
  String get lowPressureInterpretation => '低い圧力値が多いです。より強い圧力をかける練習が必要です。';

  @override
  String get concentratedInterpretation => '特定の圧力帯に集中しています。良い一貫性を示しています。';

  @override
  String get dispersedInterpretation => '圧力が広く分散しています。一貫性の向上が必要です。';

  @override
  String medianLabel(String value) {
    return '中央値: $value hPa';
  }

  @override
  String get selected => '選択中';

  @override
  String get excluded => '除外';

  @override
  String keyMetricsWithPeaks(String metrics, int count) {
    return '$metrics（$count個のピーク基準）';
  }

  @override
  String scorePoints(String score) {
    return '$score点';
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
  String get selectUsbDevice => 'USBデバイス選択';

  @override
  String get rescan => '再検索';

  @override
  String get availableDevices => '利用可能なデバイス';

  @override
  String get noDevicesFound => 'USB MIDIデバイスが見つかりません';

  @override
  String get connecting => '接続中...';

  @override
  String get connectionError => '接続エラー';

  @override
  String get scanningForDevices => 'USBデバイスを検索中...';

  @override
  String get scanAgain => '再検索';

  @override
  String get deviceConnectedSuccessfully => 'デバイスの接続に成功しました！';

  @override
  String get clearData => 'データ削除';

  @override
  String get deleteAllMeasurementData => 'すべての測定データを削除';

  @override
  String get exportDbToFile => 'DBファイルのエクスポート';

  @override
  String get exportDatabaseForDebugging => 'デバッグ用データベースのエクスポート';

  @override
  String get deviceAuthenticated => '正規品認証済み';

  @override
  String get deviceNotAuthenticated => '認証失敗';

  @override
  String get counterfeitWarning => '正規品を確認できません';

  @override
  String get counterfeitWarningTitle => '正規品認証失敗';

  @override
  String get counterfeitWarningMessage =>
      '接続されたデバイスは正規品のDiveCheckerとして認証されませんでした。\n\n模倣品の使用は測定値が不正確になる可能性があり、技術サポートが制限されます。';

  @override
  String get continueAnyway => 'このまま使用';

  @override
  String get verifyingDevice => 'デバイス認証中...';

  @override
  String get firmwareUpdate => 'ファームウェアアップデート';

  @override
  String get firmwareUpdateDescription => 'デバイスのファームウェア確認とアップデート';

  @override
  String get firmwareVerificationSuccess => '署名検証成功';

  @override
  String get firmwareVerificationFailed => '署名検証失敗';

  @override
  String get firmwareInstall => 'インストール';

  @override
  String get firmwareRebootToBootsel => 'BOOTSELモードで再起動';

  @override
  String get firmwareRebootDescription =>
      'デバイスがBOOTSELモードで再起動します。\n\n再起動後:\n1. 「RPI-RP2」ドライブが表示されます\n2. .uf2ファームウェアファイルをコピーしてください\n3. デバイスが自動的に再起動します';

  @override
  String get currentFirmware => '現在のファームウェア';

  @override
  String get dangerZone => '危険な操作';

  @override
  String get rebootDevice => 'デバイス再起動';

  @override
  String get rebootDeviceDescription => 'デバイスを再起動します';

  @override
  String get rebootConfirmMessage => 'デバイスを再起動しますか？接続が切断されます。';

  @override
  String get reboot => '再起動';

  @override
  String get bootselMode => 'BOOTSELモード';

  @override
  String get bootselModeDescription => 'ファームウェア手動アップデートモード';

  @override
  String get bootselRebootSent => 'BOOTSEL再起動コマンドを送信しました';

  @override
  String get deviceDisconnected => 'デバイスの接続が解除されました';

  @override
  String get pleaseReconnectDevice => 'デバイスを再接続してください。';

  @override
  String get connectionLostDuringMeasurement =>
      '測定中に接続が切断されました。記録されたデータを保存しますか？';

  @override
  String get pinMismatch => 'PINが一致しません';

  @override
  String get pinChangeRequested => 'PIN変更をリクエストしました';

  @override
  String get nameChangeRequested => '名前変更をリクエストしました';

  @override
  String get currentPin => '現在のPIN';

  @override
  String get newPin => '新しいPIN';

  @override
  String get confirmPin => 'PINの確認';

  @override
  String get newDeviceName => '新しいデバイス名';

  @override
  String get pinRequiredForChange => '設定変更にはPINが必要です';

  @override
  String get change => '変更';

  @override
  String get myDevices => 'マイデバイス';

  @override
  String get connectedDevices => '接続中のデバイス';

  @override
  String get noDeviceConnected => '接続中のデバイスなし';

  @override
  String get displayResolution => '画面更新レート';

  @override
  String get displayResolutionDescription => 'チャート画面の更新速度';

  @override
  String get outputRate => '出力周波数';

  @override
  String get outputRateDescription => 'センサー出力周波数';

  @override
  String get tapToChange => 'タップして変更';

  @override
  String get connectDeviceFirst => '先にデバイスを接続してください';

  @override
  String outputRateChanged(Object rate) {
    return '出力周波数が$rate Hzに変更されました';
  }

  @override
  String get noiseFilter => 'ノイズフィルター';

  @override
  String get noiseFilterDescription => 'ノイズ低減のためのソフトウェアフィルター';

  @override
  String get filterStrength => 'フィルター強度';

  @override
  String get filterStrengthDescription => '値が大きいほどより滑らかに表示';

  @override
  String get atmosphericCalibrating => '大気圧測定中...';

  @override
  String get atmosphericRecalibrate => '大気圧の再測定';

  @override
  String get atmosphericKeepSensorStill => 'センサーを大気中に静かに置いてください';

  @override
  String secondsRemaining(int seconds) {
    return '残り$seconds秒';
  }

  @override
  String get selectFile => 'ファイル選択';

  @override
  String get backToFileList => 'ファイル一覧へ';

  @override
  String get readyToInstall => 'インストール準備完了';

  @override
  String get verificationFailed => '検証失敗';

  @override
  String get reset => 'リセット';

  @override
  String get fullscreen => '全画面';

  @override
  String get waitingForData => 'データ待機中...';

  @override
  String get overrangeWarningTitle => '測定範囲超過！';

  @override
  String get overrangeWarningMessage =>
      'センサーの測定範囲を超えました。強く吹いたり吸い込んだりしないでください！センサーが回復中です...';

  @override
  String get usbMidiDevicesTitle => 'USB MIDIデバイス';

  @override
  String get connectViaCable => 'USBケーブルで圧力センサーを接続してください';

  @override
  String get noUsbDevicesFound => 'USBデバイスが見つかりません';

  @override
  String get connectDeviceViaCable => 'USBケーブルでデバイスを接続してください';

  @override
  String get diveCheckerCompatible => 'DiveChecker互換';

  @override
  String scanFailedError(String error) {
    return '検索失敗: $error';
  }

  @override
  String connectionErrorWithMessage(String error) {
    return '接続エラー: $error';
  }

  @override
  String get noFirmwareFilesFound => 'ファームウェアファイルが見つかりません';

  @override
  String get lookingForFirmwareFiles => '*.bin または *_signed.bin ファイルを探しています';

  @override
  String get deviceNotConnectedError => 'デバイスが接続されていません';

  @override
  String get signatureValid => '署名確認済み ✓';

  @override
  String get signatureInvalid => '署名確認失敗 ✗';

  @override
  String get firmwareUntrustedWarning =>
      'このファームウェアは有効なキーで署名されていません。破損しているか、信頼できないソースで作成された可能性があります。';

  @override
  String verifiedFirmwareSaved(String filename) {
    return '検証済みファームウェアを保存: $filename';
  }

  @override
  String get calibrationTimedOut => 'キャリブレーションタイムアウト — センサーデータが不十分です';

  @override
  String get loading => '読み込み中...';

  @override
  String failedToSaveSession(String error) {
    return 'セッションの保存に失敗しました: $error';
  }

  @override
  String failedToDeleteSession(String error) {
    return 'セッションの削除に失敗しました: $error';
  }

  @override
  String failedToLoadSessionData(String error) {
    return 'セッションデータの読み込みに失敗しました: $error';
  }
}
