// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/chart_point.dart';
import '../providers/providers.dart';
import '../widgets/history/history_widgets.dart';
import '../widgets/status_badge.dart';
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

  List<ChartPoint> _generateDemoChartData(int sessionId, int duration) {
    List<ChartPoint> spots = [];
    final random = Random(sessionId);

    for (int i = 0; i <= duration; i += 2) {
      double basePressure = 140.0 + (sessionId * 5);
      double variation = 30 * sin(i * 0.3);
      double noise = random.nextDouble() * 10 - 5;
      double pressure = basePressure + variation + noise;
      spots.add(ChartPoint(i.toDouble(), pressure));
    }

    return spots;
  }

  Future<void> _renameSession(SessionData session) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: session.displayTitle ?? '');

    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.editTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.measurementNumber(session.id ?? 0),
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (newTitle == null || !mounted) return;

    final repo = context.read<SessionRepository>();
    await repo.updateDisplayTitle(
      session.id!,
      newTitle.isEmpty ? null : newTitle,
    );
  }

  Future<void> _deleteSession(SessionData session) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          Icons.delete_outline,
          color: Theme.of(ctx).colorScheme.error,
          size: IconSizes.xl,
        ),
        title: Text(l10n.deleteSession),
        content: Text(l10n.deleteSessionConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await context.read<SessionRepository>().deleteSession(session.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.sessionDeleted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failedToDeleteSession(e.toString()))),
      );
    }
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
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.loading, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );

    try {
      // Lazy load chart data if not already loaded
      final sessionRepo = context.read<SessionRepository>();
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
        SnackBar(content: Text(AppLocalizations.of(context)!.failedToLoadSessionData(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listPadding = Responsive.padding(context);
    final maxWidth = Responsive.maxContentWidth(context);

    return Consumer2<SessionRepository, MidiProvider>(
      builder: (context, sessionRepo, midi, _) {
        final sessions = sessionRepo.sessions;
        final isLoading = sessionRepo.isLoading;
        final isConnected = midi.isConnected;

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
                      Icon(
                        Icons.history,
                        size: IconSizes.display * 1.67,
                        color: StatusColors.disabled.withValues(alpha: Opacities.mediumHigh),
                      ),
                      const SizedBox(height: Spacing.lg),
                      Text(
                        l10n.noMeasurements,
                        style: const TextStyle(fontSize: FontSizes.bodyLg, color: StatusColors.neutral),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        l10n.startMeasuringHint,
                        style: const TextStyle(fontSize: FontSizes.body, color: StatusColors.disabled),
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
                            onDelete: () => _deleteSession(session),
                            onRename: () => _renameSession(session),
                            onAnalyze: () async {
                              final l10nLocal = AppLocalizations.of(context)!;
                              final proceed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Theme.of(ctx).colorScheme.primary,
                                    size: IconSizes.xl,
                                  ),
                                  title: Text(l10nLocal.advancedAnalysis),
                                  content: Text(
                                    l10nLocal.peakAnalysisDisclaimer,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text(l10nLocal.cancel),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text(l10nLocal.confirm),
                                    ),
                                  ],
                                ),
                              );
                              if (proceed != true || !context.mounted) return;
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
              color: StatusColors.disabled.withValues(alpha: Opacities.mediumHigh),
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

