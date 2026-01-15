// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/peak_analyzer.dart';
import 'analysis_widgets.dart';

/// 통계 대시보드 뷰 위젯
class StatisticsDashboard extends StatelessWidget {
  final List<FlSpot> chartData;
  final PeakAnalysisResult? analysisResult;
  final AppLocalizations l10n;

  const StatisticsDashboard({
    super.key,
    required this.chartData,
    required this.analysisResult,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (chartData.isEmpty) {
      return NoDataView(
        title: l10n.noData,
        message: l10n.noPeaksDetected,
      );
    }

    // 전체 데이터 통계 계산
    final values = chartData.map((e) => e.y).toList();
    final count = values.length;
    final mean = values.reduce((a, b) => a + b) / count;
    final maxVal = values.reduce(max);
    final minVal = values.reduce(min);
    final range = maxVal - minVal;

    // 표준편차
    final variance =
        values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / count;
    final stdDev = sqrt(variance);

    // 변동계수 (CV)
    final cv = mean != 0 ? (stdDev / mean * 100) : 0.0;

    // 왜도 (Skewness) - 분포의 비대칭성
    final skewness = count > 2
        ? values.map((v) => pow((v - mean) / stdDev, 3)).reduce((a, b) => a + b) / count
        : 0.0;

    // 첨도 (Kurtosis) - 분포의 뾰족함
    final kurtosis = count > 3
        ? (values.map((v) => pow((v - mean) / stdDev, 4)).reduce((a, b) => a + b) / count) - 3
        : 0.0;

    // 백분위수 계산
    final sorted = List<double>.from(values)..sort();
    final p10 = sorted[(count * 0.10).floor()];
    final p25 = sorted[(count * 0.25).floor()];
    final p50 = sorted[(count * 0.50).floor()]; // 중앙값
    final p75 = sorted[(count * 0.75).floor()];
    final p90 = sorted[(count * 0.90).floor()];
    final iqr = p75 - p25; // 사분위 범위

    // 이상치 감지 (IQR 방법)
    final lowerBound = p25 - 1.5 * iqr;
    final upperBound = p75 + 1.5 * iqr;
    final outlierCount =
        values.where((v) => v < lowerBound || v > upperBound).length;
    final outlierPct = count > 0 ? (outlierCount / count * 100) : 0.0;

    // 측정 시간
    final durationSeconds =
        chartData.isNotEmpty ? (chartData.last.x - chartData.first.x) / 100 : 0.0;

    // 샘플링 레이트
    final samplingRate = durationSeconds > 0 ? count / durationSeconds : 0.0;

    // 데이터 품질 점수 계산
    final qualityScore = _calculateDataQualityScore(cv, outlierPct, samplingRate, count);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 데이터 품질 카드
          _DataQualityCard(
            score: qualityScore,
            outlierCount: outlierCount,
            totalCount: count,
            samplingRate: samplingRate,
            l10n: l10n,
          ),
          Spacing.verticalLg,

          // 압력 분포 그래프
          Text(
            l10n.pressureDistribution,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,
          _DistributionChart(values: values, minVal: minVal, maxVal: maxVal, l10n: l10n),
          Spacing.verticalSm,
          // 분포 해석
          _DistributionInterpretation(skewness: skewness, kurtosis: kurtosis, l10n: l10n),
          Spacing.verticalXl,

          // 기본 통계
          Text(
            l10n.basicStats,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,

          Row(
            children: [
              Expanded(
                child: CompactMetricCard(
                  icon: Icons.data_array,
                  label: l10n.dataPointsLabel,
                  value: count.toString(),
                  unit: l10n.countUnitItems,
                ),
              ),
              Spacing.horizontalSm,
              Expanded(
                child: CompactMetricCard(
                  icon: Icons.timer,
                  label: l10n.measurementTime,
                  value: durationSeconds.toStringAsFixed(1),
                  unit: l10n.sec,
                ),
              ),
              Spacing.horizontalSm,
              Expanded(
                child: CompactMetricCard(
                  icon: Icons.analytics,
                  label: l10n.avgPressure,
                  value: mean.toStringAsFixed(1),
                  unit: 'hPa',
                ),
              ),
              Spacing.horizontalSm,
              Expanded(
                child: CompactMetricCard(
                  icon: Icons.show_chart,
                  label: l10n.standardDeviation,
                  value: stdDev.toStringAsFixed(1),
                  unit: 'hPa',
                ),
              ),
            ],
          ),
          Spacing.verticalXl,

          // 고급 통계
          Text(
            l10n.advancedStats,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,

          Row(
            children: [
              Expanded(
                child: _AdvancedStatCard(
                  title: l10n.coefficientOfVariation,
                  value: cv.toStringAsFixed(1),
                  unit: '%',
                  description: _getCvDescription(cv, l10n),
                  icon: Icons.swap_vert,
                ),
              ),
              Spacing.horizontalMd,
              Expanded(
                child: _AdvancedStatCard(
                  title: l10n.skewness,
                  value: skewness.toStringAsFixed(2),
                  unit: '',
                  description: _getSkewnessDescription(skewness, l10n),
                  icon: Icons.align_horizontal_left,
                ),
              ),
            ],
          ),
          Spacing.verticalMd,
          Row(
            children: [
              Expanded(
                child: _AdvancedStatCard(
                  title: l10n.kurtosis,
                  value: kurtosis.toStringAsFixed(2),
                  unit: '',
                  description: _getKurtosisDescription(kurtosis, l10n),
                  icon: Icons.stacked_line_chart,
                ),
              ),
              Spacing.horizontalMd,
              Expanded(
                child: _AdvancedStatCard(
                  title: l10n.interquartileRange,
                  value: iqr.toStringAsFixed(1),
                  unit: 'hPa',
                  description: l10n.dataDispersionIndicator,
                  icon: Icons.expand,
                ),
              ),
            ],
          ),
          Spacing.verticalXl,

          // 압력 범위
          Text(
            l10n.pressureRangeLabel,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,

          Card(
            elevation: Elevations.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadii.mdAll,
              side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                children: [
                  StatRow(label: l10n.maxPressure, value: '${maxVal.toStringAsFixed(1)} hPa'),
                  const Divider(),
                  StatRow(label: l10n.minPressureLabel, value: '${minVal.toStringAsFixed(1)} hPa'),
                  const Divider(),
                  StatRow(label: l10n.rangeLabel, value: '${range.toStringAsFixed(1)} hPa'),
                  const Divider(),
                  StatRow(
                    label: l10n.outliersLabel,
                    value: '$outlierCount${l10n.countUnitItems} (${outlierPct.toStringAsFixed(1)}%)',
                  ),
                ],
              ),
            ),
          ),
          Spacing.verticalXl,

          // 백분위수
          Text(
            l10n.percentiles,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,

          _PercentileChart(
            p10: p10,
            p25: p25,
            p50: p50,
            p75: p75,
            p90: p90,
            minVal: minVal,
            maxVal: maxVal,
            l10n: l10n,
          ),
          Spacing.verticalMd,

          Card(
            elevation: Elevations.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadii.mdAll,
              side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                children: [
                  StatRow(label: '10th percentile', value: '${p10.toStringAsFixed(1)} hPa'),
                  const Divider(),
                  StatRow(label: '25th percentile', value: '${p25.toStringAsFixed(1)} hPa'),
                  const Divider(),
                  StatRow(label: l10n.median50, value: '${p50.toStringAsFixed(1)} hPa'),
                  const Divider(),
                  StatRow(label: '75th percentile', value: '${p75.toStringAsFixed(1)} hPa'),
                  const Divider(),
                  StatRow(label: '90th percentile', value: '${p90.toStringAsFixed(1)} hPa'),
                ],
              ),
            ),
          ),
          Spacing.verticalXl,

          // 피크 요약 (있는 경우)
          if (analysisResult != null && analysisResult!.peaks.isNotEmpty) ...[
            Text(
              l10n.peakSummary,
              style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
            ),
            Spacing.verticalMd,
            Card(
              elevation: Elevations.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadii.mdAll,
                side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  children: [
                    StatRow(
                      label: l10n.totalPeaks,
                      value: '${analysisResult!.peaks.length} ${l10n.peaksUnit}',
                    ),
                    const Divider(),
                    StatRow(
                      label: l10n.peakFrequency,
                      value: '${analysisResult!.frequencyPerMinute.toStringAsFixed(1)} ${l10n.perMinute}',
                    ),
                    const Divider(),
                    StatRow(
                      label: l10n.avgPeakInterval,
                      value: '${analysisResult!.averagePeakInterval.toStringAsFixed(2)} ${l10n.sec}',
                    ),
                    const Divider(),
                    StatRow(
                      label: l10n.strongPeakRatio,
                      value:
                          '${analysisResult!.peaks.isNotEmpty ? (analysisResult!.strongPeakCount / analysisResult!.peaks.length * 100).toStringAsFixed(0) : 0}%',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _calculateDataQualityScore(
    double cv,
    double outlierPct,
    double samplingRate,
    int count,
  ) {
    double score = 100.0;

    // 변동계수 패널티 (높을수록 나쁨)
    if (cv > 50) {
      score -= 20;
    } else if (cv > 30) {
      score -= 10;
    } else if (cv > 20) {
      score -= 5;
    }

    // 이상치 비율 패널티
    score -= outlierPct * 2;

    // 샘플링 레이트 보너스/패널티
    if (samplingRate >= 90) {
      score += 5;
    } else if (samplingRate < 50) {
      score -= 10;
    }

    // 데이터 양 보너스/패널티
    if (count < 100) {
      score -= 15;
    } else if (count < 500) {
      score -= 5;
    } else if (count > 2000) {
      score += 5;
    }

    return score.clamp(0.0, 100.0);
  }

  String _getCvDescription(double cv, AppLocalizations l10n) {
    if (cv < 15) return l10n.veryConsistent;
    if (cv < 25) return l10n.consistent;
    if (cv < 35) return l10n.averageVariation;
    return l10n.highVariation;
  }

  String _getSkewnessDescription(double skewness, AppLocalizations l10n) {
    if (skewness < -0.5) return l10n.leftSkewed;
    if (skewness > 0.5) return l10n.rightSkewed;
    return l10n.symmetricDistribution;
  }

  String _getKurtosisDescription(double kurtosis, AppLocalizations l10n) {
    if (kurtosis < -0.5) return l10n.flatDistribution;
    if (kurtosis > 0.5) return l10n.peakedDistribution;
    return l10n.normalDistribution;
  }
}

/// 데이터 품질 카드
class _DataQualityCard extends StatelessWidget {
  final double score;
  final int outlierCount;
  final int totalCount;
  final double samplingRate;
  final AppLocalizations l10n;

  const _DataQualityCard({
    required this.score,
    required this.outlierCount,
    required this.totalCount,
    required this.samplingRate,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = ScoreColors.fromScore(score);
    final qualityLabel = score >= 80
        ? l10n.excellent
        : score >= 60
            ? l10n.satisfactory
            : score >= 40
                ? l10n.averageVariation
                : l10n.caution;

    return Card(
      elevation: Elevations.low,
      shape: RoundedRectangleBorder(borderRadius: BorderRadii.lgAll),
      color: color.withOpacity(Opacities.veryLow),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Row(
          children: [
            // 점수 원형
            Container(
              width: Dimensions.scoreCircleLg,
              height: Dimensions.scoreCircleLg,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    score.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: FontSizes.headline,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    qualityLabel,
                    style: const TextStyle(fontSize: FontSizes.tiny, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Spacing.horizontalLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dataQuality,
                    style: TextStyle(
                      fontSize: FontSizes.bodySm,
                      color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
                    ),
                  ),
                  Spacing.verticalXs,
                  Row(
                    children: [
                      _QualityIndicator(
                        icon: Icons.scatter_plot,
                        label: l10n.outliersLabel,
                        value: '$outlierCount${l10n.countUnitItems}',
                        color: outlierCount == 0 ? ScoreColors.excellent : ScoreColors.warning,
                      ),
                      Spacing.horizontalLg,
                      _QualityIndicator(
                        icon: Icons.speed,
                        label: l10n.samplingLabel,
                        value: '${samplingRate.toStringAsFixed(0)}Hz',
                        color: samplingRate >= 80 ? ScoreColors.excellent : ScoreColors.warning,
                      ),
                      Spacing.horizontalLg,
                      _QualityIndicator(
                        icon: Icons.data_array,
                        label: l10n.dataLabel,
                        value: '$totalCount',
                        color: totalCount >= 500 ? ScoreColors.excellent : ScoreColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QualityIndicator({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: IconSizes.md, color: color),
        Text(
          value,
          style: TextStyle(
            fontSize: FontSizes.bodySm,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: FontSizes.tiny, color: theme.colorScheme.outline),
        ),
      ],
    );
  }
}

/// 고급 통계 카드
class _AdvancedStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String description;
  final IconData icon;

  const _AdvancedStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: IconSizes.sm, color: theme.colorScheme.primary),
                Spacing.horizontalSm,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FontSizes.body,
                    color: theme.colorScheme.onSurface.withOpacity(Opacities.veryHigh),
                  ),
                ),
              ],
            ),
            Spacing.verticalSm,
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: FontSizes.titleLg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  Spacing.horizontalXs,
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: FontSizes.bodySm,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
            Spacing.verticalXs,
            Text(
              description,
              style: TextStyle(fontSize: FontSizes.sm, color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

/// 분포 차트
class _DistributionChart extends StatelessWidget {
  final List<double> values;
  final double minVal;
  final double maxVal;
  final AppLocalizations l10n;

  const _DistributionChart({
    required this.values,
    required this.minVal,
    required this.maxVal,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final range = maxVal - minVal;
    const binCount = 10;
    final binSize = range / binCount;
    final bins = List<int>.filled(binCount, 0);

    for (final v in values) {
      final binIndex = ((v - minVal) / binSize).floor().clamp(0, binCount - 1);
      bins[binIndex]++;
    }

    final maxBin = bins.reduce(max);

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: SizedBox(
          height: WidgetSizes.histogramHeight,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxBin.toDouble() * 1.1,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final start = minVal + groupIndex * binSize;
                    final end = start + binSize;
                    return BarTooltipItem(
                      '${start.toStringAsFixed(0)}-${end.toStringAsFixed(0)}\n${bins[groupIndex]}개',
                      TextStyle(
                        color: theme.colorScheme.onInverseSurface,
                        fontSize: FontSizes.xs,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() % 2 == 0) {
                        final val = minVal + value.toInt() * binSize;
                        return Padding(
                          padding: const EdgeInsets.only(top: Spacing.sm),
                          child: Text(
                            val.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: FontSizes.xxs,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: ChartDimensions.reservedSizeSmall,
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              barGroups: bins.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      color: theme.colorScheme.primary.withOpacity(Opacities.veryHigh),
                      width: ChartDimensions.barWidthLarge,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(BorderRadii.xs)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// 분포 해석 위젯
class _DistributionInterpretation extends StatelessWidget {
  final double skewness;
  final double kurtosis;
  final AppLocalizations l10n;

  const _DistributionInterpretation({
    required this.skewness,
    required this.kurtosis,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String interpretation;
    IconData icon;
    Color color;

    if (skewness.abs() < 0.5 && kurtosis.abs() < 0.5) {
      interpretation = l10n.normalPressureInterpretation;
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (skewness > 0.5) {
      interpretation = l10n.highPressureInterpretation;
      icon = Icons.info;
      color = Colors.orange;
    } else if (skewness < -0.5) {
      interpretation = l10n.lowPressureInterpretation;
      icon = Icons.info;
      color = Colors.blue;
    } else if (kurtosis > 0.5) {
      interpretation = l10n.concentratedInterpretation;
      icon = Icons.check_circle;
      color = Colors.green;
    } else {
      interpretation = l10n.dispersedInterpretation;
      icon = Icons.warning;
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(Opacities.veryLow),
        borderRadius: BorderRadii.mdAll,
        border: Border.all(color: color.withOpacity(Opacities.mediumHigh)),
      ),
      child: Row(
        children: [
          Icon(icon, size: IconSizes.md, color: color),
          Spacing.horizontalMd,
          Expanded(
            child: Text(
              interpretation,
              style: TextStyle(
                fontSize: FontSizes.body,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 백분위수 차트
class _PercentileChart extends StatelessWidget {
  final double p10;
  final double p25;
  final double p50;
  final double p75;
  final double p90;
  final double minVal;
  final double maxVal;
  final AppLocalizations l10n;

  const _PercentileChart({
    required this.p10,
    required this.p25,
    required this.p50,
    required this.p75,
    required this.p90,
    required this.minVal,
    required this.maxVal,
    required this.l10n,
  });

  double _normalize(double val) {
    final range = maxVal - minVal;
    if (range == 0) return 0;
    return (val - minVal) / range;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final range = maxVal - minVal;

    if (range == 0) return const SizedBox.shrink();

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            // 박스플롯 시각화
            SizedBox(
              height: WidgetSizes.boxplotHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth * 0.9;
                  return Stack(
                    children: [
                      // 전체 범위 라인
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 28,
                        child: Container(
                          height: Spacing.xs,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outline.withOpacity(Opacities.mediumHigh),
                            borderRadius: BorderRadii.xsAll,
                          ),
                        ),
                      ),
                      // IQR 박스 (25%-75%)
                      Positioned(
                        left: _normalize(p25) * width,
                        width: (_normalize(p75) - _normalize(p25)) * width,
                        top: 15,
                        child: Container(
                          height: WidgetSizes.boxplotElementHeight,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(Opacities.mediumHigh),
                            borderRadius: BorderRadii.xsAll,
                            border: Border.all(color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      // 중앙값 선
                      Positioned(
                        left: _normalize(p50) * width,
                        top: 15,
                        child: Container(
                          width: ChartDimensions.lineWidthMedium,
                          height: WidgetSizes.boxplotElementHeight,
                          decoration: BoxDecoration(
                            color: ScoreColors.poor,
                            borderRadius: BorderRadius.circular(Spacing.xxs / 2),
                          ),
                        ),
                      ),
                      // 10% 마커
                      Positioned(
                        left: _normalize(p10) * width - 10,
                        top: 0,
                        child: Column(
                          children: [
                            Text(
                              '10%',
                              style: TextStyle(
                                fontSize: FontSizes.tiny,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            Container(
                              width: ChartDimensions.lineWidthSmall,
                              height: WidgetSizes.markerHeight,
                              color: theme.colorScheme.outline.withOpacity(Opacities.high),
                            ),
                          ],
                        ),
                      ),
                      // 90% 마커
                      Positioned(
                        left: _normalize(p90) * width - 10,
                        top: 0,
                        child: Column(
                          children: [
                            Text(
                              '90%',
                              style: TextStyle(
                                fontSize: FontSizes.tiny,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            Container(
                              width: ChartDimensions.lineWidthSmall,
                              height: WidgetSizes.markerHeight,
                              color: theme.colorScheme.outline.withOpacity(Opacities.high),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Spacing.verticalSm,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${minVal.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: FontSizes.sm,
                    color: theme.colorScheme.outline,
                  ),
                ),
                Text(
                  l10n.medianLabel(p50.toStringAsFixed(1)),
                  style: const TextStyle(
                    fontSize: FontSizes.bodySm,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${maxVal.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: FontSizes.sm,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
