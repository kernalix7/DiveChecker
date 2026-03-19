// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/measurement_controller.dart';
import '../utils/chart_utils.dart' as chart_utils;
import '../utils/formatters.dart';

class FullscreenMeasurementChart extends StatefulWidget {
  final MeasurementController controller;

  const FullscreenMeasurementChart({
    super.key,
    required this.controller,
  });

  @override
  State<FullscreenMeasurementChart> createState() =>
      _FullscreenMeasurementChartState();
}

class _FullscreenMeasurementChartState
    extends State<FullscreenMeasurementChart> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final state = widget.controller.state;

          return SafeArea(
            child: Stack(
              children: [
                // Full chart
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Spacing.xl,
                      bottom: Spacing.md,
                      left: Spacing.md,
                      right: Spacing.xl,
                    ),
                    child: state.pressureData.isEmpty
                        ? _buildEmptyPlaceholder(theme, l10n)
                        : RepaintBoundary(
                            child: _buildChart(context, state),
                          ),
                  ),
                ),

                // Top-left: pressure + stats overlay
                Positioned(
                  top: Spacing.md,
                  left: Spacing.lg,
                  child: _buildStatsOverlay(theme, l10n, state),
                ),

                // Top-right: close button
                Positioned(
                  top: Spacing.sm,
                  right: Spacing.sm,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.fullscreen_exit),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          theme.colorScheme.surface.withValues(alpha: Opacities.high),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    iconSize: IconSizes.lg,
                  ),
                ),

                // Recording indicator
                if (state.isMeasuring)
                  Positioned(
                    bottom: Spacing.md,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: ScoreColors.poor.withValues(alpha: Opacities.low),
                          borderRadius: BorderRadii.smAll,
                          border: Border.all(
                            color:
                                ScoreColors.poor.withValues(alpha: Opacities.medium),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: WidgetSizes.minSize,
                              height: WidgetSizes.minSize,
                              decoration: const BoxDecoration(
                                color: ScoreColors.poor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Spacing.horizontalSm,
                            Text(
                              '${l10n.recording}  ${formatDuration(widget.controller.actualDurationSeconds)}',
                              style: TextStyle(
                                fontSize: FontSizes.bodySm,
                                fontWeight: FontWeight.bold,
                                color: ScoreColors.poor,
                                letterSpacing: LetterSpacings.wide,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsOverlay(
    ThemeData theme,
    AppLocalizations l10n,
    MeasurementState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: Opacities.veryHigh),
        borderRadius: BorderRadii.mdAll,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: Opacities.low),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sensors_rounded,
            size: IconSizes.sm,
            color: theme.colorScheme.primary,
          ),
          Spacing.horizontalSm,
          Text(
            formatPressure(state.currentPressure),
            style: TextStyle(
              fontSize: FontSizes.xl,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              fontFamily: 'monospace',
            ),
          ),
          Spacing.horizontalXs,
          Text(
            'hPa',
            style: TextStyle(
              fontSize: FontSizes.bodySm,
              color: theme.colorScheme.onSurface.withValues(alpha: Opacities.high),
            ),
          ),
          if (state.isMeasuring && state.pressureData.isNotEmpty) ...[
            _statDivider(theme),
            _statItem(l10n.peak, formatPressure(state.maxPressure),
                ScoreColors.poor),
            _statDivider(theme),
            _statItem(l10n.average, formatPressure(state.avgPressure),
                ScoreColors.excellent),
          ],
        ],
      ),
    );
  }

  Widget _statDivider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: Container(
        width: 1,
        height: 20,
        color: theme.colorScheme.outline.withValues(alpha: Opacities.medium),
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label ',
          style: TextStyle(
            fontSize: FontSizes.xs,
            color: color.withValues(alpha: Opacities.high),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: FontSizes.bodyMd,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPlaceholder(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart_rounded,
            size: IconSizes.xHuge,
            color: theme.colorScheme.outline.withValues(alpha: Opacities.high),
          ),
          Spacing.verticalMd,
          Text(
            l10n.awaitingData,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: FontSizes.bodyMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, MeasurementState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final visibleSpots = state.pressureData
        .where((p) => p.x >= state.minX && p.x <= state.maxX)
        .map((p) => FlSpot(p.x, p.y))
        .toList();

    final yRange = _calcYRange(visibleSpots);
    final minY = yRange.minY;
    final maxY = yRange.maxY;
    final yInterval = _calcYInterval(minY, maxY);
    final xInterval = chart_utils.calculateXAxisInterval(
      rangeMs: state.maxX - state.minX,
      sampleRate: widget.controller.outputRate,
    );

    return LineChart(
      LineChartData(
        clipData: FlClipData.all(),
        minX: state.minX,
        maxX: state.maxX,
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: yInterval,
          verticalInterval: xInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark
                ? theme.colorScheme.outline.withValues(alpha: Opacities.high)
                : theme.colorScheme.outline.withValues(alpha: Opacities.veryHigh),
            strokeWidth: ChartDimensions.strokeThin,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: isDark
                ? theme.colorScheme.outline.withValues(alpha: Opacities.moderate)
                : theme.colorScheme.outline.withValues(alpha: Opacities.strong),
            strokeWidth: ChartDimensions.strokeThin,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: ChartDimensions.reservedSizeMax,
              interval: yInterval,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: Spacing.sm),
                child: Text(
                  '${value.toInt()}',
                  style: TextStyle(
                    fontSize: FontSizes.xxs,
                    color: theme.colorScheme.onSurface,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: ChartDimensions.reservedSizeLarge,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                if (value <= state.minX || value >= state.maxX) {
                  return const SizedBox.shrink();
                }
                final seconds = value / 1000.0;
                return Padding(
                  padding: const EdgeInsets.only(top: Spacing.sm),
                  child: Text(
                    chart_utils.formatTimeLabel(seconds),
                    style: TextStyle(
                      fontSize: FontSizes.xs,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: isDark
                ? theme.colorScheme.outline.withValues(alpha: Opacities.mediumHigh)
                : theme.colorScheme.outline.withValues(alpha: Opacities.high),
            width: ChartDimensions.strokeSmMedium,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: visibleSpots,
            isCurved: true,
            curveSmoothness: 0.15,
            preventCurveOverShooting: true,
            color: theme.colorScheme.primary,
            barWidth: ChartDimensions.barWidthSmThin,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0,
              color: ScoreColors.poor.withValues(alpha: Opacities.high),
              strokeWidth: ChartDimensions.strokeSmMedium,
              dashArray: ChartDimensions.dashShort,
            ),
          ],
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
            tooltipRoundedRadius: BorderRadii.xs,
            getTooltipColor: (spot) => theme
                .colorScheme.surfaceContainerHighest
                .withValues(alpha: Opacities.veryHigh),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final seconds = (spot.x / 1000.0).toStringAsFixed(1);
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(2)} hPa\n${seconds}s',
                  TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: FontSizes.xs,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
      duration: Duration.zero,
    );
  }

  ({double minY, double maxY}) _calcYRange(List<FlSpot> spots) {
    if (spots.isEmpty) return (minY: -5, maxY: 10);
    double minVal = spots[0].y;
    double maxVal = spots[0].y;
    for (var i = 1; i < spots.length; i++) {
      final y = spots[i].y;
      if (y < minVal) minVal = y;
      if (y > maxVal) maxVal = y;
    }
    return (
      minY: (minVal - 2).floorToDouble().clamp(-50, 0),
      maxY: (maxVal + 2).ceilToDouble().clamp(5, 200),
    );
  }

  double _calcYInterval(double minY, double maxY) {
    final range = maxY - minY;
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    if (range <= 20) return 2;
    if (range <= 30) return 5;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    return 20;
  }
}
