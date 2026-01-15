// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/app_constants.dart';

class ChartConstants {
  const ChartConstants._();
  
  static const double leftAxisReservedSize = 48.0;
  static const double bottomAxisReservedSize = 32.0;
  
  static const double gridStrokeWidth = 0.5;
  static const double borderStrokeWidth = 1.0;
  
  static const double lineWidth = 2.0;
  static const double baselineWidth = 1.5;
  
  static const double defaultMinY = -5.0;
  static const double defaultMaxY = 10.0;
  static const double defaultInterval = 3.0;
  static const double yPadding = 2.0;
  static const double minYFloor = -2.0;
  static const double minYCeiling = 5.0;
  
  static const double realTimeXInterval = 5000.0;  // 5 seconds
  static const double historyXInterval = 80.0;     // 10 seconds at 0.125s interval
}

class YAxisRange {
  final double minY;
  final double maxY;
  final double interval;
  
  const YAxisRange({
    required this.minY,
    required this.maxY,
    required this.interval,
  });
  
  factory YAxisRange.fromData(List<FlSpot> data, {
    double padding = ChartConstants.yPadding,
    double minFloor = ChartConstants.minYFloor,
    double minCeiling = ChartConstants.minYCeiling,
    int divisions = 5,
  }) {
    if (data.isEmpty) {
      return const YAxisRange(
        minY: ChartConstants.defaultMinY,
        maxY: ChartConstants.defaultMaxY,
        interval: ChartConstants.defaultInterval,
      );
    }
    
    final yValues = data.map((s) => s.y).toList();
    final dataMin = yValues.reduce((a, b) => a < b ? a : b);
    final dataMax = yValues.reduce((a, b) => a > b ? a : b);
    
    double minY = (dataMin - padding).floorToDouble();
    double maxY = (dataMax + padding).ceilToDouble();
    
    // Ensure minimum range
    if (minY > minFloor) minY = minFloor;
    if (maxY < minCeiling) maxY = minCeiling;
    
    // Calculate interval
    final range = maxY - minY;
    double interval = (range / divisions).ceilToDouble();
    interval = interval.clamp(1.0, 20.0);
    
    return YAxisRange(minY: minY, maxY: maxY, interval: interval);
  }
}

class ChartGridConfig {
  final double horizontalInterval;
  final double verticalInterval;
  final bool drawVerticalLine;
  final bool drawHorizontalLine;
  
  const ChartGridConfig({
    required this.horizontalInterval,
    this.verticalInterval = 2000.0,
    this.drawVerticalLine = true,
    this.drawHorizontalLine = true,
  });
  
  FlGridData toFlGridData(ThemeData theme) {
    final gridColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade400;
    
    return FlGridData(
      show: true,
      drawVerticalLine: drawVerticalLine,
      drawHorizontalLine: drawHorizontalLine,
      horizontalInterval: horizontalInterval,
      verticalInterval: verticalInterval,
      getDrawingHorizontalLine: (value) => FlLine(
        color: gridColor.withOpacity(Opacities.high),
        strokeWidth: ChartConstants.gridStrokeWidth,
      ),
      getDrawingVerticalLine: (value) => FlLine(
        color: gridColor.withOpacity(Opacities.moderate),
        strokeWidth: ChartConstants.gridStrokeWidth,
      ),
    );
  }
}

class ChartAxisConfig {
  const ChartAxisConfig._();
  
  static AxisTitles leftPressureAxis({
    required double interval,
    required ThemeData theme,
    bool highlightZero = true,
  }) {
    final labelColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: ChartConstants.leftAxisReservedSize,
        interval: interval,
        getTitlesWidget: (value, meta) {
          final isZero = value == 0;
          return Padding(
            padding: const EdgeInsets.only(right: Spacing.xsPlus),
            child: Text(
              '${value.toInt()}',
              style: TextStyle(
                fontSize: FontSizes.xs,
                color: isZero && highlightZero 
                    ? Colors.red.shade400 
                    : labelColor,
                fontWeight: isZero && highlightZero 
                    ? FontWeight.bold 
                    : FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          );
        },
      ),
      axisNameWidget: Padding(
        padding: const EdgeInsets.only(right: Spacing.xsPlus, bottom: Spacing.xs),
        child: Text(
          'hPa',
          style: TextStyle(
            fontSize: FontSizes.xxs,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: LetterSpacings.normal,
          ),
        ),
      ),
    );
  }
  
  static AxisTitles bottomTimeAxis({
    required double interval,
    required ThemeData theme,
    bool showMilliseconds = false,
  }) {
    final labelColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: ChartConstants.bottomAxisReservedSize,
        interval: interval,
        getTitlesWidget: (value, meta) {
          final timeInSeconds = showMilliseconds
              ? (value * 0.001).toStringAsFixed(1)
              : (value * 0.001).toStringAsFixed(0);
          return Padding(
            padding: const EdgeInsets.only(top: Spacing.xsPlus),
            child: Text(
              '${timeInSeconds}s',
              style: TextStyle(
                fontSize: FontSizes.xs,
                color: labelColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          );
        },
      ),
    );
  }
  
  static AxisTitles bottomHistoryAxis({
    required ThemeData theme,
    double interval = ChartConstants.historyXInterval,
  }) {
    final labelColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: ChartConstants.bottomAxisReservedSize,
        interval: interval,
        getTitlesWidget: (value, meta) {
          final timeInSeconds = (value / 1000.0).toStringAsFixed(0);
          return Padding(
            padding: const EdgeInsets.only(top: Spacing.xsPlus),
            child: Text(
              '${timeInSeconds}s',
              style: TextStyle(
                fontSize: FontSizes.xs,
                color: labelColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          );
        },
      ),
    );
  }
  
  static const AxisTitles hidden = AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  );
}

class BaselineConfig {
  const BaselineConfig._();
  
  static HorizontalLine atmosphericBaseline({
    String? label,
    Color? color,
  }) {
    final lineColor = color ?? Colors.red.shade400;
    
    return HorizontalLine(
      y: 0,
      color: lineColor,
      strokeWidth: ChartConstants.baselineWidth,
      dashArray: ChartDimensions.dashShort,
      label: label != null
          ? HorizontalLineLabel(
              show: true,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: Spacing.xs + 1, bottom: Spacing.xxs),
              style: TextStyle(
                color: lineColor,
                fontSize: FontSizes.xxs,
                fontWeight: FontWeight.bold,
              ),
              labelResolver: (line) => label,
            )
          : null,
    );
  }
}

class PressureLineConfig {
  const PressureLineConfig._();
  
  static LineChartBarData realTimeLine({
    required List<FlSpot> spots,
    required Color color,
    bool showDots = false,
    bool showGradient = true,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: ChartConstants.lineWidth,
      dotData: FlDotData(show: showDots),
      belowBarData: showGradient
          ? BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(Opacities.medium),
                  color.withOpacity(Opacities.subtle),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )
          : BarAreaData(show: false),
    );
  }
  
  static LineChartBarData historyLine({
    required List<FlSpot> spots,
    required Color color,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: ChartConstants.lineWidth,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class ChartTouchConfig {
  const ChartTouchConfig._();
  
  static LineTouchData pressureTooltip({bool enabled = true}) {
    return LineTouchData(
      enabled: enabled,
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
          final timeInSeconds = (spot.x * 0.001).toStringAsFixed(2);
          return LineTooltipItem(
            '${spot.y.toStringAsFixed(1)} hPa\n${timeInSeconds}s',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: FontSizes.bodySm,
            ),
          );
        }).toList(),
      ),
    );
  }
  
  static const LineTouchData disabled = LineTouchData(
    enabled: false,
    handleBuiltInTouches: false,
  );
}
