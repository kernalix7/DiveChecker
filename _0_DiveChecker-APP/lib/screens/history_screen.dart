// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../providers/providers.dart';
import '../widgets/status_badge.dart';
import '../widgets/history/history_widgets.dart';
import 'graph_detail_page.dart';
import 'peak_analysis_page.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedDeviceSerial;  // null = all devices
  List<Map<String, dynamic>> _devices = [];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  
  Future<void> _loadData() async {
    // Sessions already loaded in main.dart, just load devices
    await _loadDevices();
  }
  
  Future<void> _loadDevices() async {
    final sessionRepo = context.read<SessionRepository>();
    final devices = await sessionRepo.getUniqueDevices();
    if (mounted) {
      setState(() {
        _devices = devices;
      });
    }
  }
  
  void _showDeviceFilter(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _DeviceFilterSheet(
        devices: _devices,
        selectedSerial: _selectedDeviceSerial,
        onSelect: (serial) {
          setState(() {
            _selectedDeviceSerial = serial;
          });
          context.read<SessionRepository>().filterByDevice(serial);
          Navigator.pop(context);
        },
        l10n: l10n,
      ),
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${l10n.today} ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return '${l10n.yesterday} ${DateFormat('HH:mm').format(date)}';
    } else {
      return DateFormat('MM/dd HH:mm').format(date);
    }
  }

  String _formatDuration(int seconds, AppLocalizations l10n) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return l10n.minutesSeconds(minutes, remainingSeconds);
    }
    return l10n.secondsOnly(seconds);
  }

  List<FlSpot> _generateDemoChartData(int sessionId, int duration) {
    List<FlSpot> spots = [];
    final random = Random(sessionId);

    for (int i = 0; i <= duration; i += 2) {
      double basePressure = 140.0 + (sessionId * 5);
      double variation = 30 * sin(i * 0.3);
      double noise = random.nextDouble() * 10 - 5;
      double pressure = basePressure + variation + noise;
      spots.add(FlSpot(i.toDouble(), pressure));
    }

    return spots;
  }

  Future<void> _showSessionDetail(SessionData session) async {
    // Show subtle loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              SizedBox(height: 16),
              Text('Loading...', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );

    try {
      // Lazy load chart data if not already loaded
      final sessionRepo = Provider.of<SessionRepository>(context, listen: false);
      SessionData loadedSession;
      
      if (session.chartData.isEmpty && session.id != null) {
        loadedSession = await sessionRepo.loadSessionWithChartData(session);
      } else {
        loadedSession = session;
      }

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      final chartData = loadedSession.chartData.isNotEmpty
          ? loadedSession.chartData
          : _generateDemoChartData(session.id ?? 0, session.duration);

      final sessionMap = loadedSession.toMap();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GraphDetailPage(chartData: chartData, session: sessionMap),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load session data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listPadding = Responsive.padding(context);
    final maxWidth = Responsive.maxContentWidth(context);

    return Consumer2<SessionRepository, SerialProvider>(
      builder: (context, sessionRepo, serial, _) {
        final sessions = sessionRepo.sessions;
        final isLoading = sessionRepo.isLoading;
        final isConnected = serial.isConnected;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${l10n.measurementHistory} (${sessions.length})',
              style: const TextStyle(
                fontSize: FontSizes.titleSm,
                fontWeight: FontWeight.bold,
                letterSpacing: LetterSpacings.widest,
              ),
            ),
            actions: [
              // Device filter button
              if (_devices.isNotEmpty)
                IconButton(
                  icon: Badge(
                    isLabelVisible: _selectedDeviceSerial != null,
                    child: const Icon(Icons.filter_list),
                  ),
                  onPressed: () => _showDeviceFilter(context, l10n),
                  tooltip: l10n.filterByDevice,
                ),
              Padding(
                padding: const EdgeInsets.only(right: Spacing.sm),
                child: StatusBadge(isConnected: isConnected),
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : sessions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: IconSizes.display * 1.67, color: StatusColors.disabled.withOpacity(Opacities.mediumHigh)),
                      Spacing.verticalLg,
                      Text(
                        l10n.noMeasurements,
                        style: TextStyle(fontSize: FontSizes.bodyLg, color: StatusColors.neutral),
                      ),
                      Spacing.verticalSm,
                      Text(
                        l10n.startMeasuringHint,
                        style: TextStyle(fontSize: FontSizes.body, color: StatusColors.disabled),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: RefreshIndicator(
                      onRefresh: () => sessionRepo.refresh(),
                      child: ListView.separated(
                        padding: listPadding,
                        itemCount: sessions.length,
                        separatorBuilder: (context, index) =>
                            Spacing.verticalMd,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return SessionCard(
                            session: session,
                            onTap: () => _showSessionDetail(session),
                            onAnalyze: () {
                              final chartData = session.chartData.isNotEmpty
                                  ? session.chartData
                                  : _generateDemoChartData(
                                      session.id ?? 0,
                                      session.duration,
                                    );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PeakAnalysisPage(
                                    chartData: chartData,
                                    session: session.toMap(),
                                  ),
                                ),
                              );
                            },
                            formatDate: (date) => _formatDate(date, l10n),
                            formatDuration: (seconds) =>
                                _formatDuration(seconds, l10n),
                          );
                        },
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

/// Bottom sheet for filtering sessions by device
class _DeviceFilterSheet extends StatelessWidget {
  final List<Map<String, dynamic>> devices;
  final String? selectedSerial;
  final Function(String?) onSelect;
  final AppLocalizations l10n;

  const _DeviceFilterSheet({
    required this.devices,
    required this.selectedSerial,
    required this.onSelect,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: Spacing.md),
            width: WidgetSizes.containerHuge,
            height: Dimensions.progressBarThin,
            decoration: BoxDecoration(
              color: StatusColors.disabled.withOpacity(Opacities.mediumHigh),
              borderRadius: BorderRadii.xsAll,
            ),
          ),
          Padding(
            padding: Spacing.screenPadding,
            child: Text(
              l10n.selectDevice,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          // All devices option
          ListTile(
            leading: Icon(
              Icons.all_inclusive,
              color: selectedSerial == null ? theme.colorScheme.primary : null,
            ),
            title: Text(l10n.allDevices),
            trailing: selectedSerial == null 
                ? Icon(Icons.check, color: theme.colorScheme.primary) 
                : null,
            onTap: () => onSelect(null),
          ),
          const Divider(height: 1),
          // Device list
          ...devices.map((device) {
            final serial = device['serial'] as String?;
            final name = device['name'] as String? ?? 'DiveChecker';
            final count = device['sessionCount'] as int;
            final isSelected = selectedSerial == serial;
            final shortSerial = serial != null && serial.length >= 4
                ? serial.substring(serial.length - 4)
                : serial ?? '';
            
            return ListTile(
              leading: Icon(
                Icons.sensors,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
              title: Text('$name-$shortSerial'),
              subtitle: Text('${l10n.sessionsCount(count)}'),
              trailing: isSelected 
                  ? Icon(Icons.check, color: theme.colorScheme.primary) 
                  : null,
              onTap: () => onSelect(serial),
            );
          }),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }
}

