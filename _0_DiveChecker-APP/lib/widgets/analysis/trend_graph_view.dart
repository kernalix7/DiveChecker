// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../models/chart_point.dart';
import 'analysis_widgets.dart';

class TrendGraphView extends StatelessWidget {
  final List<ChartPoint> chartData;
  final AppLocalizations l10n;

  const TrendGraphView({
    super.key,
    required this.chartData,
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

    final movingAverage = <ChartPoint>[];
    const windowSize = 5;
    for (int i = windowSize; i < chartData.length; i++) {
      final window = chartData.sublist(i - windowSize, i);
      final avg = window.map((e) => e.y).reduce((a, b) => a + b) / windowSize;
      movingAverage.add(ChartPoint(chartData[i].x, avg));
    }

    final n = chartData.length;
    final sumX = chartData.map((e) => e.x).reduce((a, b) => a + b);
    final sumY = chartData.map((e) => e.y).reduce((a, b) => a + b);
    final sumXY = chartData.map((e) => e.x * e.y).reduce((a, b) => a + b);
    final sumX2 = chartData.map((e) => e.x * e.x).reduce((a, b) => a + b);

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    final intercept = (sumY - slope * sumX) / n;

    final trendLine = [
      ChartPoint(
        chartData.first.x,
        slope * chartData.first.x + intercept,
      ),
      ChartPoint(
        chartData.last.x,
        slope * chartData.last.x + intercept,
      ),
    ];

    // 기울기 해석
    final trendDirection = slope > 0.01
        ? l10n.trendRising2
        : (slope < -0.01 ? l10n.trendFalling2 : l10n.trendMaintained);
    final trendColor =
        slope > 0.01 ? ScoreColors.excellent : (slope < -0.01 ? ScoreColors.poor : Colors.blue);

    final minY = chartData.map((e) => e.y).reduce(min) - 10;
    final maxY = chartData.map((e) => e.y).reduce(max) + 10;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TrendSummaryCard(
            slope: slope,
            trendDirection: trendDirection,
            trendColor: trendColor,
            l10n: l10n,
          ),
          Spacing.verticalXl,

          Text(
            l10n.pressureTrendGraph,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalSm,
          Row(
            children: [
              ChartLegendItem(
                color: theme.colorScheme.primary.withOpacity(Opacities.mediumHigh),
                label: l10n.originalData,
              ),
              Spacing.horizontalMd,
              ChartLegendItem(
                color: ScoreColors.warning,
                label: l10n.movingAverage,
              ),
              Spacing.horizontalMd,
              ChartLegendItem(
                color: trendColor,
                label: l10n.trendLine,
              ),
            ],
          ),
          Spacing.verticalMd,

          _TrendChart(
            chartData: chartData,
            movingAverage: movingAverage,
            trendLine: trendLine,
            trendColor: trendColor,
            minY: minY,
            maxY: maxY,
          ),
          Spacing.verticalXl,

          Text(
            l10n.trendAnalysis,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,

          _TrendStatsCard(trendLine: trendLine, l10n: l10n),
          Spacing.verticalXl,

          _TrendInterpretation(slope: slope, l10n: l10n),
        ],
      ),
    );
  }
}

class _TrendSummaryCard extends StatelessWidget {
  final double slope;
  final String trendDirection;
  final Color trendColor;
  final AppLocalizations l10n;

  const _TrendSummaryCard({
    required this.slope,
    required this.trendDirection,
    required this.trendColor,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: Elevations.none,
      color: trendColor.withOpacity(Opacities.veryLow),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: trendColor.withOpacity(Opacities.mediumHigh)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Row(
          children: [
            Icon(
              slope > 0.01
                  ? Icons.trending_up
                  : (slope < -0.01 ? Icons.trending_down : Icons.trending_flat),
              color: trendColor,
              size: IconSizes.xxl + IconSizes.sm,
            ),
            Spacing.horizontalLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.overallTrend(trendDirection),
                    style: TextStyle(
                      fontSize: FontSizes.title,
                      fontWeight: FontWeight.bold,
                      color: trendColor,
                    ),
                  ),
                  Spacing.verticalXs,
                  Text(
                    l10n.slopeLabel((slope * 100).toStringAsFixed(3)),
                    style: TextStyle(
                      fontSize: FontSizes.bodyMd,
                      color: theme.colorScheme.outline,
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
}

class _TrendChart extends StatelessWidget {
  final List<ChartPoint> chartData;
  final List<ChartPoint> movingAverage;
  final List<ChartPoint> trendLine;
  final Color trendColor;
  final double minY;
  final double maxY;

  const _TrendChart({
    required this.chartData,
    required this.movingAverage,
    required this.trendLine,
    required this.trendColor,
    required this.minY,
    required this.maxY,
  });

  List<FlSpot> _toFlSpots(List<ChartPoint> points) {
    return points.map((p) => FlSpot(p.x, p.y)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(Opacities.low),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Builder(
          builder: (context) {
            final screenHeight = MediaQuery.of(context).size.height;
            final chartHeight = (screenHeight * 0.25).clamp(200.0, 400.0);

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
                              fontSize: FontSizes.xxs,
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
                            '${(value / 1000.0).toStringAsFixed(0)}s',
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
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _toFlSpots(chartData),
                        isCurved: false,
                        color: theme.colorScheme.primary.withOpacity(Opacities.mediumHigh),
                        barWidth: ChartDimensions.barWidthThin,
                        dotData: const FlDotData(show: false),
                      ),
                      if (movingAverage.isNotEmpty)
                        LineChartBarData(
                          spots: _toFlSpots(movingAverage),
                          isCurved: false,
                          color: Colors.orange,
                          barWidth: ChartDimensions.barWidthSmall,
                          dotData: const FlDotData(show: false),
                        ),
                      LineChartBarData(
                        spots: _toFlSpots(trendLine),
                        isCurved: false,
                        color: trendColor,
                        barWidth: ChartDimensions.barWidthMedium,
                        dotData: const FlDotData(show: false),
                        dashArray: ChartDimensions.dashLong,
                      ),
                    ],
                  ),
                  duration: Duration.zero,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TrendStatsCard extends StatelessWidget {
  final List<ChartPoint> trendLine;
  final AppLocalizations l10n;

  const _TrendStatsCard({
    required this.trendLine,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(Opacities.low),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            StatRow(
              label: l10n.startPressureTrend,
              value: '${trendLine.first.y.toStringAsFixed(1)} hPa',
            ),
            const Divider(),
            StatRow(
              label: l10n.endPressureTrend,
              value: '${trendLine.last.y.toStringAsFixed(1)} hPa',
            ),
            const Divider(),
            StatRow(
              label: l10n.changeAmount,
              value:
                  '${(trendLine.last.y - trendLine.first.y).toStringAsFixed(1)} hPa',
            ),
            const Divider(),
            StatRow(
              label: l10n.changeRate,
              value:
                  '${((trendLine.last.y - trendLine.first.y) / trendLine.first.y * 100).toStringAsFixed(1)}%',
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendInterpretation extends StatelessWidget {
  final double slope;
  final AppLocalizations l10n;

  const _TrendInterpretation({
    required this.slope,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String description;
    IconData icon;
    Color color;

    if (slope > 0.05) {
      title = l10n.strongRisingTrend;
      description = l10n.strongRisingDesc;
      icon = Icons.rocket_launch;
      color = ScoreColors.excellent;
    } else if (slope > 0.01) {
      title = l10n.moderateRisingTrend;
      description = l10n.moderateRisingDesc;
      icon = Icons.trending_up;
      color = ScoreColors.excellentLight;
    } else if (slope > -0.01) {
      title = l10n.stableMaintained;
      description = l10n.stableMaintainedDesc;
      icon = Icons.balance;
      color = Colors.blue;
    } else if (slope > -0.05) {
      title = l10n.moderateFallingTrend;
      description = l10n.moderateFallingDesc;
      icon = Icons.trending_down;
      color = ScoreColors.warning;
    } else {
      title = l10n.strongFallingTrend;
      description = l10n.strongFallingDesc;
      icon = Icons.warning;
      color = ScoreColors.poor;
    }

    return Card(
      elevation: Elevations.none,
      color: color.withOpacity(Opacities.veryLow),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: color.withOpacity(Opacities.mediumHigh)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: IconSizes.lg),
                Spacing.horizontalSm,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FontSizes.titleSm,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Spacing.verticalMd,
            Text(description, style: const TextStyle(fontSize: FontSizes.bodyLg)),
          ],
        ),
      ),
    );
  }
}
