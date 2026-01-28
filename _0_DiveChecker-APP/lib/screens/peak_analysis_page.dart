// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/chart_point.dart';
import '../providers/settings_provider.dart';
import '../utils/peak_analyzer.dart';
import '../widgets/analysis/analysis_type_tabs.dart';
import '../widgets/analysis/analysis_widgets.dart';
import '../widgets/analysis/intensity_distribution.dart';
import '../widgets/analysis/overall_grade_card.dart';
import '../widgets/analysis/pattern_recognition_view.dart';
import '../widgets/analysis/segment_analysis_view.dart';
import '../widgets/analysis/statistics_dashboard.dart';
import '../widgets/analysis/trend_graph_view.dart';

// Re-export AnalysisType from analysis_type_tabs.dart
export '../widgets/analysis/analysis_type_tabs.dart' show AnalysisType;

/// 고급 분석 페이지
/// 기록에서 분석 버튼 클릭 시 이동
class PeakAnalysisPage extends StatefulWidget {
  final List<ChartPoint> chartData;
  final Map<String, dynamic> session;

  const PeakAnalysisPage({
    super.key,
    required this.chartData,
    required this.session,
  });

  @override
  State<PeakAnalysisPage> createState() => _PeakAnalysisPageState();
}

class _PeakAnalysisPageState extends State<PeakAnalysisPage> {
  PeakAnalysisResult? _analysisResult;
  bool _isLoading = true;
  AnalysisType _selectedType = AnalysisType.peak;

  // 피크 선택 상태 (인덱스 -> 선택 여부)
  Map<int, bool> _peakSelections = {};

  // 선택된 피크만으로 계산된 결과
  PeakAnalysisResult? _filteredResult;

  @override
  void initState() {
    super.initState();
    _analyzeData();
  }

  void _analyzeData() {
    final analyzer = PeakAnalyzer();
    final result = analyzer.analyze(widget.chartData);

    // 모든 피크 기본 선택
    final selections = <int, bool>{};
    for (int i = 0; i < result.peaks.length; i++) {
      selections[i] = true;
    }

    setState(() {
      _analysisResult = result;
      _peakSelections = selections;
      _filteredResult = result;
      _isLoading = false;
    });
  }

  /// Helper to convert ChartPoint list to FlSpot list
  List<FlSpot> _toFlSpots(List<ChartPoint> points) {
    return points.map((p) => FlSpot(p.x, p.y)).toList();
  }

  /// 선택된 피크로 결과 재계산
  void _recalculateWithSelectedPeaks() {
    if (_analysisResult == null) return;

    final selectedPeaks = <ChartPoint>[];
    final selectedDetails = <PeakDetail>[];
    for (int i = 0; i < _analysisResult!.peaks.length; i++) {
      if (_peakSelections[i] == true) {
        selectedPeaks.add(_analysisResult!.peaks[i]);
        if (i < _analysisResult!.peakDetails.length) {
          selectedDetails.add(_analysisResult!.peakDetails[i]);
        }
      }
    }

    setState(() {
      _filteredResult = recalculateWithSelectedPeaks(
        selectedPeaks: selectedPeaks,
        selectedDetails: selectedDetails,
        chartData: widget.chartData,
        originalFatigueIndex: _analysisResult!.fatigueIndex,
        originalStabilityTrend: _analysisResult!.stabilityTrend,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.advancedAnalysis), elevation: Elevations.none),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                AnalysisTypeTabs(
                  selectedType: _selectedType,
                  onTypeChanged: (type) => setState(() => _selectedType = type),
                ),
                Expanded(child: _buildSelectedAnalysis(l10n)),
              ],
            ),
    );
  }

  /// 선택된 분석 유형에 따른 뷰 빌드
  Widget _buildSelectedAnalysis(AppLocalizations l10n) {
    final theme = Theme.of(context);
    switch (_selectedType) {
      case AnalysisType.peak:
        if (_analysisResult == null || _analysisResult!.peaks.isEmpty) {
          return _buildNoDataView(l10n, theme);
        }
        return _buildPeakAnalysisView(l10n, theme);
      case AnalysisType.statistics:
        return StatisticsDashboard(
          chartData: widget.chartData,
          analysisResult: _analysisResult,
          l10n: l10n,
        );
      case AnalysisType.segment:
        return SegmentAnalysisView(
          chartData: widget.chartData,
          analysisResult: _analysisResult,
          l10n: l10n,
        );
      case AnalysisType.trend:
        return TrendGraphView(
          chartData: widget.chartData,
          l10n: l10n,
        );
      case AnalysisType.pattern:
        return PatternRecognitionView(
          analysisResult: _analysisResult,
          filteredResult: _filteredResult,
          l10n: l10n,
        );
    }
  }

  Widget _buildNoDataView(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: IconSizes.xxl,
            color: theme.colorScheme.outline,
          ),
          Spacing.verticalMd,
          Text(
            l10n.noData,
            style: TextStyle(
              fontSize: FontSizes.lg,
              color: theme.colorScheme.outline,
            ),
          ),
          Spacing.verticalSm,
          Text(
            l10n.noPeaksDetected,
            style: TextStyle(
              fontSize: FontSizes.sm,
              color: theme.colorScheme.outline.withOpacity(Opacities.medium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeakAnalysisView(AppLocalizations l10n, ThemeData theme) {
    final result = _filteredResult ?? _analysisResult!;
    final allPeaks = _analysisResult!.peaks;
    final selectedCount = _peakSelections.values.where((v) => v).length;

    return SingleChildScrollView(
      padding: Spacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 종합 등급 표시
          OverallGradeCard(result: result),
          Spacing.verticalMd,

          // 피크 그래프
          _buildPeakChart(theme, l10n),
          Spacing.verticalLg,

          // 피크 선택 섹션
          _buildPeakSelectionHeader(l10n, allPeaks.length, selectedCount),
          Spacing.verticalSm,

          // 피크 상세 리스트
          _buildDetailedPeakList(result, allPeaks, theme, l10n),
          Spacing.verticalLg,

          // 주요 지표
          _buildSectionTitle(l10n.keyMetricsWithPeaks(l10n.keyMetrics, selectedCount)),
          Spacing.verticalSm,
          _buildMetricsGrid(result, theme, l10n),
          Spacing.verticalLg,

          // 피크 강도 분포
          _buildSectionTitle(l10n.peakIntensityDistribution),
          Spacing.verticalSm,
          IntensityDistribution(result: result),
          Spacing.verticalLg,

          // 세부 점수 카드
          _buildSectionTitle(l10n.performanceScores),
          Spacing.verticalSm,
          _buildScoreCards(result, theme, l10n),
          Spacing.verticalLg,

          // 안정성 추세
          _buildStabilityTrendCard(result, theme, l10n),
          Spacing.verticalLg,

          // 상세 통계
          _buildSectionTitle(l10n.detailedStats),
          Spacing.verticalSm,
          _buildDetailedStatsCard(result, theme, l10n),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: FontSizes.lg,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPeakSelectionHeader(AppLocalizations l10n, int totalPeaks, int selectedCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${l10n.detectedPeaks} ($selectedCount/$totalPeaks)',
          style: const TextStyle(
            fontSize: FontSizes.lg,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  for (var key in _peakSelections.keys) {
                    _peakSelections[key] = true;
                  }
                });
                _recalculateWithSelectedPeaks();
              },
              icon: const Icon(Icons.select_all, size: IconSizes.sm),
              label: Text(l10n.selectAll),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            Spacing.horizontalXxs,
            TextButton.icon(
              onPressed: () {
                setState(() {
                  for (var key in _peakSelections.keys) {
                    _peakSelections[key] = false;
                  }
                });
                _recalculateWithSelectedPeaks();
              },
              icon: const Icon(Icons.deselect, size: IconSizes.sm),
              label: Text(l10n.deselectAll),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(PeakAnalysisResult result, ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCompactMetricCard(
              icon: Icons.numbers, label: l10n.totalPeaks,
              value: '${result.peaks.length}', unit: l10n.peaksUnit, theme: theme,
            )),
            Spacing.horizontalSm,
            Expanded(child: _buildCompactMetricCard(
              icon: Icons.speed, label: l10n.peakFrequency,
              value: result.frequencyPerMinute.toStringAsFixed(1), unit: l10n.perMinute, theme: theme,
            )),
            Spacing.horizontalSm,
            Expanded(child: _buildCompactMetricCard(
              icon: Icons.timer, label: l10n.avgPeakInterval,
              value: result.averagePeakInterval.toStringAsFixed(1), unit: l10n.sec, theme: theme,
            )),
            Spacing.horizontalSm,
            Expanded(child: Builder(
              builder: (context) {
                final settings = context.watch<SettingsProvider>();
                return _buildCompactMetricCard(
                  icon: Icons.compress, label: l10n.avgPeakPressure,
                  value: settings.convertPressure(result.averagePeakPressure).toStringAsFixed(0), unit: settings.pressureUnitSymbol, theme: theme,
                );
              },
            )),
          ],
        ),
        Spacing.verticalSm,
        Row(
          children: [
            Expanded(child: _buildCompactMetricCard(
              icon: Icons.trending_up, label: l10n.avgRiseTime,
              value: result.avgRiseTime.toStringAsFixed(2), unit: l10n.sec, theme: theme,
            )),
            Spacing.horizontalSm,
            Expanded(child: _buildCompactMetricCard(
              icon: Icons.trending_down, label: l10n.avgFallTime,
              value: result.avgFallTime.toStringAsFixed(2), unit: l10n.sec, theme: theme,
            )),
            Spacing.horizontalSm,
            Expanded(child: _buildCompactMetricCard(
              icon: Icons.unfold_more, label: l10n.avgPeakWidth,
              value: result.avgPeakWidth.toStringAsFixed(2), unit: l10n.sec, theme: theme,
            )),
            Spacing.horizontalSm,
            Expanded(child: _buildCompactMetricCard(
              icon: Icons.warning_amber, label: l10n.outliers,
              value: '${result.outlierIndices.length}', unit: l10n.peaksUnit, theme: theme,
              isWarning: result.outlierIndices.isNotEmpty,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreCards(PeakAnalysisResult result, ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMiniScoreCard(
              title: l10n.rhythmScore, score: result.rhythmScore,
              icon: Icons.music_note, theme: theme, l10n: l10n,
            )),
            Spacing.horizontalSm,
            Expanded(child: _buildMiniScoreCard(
              title: l10n.pressureScoreTitle, score: result.pressureScore,
              icon: Icons.compress, theme: theme, l10n: l10n,
            )),
          ],
        ),
        Spacing.verticalSm,
        Row(
          children: [
            Expanded(child: _buildMiniScoreCard(
              title: l10n.techniqueScore, score: result.techniqueScore,
              icon: Icons.sports_gymnastics, theme: theme, l10n: l10n,
            )),
            Spacing.horizontalSm,
            Expanded(child: _buildMiniScoreCard(
              title: l10n.fatigueResistance, score: 100 - result.fatigueIndex,
              icon: Icons.battery_charging_full, theme: theme, l10n: l10n,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedStatsCard(PeakAnalysisResult result, ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: Padding(
        padding: Spacing.cardPadding,
        child: Builder(
          builder: (context) {
            final settings = context.watch<SettingsProvider>();
            final unit = settings.pressureUnitSymbol;
            return Column(
              children: [
                StatRow(label: l10n.maxPeakPressure, value: '${settings.convertPressure(result.maxPeakPressure).toStringAsFixed(1)} $unit'),
                const Divider(),
                StatRow(label: l10n.minPeakPressure, value: '${settings.convertPressure(result.minPeakPressure).toStringAsFixed(1)} $unit'),
                const Divider(),
                StatRow(label: l10n.pressureRange, value: '${settings.convertPressure(result.maxPeakPressure - result.minPeakPressure).toStringAsFixed(1)} $unit'),
                const Divider(),
                StatRow(label: l10n.strongPeaks, value: _formatPeakCount(result.strongPeakCount, result.peaks.length, l10n)),
                const Divider(),
                StatRow(label: l10n.moderatePeaks, value: _formatPeakCount(result.moderatePeakCount, result.peaks.length, l10n)),
                const Divider(),
                StatRow(label: l10n.weakPeaks, value: _formatPeakCount(result.weakPeakCount, result.peaks.length, l10n)),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatPeakCount(int count, int total, AppLocalizations l10n) {
    final percent = total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';
    return '$count${l10n.countUnitItems} ($percent%)';
  }

  // ========== 피크 차트 ==========

  Widget _buildPeakChart(ThemeData theme, AppLocalizations l10n) {
    if (widget.chartData.isEmpty) return const SizedBox();

    final minY = widget.chartData.map((e) => e.y).reduce(min) - 10;
    final maxY = widget.chartData.map((e) => e.y).reduce(max) + 10;

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: Padding(
        padding: Spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.show_chart, size: IconSizes.md),
                Spacing.horizontalSm,
                Text(
                  l10n.peakVisualization,
                  style: const TextStyle(
                    fontSize: FontSizes.md,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Spacing.verticalSm,
            Row(
              children: [
                _buildLegendItem(theme.colorScheme.primary, l10n.pressureWaveform),
                Spacing.horizontalSm,
                _buildLegendItem(ScoreColors.excellent, l10n.selected),
                Spacing.horizontalSm,
                _buildLegendItem(Colors.grey, l10n.excluded),
              ],
            ),
            Spacing.verticalMd,
            Builder(
              builder: (context) {
                final screenHeight = MediaQuery.of(context).size.height;
                final chartHeight = (screenHeight * 0.22).clamp(160.0, 320.0);
                return SizedBox(
                  height: chartHeight,
                  child: RepaintBoundary(
                    child: LineChart(
                      LineChartData(
                        minY: minY,
                        maxY: maxY,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: ChartDimensions.intervalMedium,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: theme.colorScheme.outline.withOpacity(Opacities.low),
                            strokeWidth: ChartDimensions.strokeNormal,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: ChartDimensions.reservedSizeXxxl,
                              getTitlesWidget: (value, meta) => Text(
                                '${value.toInt()}',
                                style: TextStyle(
                                  fontSize: FontSizes.xs,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: ChartDimensions.reservedSizeSmall,
                              getTitlesWidget: (value, meta) => Text(
                                '${(value / 100).toStringAsFixed(0)}s',
                                style: TextStyle(
                                  fontSize: FontSizes.xs,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _toFlSpots(widget.chartData),
                            isCurved: false,
                            color: theme.colorScheme.primary,
                            barWidth: ChartDimensions.barWidthSmall,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        lineTouchData: const LineTouchData(enabled: false),
                        extraLinesData: ExtraLinesData(
                          verticalLines: List.generate(
                            _analysisResult!.peaks.length,
                            (index) {
                              final peak = _analysisResult!.peaks[index];
                              final isSelected = _peakSelections[index] ?? true;
                              return VerticalLine(
                                x: peak.x,
                                color: isSelected
                                    ? ScoreColors.excellent.withOpacity(Opacities.medium)
                                    : Colors.grey.withOpacity(Opacities.mediumHigh),
                                strokeWidth: isSelected ? 2 : 1,
                                dashArray: isSelected ? null : [4, 4],
                                label: VerticalLineLabel(
                                  show: true,
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.only(bottom: Spacing.xxs),
                                  style: TextStyle(
                                    fontSize: FontSizes.xs,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? ScoreColors.excellent : Colors.grey,
                                  ),
                                  labelResolver: (line) => '${index + 1}',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      duration: Duration.zero,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: WidgetSizes.containerSmall,
          height: WidgetSizes.containerSmall,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadii.xsAll,
          ),
        ),
        Spacing.horizontalXxs,
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.sm,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  // ========== 피크 상세 리스트 ==========

  Widget _buildDetailedPeakList(
    PeakAnalysisResult result,
    List<ChartPoint> allPeaks,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final originalDetails = _analysisResult!.peakDetails;

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: WidgetSizes.maxHeightCard),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: Spacing.xxs),
          itemCount: allPeaks.length,
          itemBuilder: (context, index) {
            final peak = allPeaks[index];
            final isSelected = _peakSelections[index] ?? true;
            final timeInSeconds = peak.x * 0.25;

            PeakDetail? detail;
            if (index < originalDetails.length) {
              detail = originalDetails[index];
            }

            final isOutlier = result.outlierIndices.contains(index);

            return _buildPeakListItem(
              index: index,
              peak: peak,
              detail: detail,
              timeInSeconds: timeInSeconds,
              isSelected: isSelected,
              isOutlier: isOutlier,
              theme: theme,
              l10n: l10n,
              settings: context.watch<SettingsProvider>(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeakListItem({
    required int index,
    required ChartPoint peak,
    required PeakDetail? detail,
    required double timeInSeconds,
    required bool isSelected,
    required bool isOutlier,
    required ThemeData theme,
    required AppLocalizations l10n,
    required SettingsProvider settings,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xxs),
      decoration: BoxDecoration(
        color: isOutlier
            ? ScoreColors.warning.withOpacity(Opacities.low)
            : (isSelected ? null : theme.colorScheme.outline.withOpacity(Opacities.veryLow)),
        borderRadius: BorderRadii.smAll,
        border: isOutlier
            ? Border.all(color: ScoreColors.warning.withOpacity(Opacities.mediumHigh))
            : null,
      ),
      child: CheckboxListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
        value: isSelected,
        onChanged: (value) {
          setState(() {
            _peakSelections[index] = value ?? true;
          });
          _recalculateWithSelectedPeaks();
        },
        title: Row(
          children: [
            // 피크 번호 + 강도 배지
            Container(
              width: WidgetSizes.containerLarge,
              height: WidgetSizes.containerLarge,
              decoration: BoxDecoration(
                color: _getIntensityColor(detail?.intensity ?? 'moderate'),
                borderRadius: BorderRadii.mdAll,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: FontSizes.xs,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacing.horizontalSm,
            // 시간 및 압력
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.secondsValue(timeInSeconds.toStringAsFixed(2)),
                    style: TextStyle(
                      fontSize: FontSizes.sm,
                      color: isSelected ? null : theme.colorScheme.outline,
                    ),
                  ),
                  Text(
                    '${settings.convertPressure(peak.y).toStringAsFixed(0)} ${settings.pressureUnitSymbol}',
                    style: TextStyle(
                      fontSize: FontSizes.sm,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? _getIntensityColor(detail?.intensity ?? 'moderate')
                          : theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            // 상세 정보
            if (detail != null)
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildPeakMiniStat('↑${detail.riseTime.toStringAsFixed(2)}s'),
                    Spacing.horizontalXxs,
                    _buildPeakMiniStat('↓${detail.fallTime.toStringAsFixed(2)}s'),
                    Spacing.horizontalSm,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.xsPlus, vertical: Spacing.xxs),
                      decoration: BoxDecoration(
                        color: ScoreColors.fromScore(detail.qualityScore).withOpacity(Opacities.mediumLow),
                        borderRadius: BorderRadii.smAll,
                      ),
                      child: Text(
                        l10n.scorePoints(detail.qualityScore.toStringAsFixed(0)),
                        style: TextStyle(
                          fontSize: FontSizes.xs,
                          fontWeight: FontWeight.bold,
                          color: ScoreColors.fromScore(detail.qualityScore),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (isOutlier)
              Padding(
                padding: EdgeInsets.only(left: Spacing.xxs),
                child: Icon(
                  Icons.warning_amber,
                  size: IconSizes.sm,
                  color: ScoreColors.warning,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeakMiniStat(String value) {
    return Text(
      value,
      style: TextStyle(fontSize: FontSizes.xs, color: Colors.grey[600]),
    );
  }

  // ========== 안정성 추세 카드 ==========

  Widget _buildStabilityTrendCard(
    PeakAnalysisResult result,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final trend = result.stabilityTrend;
    final isImproving = trend > 5;
    final isDeclining = trend < -5;

    IconData trendIcon;
    Color trendColor;
    String trendText;

    if (isImproving) {
      trendIcon = Icons.trending_up;
      trendColor = ScoreColors.excellent;
      trendText = l10n.stabilityImproving;
    } else if (isDeclining) {
      trendIcon = Icons.trending_down;
      trendColor = ScoreColors.warning;
      trendText = l10n.stabilityDecreasing;
    } else {
      trendIcon = Icons.trending_flat;
      trendColor = ScoreColors.good;
      trendText = l10n.stabilityMaintained;
    }

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: trendColor.withOpacity(Opacities.mediumHigh)),
      ),
      color: trendColor.withOpacity(Opacities.veryLow),
      child: Padding(
        padding: Spacing.cardPadding,
        child: Row(
          children: [
            Icon(trendIcon, size: IconSizes.lg, color: trendColor),
            Spacing.horizontalSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.stabilityTrend,
                    style: TextStyle(
                      fontSize: FontSizes.sm,
                      color: theme.colorScheme.onSurface.withOpacity(Opacities.medium),
                    ),
                  ),
                  Text(
                    trendText,
                    style: TextStyle(
                      fontSize: FontSizes.md,
                      fontWeight: FontWeight.bold,
                      color: trendColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xsPlus),
              decoration: BoxDecoration(
                color: trendColor.withOpacity(Opacities.mediumLow),
                borderRadius: BorderRadii.xxlAll,
              ),
              child: Text(
                '${trend > 0 ? '+' : ''}${trend.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: FontSizes.sm,
                  fontWeight: FontWeight.bold,
                  color: trendColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== 미니 점수 카드 ==========

  Widget _buildMiniScoreCard({
    required String title,
    required double score,
    required IconData icon,
    required ThemeData theme,
    required AppLocalizations l10n,
  }) {
    final color = ScoreColors.fromScore(score);
    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.sm),
        child: Row(
          children: [
            Icon(icon, size: IconSizes.md, color: color),
            Spacing.horizontalSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: FontSizes.xs,
                      color: theme.colorScheme.onSurface.withOpacity(Opacities.medium),
                    ),
                  ),
                  Text(
                    l10n.scorePoints(score.toStringAsFixed(0)),
                    style: TextStyle(
                      fontSize: FontSizes.lg,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: WidgetSizes.containerHuge,
              height: WidgetSizes.containerHuge,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: ChartDimensions.strokeThick,
                    backgroundColor: theme.colorScheme.outline.withOpacity(Opacities.low),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                  Text(
                    ScoreColors.gradeLabel(score),
                    style: TextStyle(
                      fontSize: FontSizes.sm,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== 컴팩트 메트릭 카드 ==========

  Widget _buildCompactMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required ThemeData theme,
    bool isWarning = false,
  }) {
    final cardColor = isWarning ? ScoreColors.warning : theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.smPlus),
      decoration: BoxDecoration(
        borderRadius: BorderRadii.smAll,
        border: Border.all(
          color: isWarning
              ? ScoreColors.warning.withOpacity(Opacities.high)
              : theme.colorScheme.outline.withOpacity(Opacities.low),
        ),
        color: isWarning ? ScoreColors.warning.withOpacity(Opacities.veryLow) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: IconSizes.sm, color: cardColor),
          Spacing.verticalXxs,
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizes.md,
              fontWeight: FontWeight.bold,
              color: isWarning ? ScoreColors.warning : null,
            ),
          ),
          Text(
            unit,
            style: TextStyle(fontSize: FontSizes.xxs, color: theme.colorScheme.outline),
          ),
          Spacing.verticalXxs,
          Text(
            label,
            style: TextStyle(fontSize: FontSizes.xxs, color: theme.colorScheme.outline),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ========== Helper Methods ==========

  Color _getIntensityColor(String intensity) {
    switch (intensity) {
      case 'weak':
        return ScoreColors.warning;
      case 'strong':
        return ScoreColors.excellent;
      default:
        return ScoreColors.good;
    }
  }
}
