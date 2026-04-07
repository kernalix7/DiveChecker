// Copyright (C) 2025-2026 Createch (legal@createch.kr)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../models/chart_point.dart';
import '../../utils/chart_utils.dart' as chart_utils;
import '../../utils/formatters.dart';

class PressureDisplay extends StatelessWidget {
  final double pressure;
  final bool isRecording;

  const PressureDisplay({
    super.key,
    required this.pressure,
    this.isRecording = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadii.lgAll,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: Opacities.mediumHigh),
          width: ChartDimensions.lineWidthSmall,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sensors_rounded,
            size: IconSizes.sm,
            color: theme.colorScheme.primary,
          ),
          Spacing.horizontalSm,
          Text(
            formatPressure(pressure),
            style: TextStyle(
              fontSize: FontSizes.titleLg,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: -1,
              fontFamily: 'monospace',
              height: 1,
            ),
          ),
          Spacing.horizontalSm,
          Text(
            'hPa',
            style: TextStyle(
              fontSize: FontSizes.body,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: Opacities.high),
            ),
          ),
          const Spacer(),
          if (isRecording) _RecordingBadge(),
        ],
      ),
    );
  }
}

class _RecordingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: Opacities.mediumLow),
        borderRadius: BorderRadii.xsAll,
      ),
      child: Row(
        children: [
          Container(
            width: WidgetSizes.minSize,
            height: WidgetSizes.minSize,
            decoration: BoxDecoration(
              color: theme.colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
          Spacing.horizontalSm,
          Text(
            l10n.recording,
            style: TextStyle(
              fontSize: FontSizes.xs,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
              letterSpacing: LetterSpacings.wide,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Spacing.mdPlus),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadii.mdAll,
        border: Border.all(color: color.withValues(alpha: Opacities.mediumHigh), width: ChartDimensions.strokeSmMedium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: Opacities.veryLow),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: IconSizes.md),
          ),
          Spacing.verticalMd,
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.xs,
              color: theme.colorScheme.onSurface.withValues(alpha: Opacities.high),
              fontWeight: FontWeight.bold,
              letterSpacing: LetterSpacings.wider,
            ),
          ),
          Spacing.verticalSm,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: FontSizes.headline,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: -0.5,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Spacing.horizontalXs,
              Text(
                unit,
                style: TextStyle(
                  fontSize: FontSizes.sm,
                  color: color.withValues(alpha: Opacities.veryHigh),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  final double maxPressure;
  final double avgPressure;
  final int durationSeconds;

  const StatsRow({
    super.key,
    required this.maxPressure,
    required this.avgPressure,
    required this.durationSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: l10n.peak,
            value: formatPressure(maxPressure),
            unit: 'hPa',
            icon: Icons.arrow_upward_rounded,
            color: ScoreColors.poor,
          ),
        ),
        Spacing.horizontalMd,
        Expanded(
          child: StatCard(
            label: l10n.average,
            value: formatPressure(avgPressure),
            unit: 'hPa',
            icon: Icons.trending_flat_rounded,
            color: ScoreColors.excellent,
          ),
        ),
        Spacing.horizontalMd,
        Expanded(
          child: StatCard(
            label: l10n.durationLabel,
            value: '$durationSeconds',
            unit: l10n.sec,
            icon: Icons.timer_outlined,
            color: ScoreColors.warning,
          ),
        ),
      ],
    );
  }
}

class PressureChart extends StatelessWidget {
  final List<ChartPoint> data;
  final double minX;
  final double maxX;
  final int sampleRate;
  final VoidCallback? onFullscreen;

  const PressureChart({
    super.key,
    required this.data,
    required this.minX,
    required this.maxX,
    this.sampleRate = 8,
    this.onFullscreen,
  });

  /// Filter data to visible range only
  List<FlSpot> _toVisibleFlSpots(List<ChartPoint> points) {
    return points
        .where((p) => p.x >= minX && p.x <= maxX)
        .map((p) => FlSpot(p.x, p.y))
        .toList();
  }

  /// Dynamic Y-axis min based on visible data
  double _calculateMinY(List<FlSpot> visibleSpots) {
    if (visibleSpots.isEmpty) return -5;
    final minVal = visibleSpots.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    return (minVal - 2).floorToDouble().clamp(-50, 0);
  }

  /// Dynamic Y-axis max based on visible data
  double _calculateMaxY(List<FlSpot> visibleSpots) {
    if (visibleSpots.isEmpty) return 10;
    final maxVal = visibleSpots.map((p) => p.y).reduce((a, b) => a > b ? a : b);
    return (maxVal + 2).ceilToDouble().clamp(5, 200);
  }

  /// Dynamic Y interval based on range
  double _calculateYInterval(double minY, double maxY) {
    final range = maxY - minY;
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    if (range <= 20) return 2;
    if (range <= 30) return 5;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    return 20;
  }

  /// Calculate X axis interval - delegates to shared utility
  double _calculateXInterval(double rangeMs) {
    return chart_utils.calculateXAxisInterval(
      rangeMs: rangeMs,
      sampleRate: sampleRate,
    );
  }

  /// Format time label - delegates to shared utility
  String _formatTimeLabel(double seconds) => chart_utils.formatTimeLabel(seconds);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadii.lgAll,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: Opacities.mediumHigh),
          width: ChartDimensions.lineWidthSmall,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChartHeader(onFullscreen: onFullscreen),
          Spacing.verticalSm,
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: Spacing.sm,
                bottom: Spacing.sm,
                left: Spacing.sm,
                right: Spacing.xl,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: Opacities.subtle),
                borderRadius: BorderRadii.mdAll,
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: Opacities.low),
                ),
              ),
              child: data.isEmpty
                  ? _EmptyChartPlaceholder()
                  : RepaintBoundary(child: _buildChart(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final theme = Theme.of(context);
    final xInterval = _calculateXInterval(maxX - minX);
    final isDark = theme.brightness == Brightness.dark;
    final visibleSpots = _toVisibleFlSpots(data);
    final minY = _calculateMinY(visibleSpots);
    final maxY = _calculateMaxY(visibleSpots);
    final yInterval = _calculateYInterval(minY, maxY);

    return LineChart(
      LineChartData(
        clipData: FlClipData.all(),
        minX: minX,
        maxX: maxX,
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
                    fontWeight: FontWeight.w400,
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
              interval: _calculateXInterval(maxX - minX),
              getTitlesWidget: (value, meta) {
                if (value <= minX || value >= maxX) {
                  return const SizedBox.shrink();
                }
                final seconds = (value / 1000.0);
                final timeLabel = _formatTimeLabel(seconds);
                return Padding(
                  padding: const EdgeInsets.only(top: Spacing.sm),
                  child: Text(
                    timeLabel,
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
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            getTooltipColor: (spot) => theme.colorScheme.surfaceContainerHighest.withValues(alpha: Opacities.veryHigh),
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
}

class _ChartHeader extends StatelessWidget {
  final VoidCallback? onFullscreen;

  const _ChartHeader({this.onFullscreen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Icon(
          Icons.timeline_rounded,
          size: IconSizes.sm,
          color: theme.colorScheme.primary,
        ),
        Spacing.horizontalSm,
        Text(
          l10n.pressureWaveform.toUpperCase(),
          style: TextStyle(
            fontSize: FontSizes.bodySm,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: Opacities.high),
            letterSpacing: LetterSpacings.widest,
          ),
        ),
        const Spacer(),
        if (onFullscreen != null)
          IconButton(
            onPressed: onFullscreen,
            icon: const Icon(Icons.fullscreen),
            iconSize: IconSizes.md,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: l10n.fullscreen,
            color: theme.colorScheme.onSurface.withValues(alpha: Opacities.high),
          ),
      ],
    );
  }
}

class _EmptyChartPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
              fontWeight: FontWeight.w500,
              letterSpacing: LetterSpacings.tight,
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectionStatusBanner extends StatelessWidget {
  final bool isConnected;

  const ConnectionStatusBanner({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
      decoration: BoxDecoration(
        color: isConnected
            ? theme.colorScheme.secondary.withValues(alpha: Opacities.veryLow)
            : theme.colorScheme.error.withValues(alpha: Opacities.veryLow),
        borderRadius: BorderRadii.mdAll,
        border: Border.all(
          color: isConnected
              ? theme.colorScheme.secondary
              : theme.colorScheme.error,
          width: ChartDimensions.strokeSmMedium,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.usb : Icons.usb_off,
            color: isConnected
                ? theme.colorScheme.secondary
                : theme.colorScheme.error,
            size: IconSizes.md,
          ),
          Spacing.horizontalMd,
          Expanded(
            child: Text(
              isConnected
                  ? l10n.deviceConnectedReady
                  : l10n.deviceNotConnectedShort,
              style: TextStyle(
                fontSize: FontSizes.bodyMd,
                fontWeight: FontWeight.w600,
                color: isConnected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.error,
              ),
            ),
          ),
          if (!isConnected)
            Icon(
              Icons.warning_rounded,
              color: theme.colorScheme.error,
              size: IconSizes.md,
            ),
        ],
      ),
    );
  }
}

class MeasurementControlButtons extends StatelessWidget {
  final bool isMeasuring;
  final bool isPaused;
  final VoidCallback onToggleMeasurement;
  final VoidCallback onTogglePause;

  const MeasurementControlButtons({
    super.key,
    required this.isMeasuring,
    required this.isPaused,
    required this.onToggleMeasurement,
    required this.onTogglePause,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (isMeasuring) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: Dimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: onTogglePause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPaused
                      ? theme.colorScheme.secondary
                      : ScoreColors.warning,
                  foregroundColor: Colors.white,
                  elevation: Elevations.low,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadii.mdAll,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      size: IconSizes.md,
                    ),
                    Spacing.horizontalSm,
                    Text(
                      isPaused ? l10n.resume : l10n.pause,
                      style: const TextStyle(
                        fontSize: FontSizes.bodyLg,
                        fontWeight: FontWeight.bold,
                        letterSpacing: LetterSpacings.wider,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacing.horizontalMd,
          Expanded(
            child: SizedBox(
              height: Dimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: onToggleMeasurement,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ScoreColors.poor,
                  foregroundColor: Colors.white,
                  elevation: Elevations.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadii.mdAll,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stop_rounded, size: IconSizes.md),
                    Spacing.horizontalSm,
                    Text(
                      l10n.stop,
                      style: const TextStyle(
                        fontSize: FontSizes.bodyLg,
                        fontWeight: FontWeight.bold,
                        letterSpacing: LetterSpacings.wider,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: Dimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: onToggleMeasurement,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: Elevations.low,
                shadowColor: theme.colorScheme.primary.withValues(alpha: Opacities.high),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadii.mdAll,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(Spacing.xsPlus),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: Opacities.low),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, size: IconSizes.md),
                  ),
                  Spacing.horizontalMd,
                  Text(
                    l10n.startMeasurement,
                    style: const TextStyle(
                      fontSize: FontSizes.bodyLg,
                      fontWeight: FontWeight.bold,
                      letterSpacing: LetterSpacings.wider,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacing.verticalMd,
          Text(
            l10n.tapToBeginMonitoring,
            style: TextStyle(
              fontSize: FontSizes.body,
              color: Colors.grey.shade500,
              letterSpacing: LetterSpacings.tight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }
}
