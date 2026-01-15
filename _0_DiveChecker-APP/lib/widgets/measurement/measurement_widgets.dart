// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xxl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadii.xlAll,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(Opacities.mediumHigh),
          width: ChartDimensions.lineWidthSmall,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(Opacities.light),
            blurRadius: Shadows.blurLarge,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.sensors_rounded,
                size: IconSizes.sm,
                color: theme.colorScheme.primary,
              ),
              Spacing.horizontalSm,
              Text(
                l10n.liveSensorData,
                style: TextStyle(
                  fontSize: FontSizes.bodySm,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
                  letterSpacing: LetterSpacings.widest,
                ),
              ),
              const Spacer(),
              if (isRecording) _RecordingBadge(),
            ],
          ),
          Spacing.verticalXl,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: Spacing.xxl, horizontal: Spacing.xl),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(Opacities.faint),
              borderRadius: BorderRadii.mdAll,
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(Opacities.low),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  formatPressure(pressure),
                  style: TextStyle(
                    fontSize: FontSizes.displayXl,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    letterSpacing: -3,
                    fontFamily: 'monospace',
                    height: 1,
                  ),
                ),
                Spacing.horizontalLg,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'hPa',
                      style: TextStyle(
                        fontSize: FontSizes.title,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withOpacity(Opacities.veryHigh),
                        letterSpacing: LetterSpacings.normal,
                      ),
                    ),
                    Spacing.verticalXxs,
                    Text(
                      'pressure',
                      style: TextStyle(
                        fontSize: FontSizes.bodySm,
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: LetterSpacings.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        color: theme.colorScheme.error.withOpacity(Opacities.mediumLow),
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
        border: Border.all(color: color.withOpacity(Opacities.mediumHigh), width: ChartDimensions.strokeSmMedium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(Opacities.veryLow),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: IconSizes.md),
          ),
          Spacing.verticalMd,
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.xs,
              color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
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
                  color: color.withOpacity(Opacities.veryHigh),
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
  final List<FlSpot> data;
  final double minX;
  final double maxX;

  const PressureChart({
    super.key,
    required this.data,
    required this.minX,
    required this.maxX,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadii.xlAll,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(Opacities.mediumHigh),
          width: ChartDimensions.lineWidthSmall,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChartHeader(sampleCount: data.length),
          Spacing.verticalLg,
          Builder(
            builder: (context) {
              final screenHeight = MediaQuery.of(context).size.height;
              final chartHeight = (screenHeight * 0.30).clamp(200.0, 400.0);
              return Container(
                height: chartHeight,
                padding: const EdgeInsets.only(
                  top: Spacing.sm,
                  bottom: Spacing.sm,
                  left: Spacing.sm,
                  right: Spacing.xl,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(Opacities.subtle),
                  borderRadius: BorderRadii.mdAll,
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(Opacities.low),
                  ),
                ),
                child: data.isEmpty
                    ? _EmptyChartPlaceholder()
                    : _buildChart(context),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final theme = Theme.of(context);

    return LineChart(
      LineChartData(
        clipData: FlClipData.all(),
        minX: minX,
        maxX: maxX,
        minY: -10,
        maxY: 25,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: ChartDimensions.intervalSmall,
          verticalInterval: ChartDimensions.intervalLarge,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade500, strokeWidth: ChartDimensions.strokeThin),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.grey.shade400, strokeWidth: ChartDimensions.strokeThin),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: ChartDimensions.reservedSizeXxl,
              interval: ChartDimensions.intervalSmall,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: FontSizes.xxs,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            axisNameWidget: Padding(
              padding: const EdgeInsets.only(right: Spacing.sm),
              child: Text(
                'hPa',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: FontSizes.xxs,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: ChartDimensions.reservedSizeMd,
              interval: ChartDimensions.intervalLarge,
              getTitlesWidget: (value, meta) {
                final timeInSeconds = (value * 0.001).toStringAsFixed(0);
                return Padding(
                  padding: const EdgeInsets.only(top: Spacing.xs),
                  child: Text(
                    '${timeInSeconds}s',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: FontSizes.xxs,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300, width: ChartDimensions.strokeNormal),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: false,
            color: theme.colorScheme.primary,
            barWidth: ChartDimensions.barWidthSmall,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: ChartDimensions.dotRadiusSmall,
                  color: theme.colorScheme.primary,
                  strokeWidth: ChartDimensions.strokeNormal,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(Opacities.medium),
                  theme.colorScheme.primary.withOpacity(Opacities.subtle),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0,
              color: Colors.red.shade400,
              strokeWidth: ChartDimensions.strokeSmMedium,
              dashArray: ChartDimensions.dashShort,
            ),
          ],
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final timeInSeconds = (spot.x * 0.001).toStringAsFixed(2);
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} hPa\n${timeInSeconds}s',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSizes.bodySm,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

class _ChartHeader extends StatelessWidget {
  final int sampleCount;

  const _ChartHeader({required this.sampleCount});

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
            color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
            letterSpacing: LetterSpacings.widest,
          ),
        ),
        const Spacer(),
        if (sampleCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(Opacities.mediumLow),
              borderRadius: BorderRadii.xsAll,
            ),
            child: Text(
              l10n.sampleCount(sampleCount),
              style: TextStyle(
                fontSize: FontSizes.xs,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
                letterSpacing: LetterSpacings.normal,
              ),
            ),
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
            color: theme.colorScheme.outline.withOpacity(Opacities.high),
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
            ? theme.colorScheme.secondary.withOpacity(Opacities.veryLow)
            : theme.colorScheme.error.withOpacity(Opacities.veryLow),
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
                shadowColor: theme.colorScheme.primary.withOpacity(Opacities.high),
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
                      color: Colors.white.withOpacity(Opacities.low),
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
