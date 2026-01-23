// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../models/chart_point.dart';
import '../../utils/peak_analyzer.dart';
import 'analysis_widgets.dart';

class SegmentAnalysisView extends StatelessWidget {
  final List<ChartPoint> chartData;
  final PeakAnalysisResult? analysisResult;
  final AppLocalizations l10n;

  const SegmentAnalysisView({
    super.key,
    required this.chartData,
    required this.analysisResult,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return NoDataView(
        title: l10n.noData,
        message: l10n.noPeaksDetected,
      );
    }

    final totalDuration = (chartData.last.x - chartData.first.x) / 1000.0;
    final segmentCount = min(
      4,
      max(2, (totalDuration / 5).ceil()),
    );
    final segmentDuration = totalDuration / segmentCount;

    final segments = <Map<String, dynamic>>[];
    for (int i = 0; i < segmentCount; i++) {
      final startTime = chartData.first.x + (i * segmentDuration * 1000.0);
      final endTime = startTime + (segmentDuration * 1000.0);

      final segmentData =
          chartData.where((p) => p.x >= startTime && p.x < endTime).toList();
      if (segmentData.isEmpty) continue;

      final values = segmentData.map((e) => e.y).toList();
      final avgPressure = values.reduce((a, b) => a + b) / values.length;
      final maxPressure = values.reduce(max);
      final minPressure = values.reduce(min);

      final segmentPeaks = analysisResult?.peaks
              .where((p) => p.x >= startTime && p.x < endTime)
              .length ??
          0;

      final variance =
          values.map((v) => pow(v - avgPressure, 2)).reduce((a, b) => a + b) /
              values.length;
      final stdDev = sqrt(variance);

      segments.add({
        'index': i + 1,
        'startTime': startTime / 1000.0,
        'endTime': endTime / 1000.0,
        'avgPressure': avgPressure,
        'maxPressure': maxPressure,
        'minPressure': minPressure,
        'peakCount': segmentPeaks,
        'stdDev': stdDev,
        'dataPoints': values.length,
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.segmentAvgPressureComparison,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,
          _SegmentComparisonChart(segments: segments, l10n: l10n),
          Spacing.verticalXl,

          Text(
            l10n.segmentDetailedAnalysis,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,

          ...segments.map(
            (segment) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: _SegmentCard(
                segment: segment,
                allSegments: segments,
                l10n: l10n,
              ),
            ),
          ),

          Spacing.verticalXl,

          Text(
            l10n.segmentChangeAnalysis,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,
          _SegmentChangeAnalysis(segments: segments, l10n: l10n),
        ],
      ),
    );
  }
}

class _SegmentComparisonChart extends StatelessWidget {
  final List<Map<String, dynamic>> segments;
  final AppLocalizations l10n;

  const _SegmentComparisonChart({
    required this.segments,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox();

    final theme = Theme.of(context);
    final maxAvg =
        segments.map((s) => (s['avgPressure'] as num).toDouble()).reduce(max);

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Builder(
          builder: (context) {
            final screenHeight = MediaQuery.of(context).size.height;
            final chartHeight = (screenHeight * 0.2).clamp(150.0, 300.0);

            return SizedBox(
              height: chartHeight,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxAvg * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final segment = segments[groupIndex];
                        return BarTooltipItem(
                          l10n.segmentTooltip(
                            segment['index'],
                            (segment['avgPressure'] as num)
                                .toDouble()
                                .toStringAsFixed(1),
                            segment['peakCount'],
                          ),
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
                          final index = value.toInt();
                          if (index >= 0 && index < segments.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: Spacing.sm),
                              child: Text(
                                l10n.segmentNumber(segments[index]['index']),
                                style: TextStyle(
                                  fontSize: FontSizes.xxs,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: ChartDimensions.reservedSizeMedium,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: ChartDimensions.reservedSizeXl,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: FontSizes.xxs,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outline.withOpacity(Opacities.low),
                      strokeWidth: ChartDimensions.strokeNormal,
                    ),
                  ),
                  barGroups: segments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final segment = entry.value;
                    final avgPressure =
                        (segment['avgPressure'] as num).toDouble();

                    final colors = [
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                    ];

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: avgPressure,
                          color: colors[index % colors.length],
                          width: WidgetSizes.containerXl,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(BorderRadii.sm),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SegmentCard extends StatelessWidget {
  final Map<String, dynamic> segment;
  final List<Map<String, dynamic>> allSegments;
  final AppLocalizations l10n;

  const _SegmentCard({
    required this.segment,
    required this.allSegments,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = [ScoreColors.intermediate, ScoreColors.excellent, ScoreColors.good, Colors.purple];
    final segmentIndex = segment['index'] as int;
    final color = colors[(segmentIndex - 1) % colors.length];

    final overallAvg = allSegments
            .map((s) => (s['avgPressure'] as num).toDouble())
            .reduce((a, b) => a + b) /
        allSegments.length;
    final diff = ((segment['avgPressure'] as num).toDouble() - overallAvg);
    final diffPercent = (diff / overallAvg * 100).abs();

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: color.withOpacity(Opacities.high), width: ChartDimensions.strokeSmMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.smPlus,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadii.lgAll,
                  ),
                  child: Text(
                    l10n.segmentNumber(segment['index']),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSizes.body,
                    ),
                  ),
                ),
                Spacing.horizontalSm,
                Text(
                  '${(segment['startTime'] as num).toDouble().toStringAsFixed(1)}s - ${(segment['endTime'] as num).toDouble().toStringAsFixed(1)}s',
                  style: TextStyle(
                    color: theme.colorScheme.outline,
                    fontSize: FontSizes.body,
                  ),
                ),
                const Spacer(),
                Icon(
                  diff >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: IconSizes.sm,
                  color: diff >= 0 ? ScoreColors.excellent : ScoreColors.poor,
                ),
                Text(
                  '${diffPercent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: diff >= 0 ? ScoreColors.excellent : ScoreColors.poor,
                    fontWeight: FontWeight.w600,
                    fontSize: FontSizes.body,
                  ),
                ),
              ],
            ),
            Spacing.verticalMd,
            Row(
              children: [
                Expanded(
                  child: MiniStatWidget(
                    label: l10n.avgLabel,
                    value:
                        '${(segment['avgPressure'] as num).toDouble().toStringAsFixed(1)}',
                    unit: 'hPa',
                  ),
                ),
                Expanded(
                  child: MiniStatWidget(
                    label: l10n.maxLabel,
                    value:
                        '${(segment['maxPressure'] as num).toDouble().toStringAsFixed(1)}',
                    unit: 'hPa',
                  ),
                ),
                Expanded(
                  child: MiniStatWidget(
                    label: l10n.peakLabel,
                    value: '${segment['peakCount']}',
                    unit: l10n.countUnit,
                  ),
                ),
                Expanded(
                  child: MiniStatWidget(
                    label: l10n.variabilityLabel,
                    value:
                        '${(segment['stdDev'] as num).toDouble().toStringAsFixed(1)}',
                    unit: 'σ',
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

class _SegmentChangeAnalysis extends StatelessWidget {
  final List<Map<String, dynamic>> segments;
  final AppLocalizations l10n;

  const _SegmentChangeAnalysis({
    required this.segments,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (segments.length < 2) {
      return Card(
        elevation: Elevations.none,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Text(
            l10n.notEnoughSegments,
            style: TextStyle(color: theme.colorScheme.outline),
          ),
        ),
      );
    }

    final firstAvg = (segments.first['avgPressure'] as num).toDouble();
    final lastAvg = (segments.last['avgPressure'] as num).toDouble();
    final change = ((lastAvg - firstAvg) / firstAvg * 100);

    final firstPeaks = segments.first['peakCount'] as int;
    final lastPeaks = segments.last['peakCount'] as int;

    String performanceAnalysis;
    IconData performanceIcon;
    Color performanceColor;

    if (change.abs() < 5) {
      performanceAnalysis = l10n.stablePressureAnalysis;
      performanceIcon = Icons.check_circle;
      performanceColor = ScoreColors.stable;
    } else if (change > 0) {
      performanceAnalysis = l10n.pressureIncreaseAnalysis(
        change.abs().toStringAsFixed(1),
      );
      performanceIcon = Icons.trending_up;
      performanceColor = ScoreColors.increasing;
    } else {
      performanceAnalysis = l10n.pressureDecreaseAnalysis(
        change.abs().toStringAsFixed(1),
      );
      performanceIcon = Icons.trending_down;
      performanceColor = ScoreColors.decreasing;
    }

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.medium)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(performanceIcon, color: performanceColor, size: IconSizes.lg),
                Spacing.horizontalSm,
                Text(
                  change.abs() < 5
                      ? l10n.trendStable
                      : (change > 0 ? l10n.trendRising : l10n.trendFalling),
                  style: TextStyle(
                    fontSize: FontSizes.titleSm,
                    fontWeight: FontWeight.bold,
                    color: performanceColor,
                  ),
                ),
              ],
            ),
            Spacing.verticalMd,
            Text(performanceAnalysis, style: const TextStyle(fontSize: FontSizes.body)),
            Spacing.verticalLg,
            const Divider(),
            Spacing.verticalMd,
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        l10n.firstToLast,
                        style: TextStyle(
                          fontSize: FontSizes.xs,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Spacing.verticalXs,
                      Text(
                        '${firstAvg.toStringAsFixed(0)} → ${lastAvg.toStringAsFixed(0)} hPa',
                        style: AppTextStyles.semiBold,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        l10n.peakCountChange,
                        style: TextStyle(
                          fontSize: FontSizes.xs,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Spacing.verticalXs,
                      Text(
                        '$firstPeaks → $lastPeaks ${l10n.countUnit}',
                        style: AppTextStyles.semiBold,
                      ),
                    ],
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
