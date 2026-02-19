// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Real-time Monitoring Screen
/// 
/// Displays live pressure data in a horizontal scrolling chart.
/// No recording - just continuous monitoring.
library;

import 'dart:async';
import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/chart_point.dart';
import '../providers/providers.dart';
import '../utils/formatters.dart';
import '../widgets/status_badge.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final Queue<ChartPoint> _dataBuffer = Queue<ChartPoint>();
  StreamSubscription<double>? _pressureSubscription;
  double _currentPressure = 0.0;
  int _sampleIndex = 0;
  
  // Buffer settings
  static const int _maxBufferSize = 240; // 30 seconds at 8Hz
  static const double _sampleIntervalMs = 125.0; // 8Hz
  static const double _windowMs = 30000.0; // 30 second window
  
  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    final serial = context.read<SerialProvider>();
    _pressureSubscription = serial.pressureStream.listen(_onPressureReceived);
  }

  void _onPressureReceived(double pressure) {
    if (!mounted) return;
    
    setState(() {
      _currentPressure = pressure;
      
      // Add new data point
      final xMs = _sampleIndex * _sampleIntervalMs;
      _dataBuffer.add(ChartPoint(xMs, pressure));
      _sampleIndex++;
      
      // Keep buffer size limited (Queue.removeFirst is O(1))
      while (_dataBuffer.length > _maxBufferSize) {
        _dataBuffer.removeFirst();
      }
    });
  }

  @override
  void dispose() {
    _pressureSubscription?.cancel();
    // Ensure orientations are unlocked when leaving screen
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _clearBuffer() {
    setState(() {
      _dataBuffer.clear();
      _sampleIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    // Force landscape orientation for this screen
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        
        return Scaffold(
          appBar: isLandscape ? null : _buildAppBar(l10n),
          body: Consumer<SerialProvider>(
            builder: (context, serial, _) {
              final isConnected = serial.isConnected;
              
              if (!isConnected) {
                return _buildNotConnectedView(l10n, theme);
              }
              
              final settings = context.watch<SettingsProvider>();
              return SafeArea(
                child: isLandscape 
                    ? _buildLandscapeLayout(l10n, theme, settings)
                    : _buildPortraitLayout(l10n, theme, settings),
              );
            },
          ),
          floatingActionButton: isLandscape ? FloatingActionButton.small(
            onPressed: () {
              // Exit fullscreen
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              Future.delayed(const Duration(milliseconds: 500), () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              });
            },
            child: const Icon(Icons.fullscreen_exit),
          ) : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.monitor.toUpperCase(),
        style: const TextStyle(
          fontSize: FontSizes.titleSm,
          fontWeight: FontWeight.bold,
          letterSpacing: LetterSpacings.widest,
        ),
      ),
      actions: [
        Consumer<SerialProvider>(
          builder: (context, serial, _) => Padding(
            padding: const EdgeInsets.only(right: Spacing.lg),
            child: StatusBadge(isConnected: serial.isConnected),
          ),
        ),
      ],
    );
  }

  Widget _buildNotConnectedView(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sensors_off_outlined,
            size: UIConstants.xlIconSize,
            color: theme.colorScheme.outline,
          ),
          Spacing.verticalXl,
          Text(
            l10n.deviceNotConnected,
            style: TextStyle(
              fontSize: FontSizes.bodyLg,
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.verticalMd,
          Text(
            l10n.tapToConnect,
            style: TextStyle(
              fontSize: FontSizes.body,
              color: theme.colorScheme.outline.withOpacity(Opacities.high),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(AppLocalizations l10n, ThemeData theme, SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        children: [
          // Current pressure display
          _buildPressureDisplay(l10n, theme, settings),
          Spacing.verticalXl,
          
          // Chart
          Expanded(
            child: _buildChartContainer(l10n, theme, isLandscape: false),
          ),
          
          Spacing.verticalMd,
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _clearBuffer,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.reset),
              ),
              Spacing.horizontalLg,
              FilledButton.icon(
                onPressed: () {
                  // Enter fullscreen landscape
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                },
                icon: const Icon(Icons.fullscreen),
                label: Text(l10n.fullscreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(AppLocalizations l10n, ThemeData theme, SettingsProvider settings) {
    return Row(
      children: [
        // Side panel with pressure
        Container(
          width: 120,
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: theme.colorScheme.outline.withOpacity(Opacities.low),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sensors_rounded,
                size: IconSizes.md,
                color: theme.colorScheme.primary,
              ),
              Spacing.verticalMd,
              Text(
                formatPressure(settings.convertPressure(_currentPressure)),
                style: TextStyle(
                  fontSize: FontSizes.display,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                settings.pressureUnitSymbol,
                style: TextStyle(
                  fontSize: FontSizes.body,
                  color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _clearBuffer,
                icon: const Icon(Icons.refresh),
                tooltip: l10n.reset,
              ),
            ],
          ),
        ),
        
        // Chart
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: _buildChartContainer(l10n, theme, isLandscape: true),
          ),
        ),
      ],
    );
  }

  Widget _buildPressureDisplay(AppLocalizations l10n, ThemeData theme, SettingsProvider settings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadii.xlAll,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(Opacities.mediumHigh),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sensors_rounded,
            size: IconSizes.lg,
            color: theme.colorScheme.primary,
          ),
          Spacing.horizontalLg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.liveSensorData,
                  style: TextStyle(
                    fontSize: FontSizes.bodySm,
                    color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
                    fontWeight: FontWeight.bold,
                    letterSpacing: LetterSpacings.widest,
                  ),
                ),
                Spacing.verticalXs,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      formatPressure(settings.convertPressure(_currentPressure)),
                      style: TextStyle(
                        fontSize: FontSizes.displayLg,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Spacing.horizontalSm,
                    Text(
                      settings.pressureUnitSymbol,
                      style: TextStyle(
                        fontSize: FontSizes.bodyLg,
                        color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Sample count
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_dataBuffer.length}',
                style: TextStyle(
                  fontSize: FontSizes.xl,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                l10n.samples,
                style: TextStyle(
                  fontSize: FontSizes.xxs,
                  color: theme.colorScheme.onSurface.withOpacity(Opacities.medium),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer(AppLocalizations l10n, ThemeData theme, {required bool isLandscape}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadii.lgAll,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(Opacities.mediumHigh),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadii.lgAll,
        child: _dataBuffer.isEmpty
            ? _buildEmptyChartPlaceholder(l10n, theme)
            : _buildChart(theme),
      ),
    );
  }

  Widget _buildEmptyChartPlaceholder(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: UIConstants.xlIconSize,
            color: theme.colorScheme.outline.withOpacity(Opacities.medium),
          ),
          Spacing.verticalMd,
          Text(
            l10n.waitingForData,
            style: TextStyle(
              fontSize: FontSizes.body,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(ThemeData theme) {
    // Calculate visible range
    double minX, maxX;
    if (_dataBuffer.isEmpty) {
      minX = 0;
      maxX = _windowMs;
    } else {
      final lastX = _dataBuffer.last.x;
      if (lastX < _windowMs) {
        minX = 0;
        maxX = _windowMs;
      } else {
        maxX = lastX;
        minX = lastX - _windowMs;
      }
    }

    // Filter visible data
    final visibleData = _dataBuffer
        .where((p) => p.x >= minX && p.x <= maxX)
        .map((p) => FlSpot(p.x, p.y))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(
        top: Spacing.md,
        bottom: Spacing.sm,
        left: Spacing.sm,
        right: Spacing.lg,
      ),
      child: LineChart(
        LineChartData(
          clipData: const FlClipData.all(),
          minX: minX,
          maxX: maxX,
          minY: -10,
          maxY: 25,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 5,
            verticalInterval: 5000, // 5 seconds
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade500,
              strokeWidth: 0.3,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.shade400,
              strokeWidth: 0.3,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 5,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: FontSizes.xxs,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 5000, // 5 seconds
                getTitlesWidget: (value, meta) {
                  final seconds = (value / 1000.0).toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: Spacing.xs),
                    child: Text(
                      '${seconds}s',
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
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: visibleData,
              isCurved: true,
              curveSmoothness: 0.2,
              preventCurveOverShooting: true,
              color: theme.colorScheme.primary,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
        duration: Duration.zero, // Disable animation for real-time
      ),
    );
  }
}
