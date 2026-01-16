// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../widgets/common/stat_info.dart';
import 'dart:math';
import 'dart:async';
import '../services/unified_database_service.dart';
import '../providers/serial_provider.dart';
import '../providers/session_repository.dart';
import '../providers/settings_provider.dart';
import '../models/graph_note.dart';
import 'peak_analysis_page.dart';

class GraphDetailPage extends StatefulWidget {
  final List<FlSpot> chartData;
  final Map<String, dynamic> session;

  const GraphDetailPage({
    super.key,
    required this.chartData,
    required this.session,
  });

  @override
  State<GraphDetailPage> createState() => _GraphDetailPageState();
}

class _GraphDetailPageState extends State<GraphDetailPage> {
  bool _isConnected = false;
  double _minX = 0;
  double _maxX = 100;
  final List<GraphNote> _graphNotes = [];
  double _zoomLevel = 1.0;
  final double _minZoom = 0.5;
  final double _maxZoom = 100.0;

  double _baseZoomLevel = 1.0;
  double _baseMinX = 0;
  double _baseMaxX = 100;
  Offset? _lastFocalPoint;

  // Cached note lines to prevent rebuilding on touch events
  List<VerticalLine>? _cachedNoteLines;
  double? _cachedMinX;
  double? _cachedMaxX;

  @override
  void initState() {
    super.initState();
    final serial = context.read<SerialProvider>();
    _isConnected = serial.isConnected;
    if (widget.chartData.isNotEmpty) {
      _minX = widget.chartData.first.x;
      _maxX = widget.chartData.last.x;
    }
    _loadGraphNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadGraphNotes() async {
    final dbService = UnifiedDatabaseService();
    final notes = await dbService.getGraphNotesBySession(widget.session['id']);
    setState(() {
      _graphNotes.clear();
      _graphNotes.addAll(notes.map((n) => GraphNote.fromMap(n)));
      // 시간 순서대로 정렬 (X값 기준)
      _graphNotes.sort((a, b) => a.x.compareTo(b.x));
      // Invalidate cache since notes changed
      _invalidateNoteLinesCache();
    });
  }

  void _zoomIn() {
    setState(() {
      if (_zoomLevel < _maxZoom) {
        _zoomLevel *= 1.5;
        double center = (_minX + _maxX) / 2;
        double newRange = (_maxX - _minX) / 1.5;
        _minX = max(widget.chartData.first.x, center - newRange / 2);
        _maxX = min(widget.chartData.last.x, center + newRange / 2);
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomLevel > _minZoom) {
        _zoomLevel /= 1.5;
        double center = (_minX + _maxX) / 2;
        double newRange = (_maxX - _minX) * 1.5;
        _minX = max(widget.chartData.first.x, center - newRange / 2);
        _maxX = min(widget.chartData.last.x, center + newRange / 2);

        if (_minX <= widget.chartData.first.x &&
            _maxX >= widget.chartData.last.x) {
          _zoomLevel = 1.0;
        }
      }
    });
  }

  void _focusOnTimePoint(double x) {
    setState(() {
      final totalRange = widget.chartData.last.x - widget.chartData.first.x;

      final viewRange = totalRange * 0.1;

      _minX = max(widget.chartData.first.x, x - viewRange / 2);
      _maxX = min(widget.chartData.last.x, x + viewRange / 2);

      if (_minX == widget.chartData.first.x) {
        _maxX = min(widget.chartData.last.x, _minX + viewRange);
      }
      if (_maxX == widget.chartData.last.x) {
        _minX = max(widget.chartData.first.x, _maxX - viewRange);
      }

      _zoomLevel = totalRange / viewRange;
    });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseZoomLevel = _zoomLevel;
    _baseMinX = _minX;
    _baseMaxX = _maxX;
    _lastFocalPoint = details.localFocalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      if (details.scale != 1.0) {
        double newZoom = _baseZoomLevel * details.scale;
        newZoom = newZoom.clamp(_minZoom, _maxZoom);

        double baseRange = _baseMaxX - _baseMinX;
        double newRange = baseRange / (newZoom / _baseZoomLevel);
        double center = (_baseMinX + _baseMaxX) / 2;

        _minX = max(widget.chartData.first.x, center - newRange / 2);
        _maxX = min(widget.chartData.last.x, center + newRange / 2);
        _zoomLevel = newZoom;
      }

      if (_lastFocalPoint != null && details.scale == 1.0) {
        double dx = details.localFocalPoint.dx - _lastFocalPoint!.dx;
        double range = _maxX - _minX;
        double shift = -dx * range / 300;

        double newMinX = _minX + shift;
        double newMaxX = _maxX + shift;

        if (newMinX >= widget.chartData.first.x &&
            newMaxX <= widget.chartData.last.x) {
          _minX = newMinX;
          _maxX = newMaxX;
        }
        _lastFocalPoint = details.localFocalPoint;
      }
    });
  }

  void _resetZoom() {
    setState(() {
      _minX = widget.chartData.first.x;
      _maxX = widget.chartData.last.x;
    });
  }

  void _panLeft() {
    setState(() {
      double range = _maxX - _minX;
      double shift = range * 0.25;
      if (_minX - shift >= widget.chartData.first.x) {
        _minX -= shift;
        _maxX -= shift;
      }
    });
  }

  void _panRight() {
    setState(() {
      double range = _maxX - _minX;
      double shift = range * 0.25;
      if (_maxX + shift <= widget.chartData.last.x) {
        _minX += shift;
        _maxX += shift;
      }
    });
  }

  double _calculateMinY() {
    if (widget.chartData.isEmpty) return -5;
    final visibleData = widget.chartData.where(
      (s) => s.x >= _minX && s.x <= _maxX,
    );
    if (visibleData.isEmpty) return -5;
    final minVal = visibleData.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    return (minVal - 2).floorToDouble().clamp(-50, 0);
  }

  double _calculateMaxY() {
    if (widget.chartData.isEmpty) return 10;
    final visibleData = widget.chartData.where(
      (s) => s.x >= _minX && s.x <= _maxX,
    );
    if (visibleData.isEmpty) return 10;
    final maxVal = visibleData.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return (maxVal + 2).ceilToDouble().clamp(5, 100);
  }

  double _calculateYInterval() {
    final range = _calculateMaxY() - _calculateMinY();
    if (range <= 5) return 1;
    if (range <= 10) return 2;
    if (range <= 20) return 2;
    if (range <= 30) return 5;
    if (range <= 50) return 5;
    return 10;
  }

  /// Get sample rate from session (defaults to 8Hz)
  int get _sampleRate => widget.session['sample_rate'] ?? 8;

  /// Calculate vertical grid interval aligned to sample rate
  /// Grid lines are placed at multiples of sample interval
  double _calculateVerticalGridInterval(double chartPixelWidth) {
    final dataRange = _maxX - _minX;
    final rangeInSeconds = dataRange / 1000.0; // X is in milliseconds
    final sampleIntervalMs = 1000.0 / _sampleRate; // e.g., 125ms for 8Hz

    // Choose target interval in seconds based on zoom level
    double targetSeconds;
    if (rangeInSeconds <= 2) {
      targetSeconds = 0.125; // 8 grids per second
    } else if (rangeInSeconds <= 5) {
      targetSeconds = 0.25; // 4 grids per second
    } else if (rangeInSeconds <= 10) {
      targetSeconds = 0.5; // 2 grids per second
    } else if (rangeInSeconds <= 20) {
      targetSeconds = 1.0; // 1 grid per second
    } else if (rangeInSeconds <= 60) {
      targetSeconds = 2.0; // 1 grid per 2 seconds
    } else if (rangeInSeconds <= 120) {
      targetSeconds = 5.0; // 1 grid per 5 seconds
    } else if (rangeInSeconds <= 300) {
      targetSeconds = 10.0; // 1 grid per 10 seconds
    } else {
      targetSeconds = 30.0; // 1 grid per 30 seconds
    }

    // Snap to nearest sample interval multiple
    final targetMs = targetSeconds * 1000.0;
    final samples = (targetMs / sampleIntervalMs).round().clamp(1, 1000000);
    return samples * sampleIntervalMs;
  }

  double _calculateXInterval() {
    final range = _maxX - _minX;
    // Calculate interval to show ~5-10 labels
    // Aim for nice round seconds - more frequent labels
    final rangeInSeconds = range / 1000.0; // X is in milliseconds

    double secondsInterval;
    if (rangeInSeconds <= 5)
      secondsInterval = 0.5;
    else if (rangeInSeconds <= 10)
      secondsInterval = 1;
    else if (rangeInSeconds <= 20)
      secondsInterval = 2;
    else if (rangeInSeconds <= 40)
      secondsInterval = 5;
    else if (rangeInSeconds <= 90)
      secondsInterval = 10;
    else if (rangeInSeconds <= 180)
      secondsInterval = 15;
    else if (rangeInSeconds <= 300)
      secondsInterval = 20;
    else
      secondsInterval = 30;

    // Convert seconds interval to milliseconds
    return secondsInterval * 1000.0;
  }

  /// Convert X value (milliseconds) to seconds
  double _xToSeconds(double x) {
    // X is in milliseconds (stored as elapsed time since session start)
    // seconds = milliseconds / 1000
    return x / 1000.0;
  }

  /// Format time label: seconds for < 60s, m:ss for >= 60s
  String _formatTimeLabel(double seconds) {
    final totalSeconds = seconds.round();
    if (totalSeconds < 60) {
      return '${totalSeconds}s';
    } else {
      final minutes = totalSeconds ~/ 60;
      final secs = totalSeconds % 60;
      return '$minutes:${secs.toString().padLeft(2, '0')}';
    }
  }

  /// Label info - zoom-aware label display
  /// Peaks are prioritized, then other points
  List<({int index, double fontSize})> _getLabelsInfo() {
    final visibleEntries = widget.chartData
        .asMap()
        .entries
        .where((entry) => entry.value.x >= _minX && entry.value.x <= _maxX)
        .toList();

    if (visibleEntries.isEmpty) return [];

    // Calculate ranges
    final visibleXRange = _maxX - _minX;
    final visibleYRange = _calculateMaxY() - _calculateMinY();
    final totalXRange = widget.chartData.isEmpty
        ? visibleXRange
        : widget.chartData.last.x - widget.chartData.first.x;
    final zoomRatio = totalXRange / visibleXRange;

    final isHighZoom = zoomRatio >= 4.0;

    final minXDistance = isHighZoom ? visibleXRange / 150 : visibleXRange / 35;

    final minYDistance = visibleYRange / 8;
    const sameValueThreshold = 0.3;
    const fontSize = 9.0;

    // Find local peaks (higher than neighbors)
    final peaks = <int>{};
    for (int i = 0; i < visibleEntries.length; i++) {
      final curr = visibleEntries[i].value.y;
      final prev = i > 0 ? visibleEntries[i - 1].value.y : curr;
      final next = i < visibleEntries.length - 1
          ? visibleEntries[i + 1].value.y
          : curr;

      // Is this a local peak? (higher than both neighbors by some margin)
      if (curr > prev + 0.5 && curr > next + 0.5) {
        peaks.add(visibleEntries[i].key);
      }
    }

    // Sort entries: peaks first (sorted by Y descending), then others
    final sortedEntries = List.of(visibleEntries);
    sortedEntries.sort((a, b) {
      final aIsPeak = peaks.contains(a.key);
      final bIsPeak = peaks.contains(b.key);

      if (aIsPeak && !bIsPeak) return -1; // a first
      if (!aIsPeak && bIsPeak) return 1; // b first
      if (aIsPeak && bIsPeak) {
        // Both peaks: higher Y first
        return b.value.y.compareTo(a.value.y);
      }
      // Both non-peaks: keep original order (by X)
      return a.value.x.compareTo(b.value.x);
    });

    final result = <({int index, double fontSize})>[];
    final shownLabels = <({double x, double y})>[];

    bool wouldOverlap(double x, double y) {
      for (final shown in shownLabels) {
        final xDiff = (x - shown.x).abs();
        final yDiff = (y - shown.y).abs();
        final isSameValue = yDiff < sameValueThreshold;

        // Y far enough = won't overlap
        if (yDiff >= minYDistance) continue;

        // Y close - check X
        if (isSameValue) {
          if (xDiff < minXDistance * 3) return true;
        } else {
          if (xDiff < minXDistance) return true;
        }
      }
      return false;
    }

    for (final entry in sortedEntries) {
      final x = entry.value.x;
      final y = entry.value.y;

      if (!wouldOverlap(x, y)) {
        result.add((index: entry.key, fontSize: fontSize));
        shownLabels.add((x: x, y: y));
      }
    }

    return result;
  }

  // Store label info for use in getTooltipItems
  List<({int index, double fontSize})> _cachedLabelsInfo = [];

  List<ShowingTooltipIndicators> _getVisibleTooltipIndicators() {
    _cachedLabelsInfo = _getLabelsInfo();

    return _cachedLabelsInfo
        .map(
          (info) => ShowingTooltipIndicators([
            LineBarSpot(
              LineChartBarData(spots: widget.chartData),
              0,
              widget.chartData[info.index],
            ),
          ]),
        )
        .toList();
  }

  // Get font size for a specific spot
  double _getFontSizeForSpot(FlSpot spot) {
    for (final info in _cachedLabelsInfo) {
      final labelSpot = widget.chartData[info.index];
      if (labelSpot.x == spot.x && labelSpot.y == spot.y) {
        return info.fontSize;
      }
    }
    return 10.0;
  }

  /// Generate note markers with stair-step label positions
  /// Uses caching to prevent rebuilding on touch events
  List<VerticalLine> _getNotesWithStairLabels() {
    // Return cached if zoom/pan hasn't changed
    if (_cachedNoteLines != null &&
        _cachedMinX == _minX &&
        _cachedMaxX == _maxX) {
      return _cachedNoteLines!;
    }

    if (_graphNotes.isEmpty) {
      _cachedNoteLines = [];
      _cachedMinX = _minX;
      _cachedMaxX = _maxX;
      return [];
    }

    // Sort notes by X position
    final sortedNotes = List.of(_graphNotes)
      ..sort((a, b) => a.x.compareTo(b.x));

    // X distance threshold to reset stair
    final visibleXRange = _maxX - _minX;
    final resetXDistance = visibleXRange / 6;

    // Stair step settings
    const maxSteps = 4;
    const stepHeight = 0.15; // Each step moves down

    final result = <VerticalLine>[];
    int currentStep = 0;
    double? lastX;

    for (int i = 0; i < sortedNotes.length; i++) {
      final note = sortedNotes[i];
      final originalIndex = _graphNotes.indexOf(note);

      // Reset to top if far enough from last note
      if (lastX != null && (note.x - lastX).abs() >= resetXDistance) {
        currentStep = 0;
      }

      // Y alignment: start from top, step down
      // -1.0 = top, 1.0 = bottom
      final yAlign = -1.0 + (currentStep * stepHeight * 2);

      result.add(
        VerticalLine(
          x: note.x,
          color: ScoreColors.excellent.withOpacity(Opacities.high),
          strokeWidth: ChartDimensions.strokeSmMedium,
          dashArray: ChartDimensions.dashMedium,
          label: VerticalLineLabel(
            show: true,
            alignment: Alignment(
              1.0,
              yAlign,
            ), // Right side of line, touching it
            padding: EdgeInsets.zero,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: FontSizes.xxs,
              backgroundColor: ScoreColors.excellent,
            ),
            labelResolver: (line) => '#${originalIndex + 1}',
          ),
        ),
      );

      lastX = note.x;
      currentStep = (currentStep + 1) % maxSteps;
    }

    // Cache the result
    _cachedNoteLines = result;
    _cachedMinX = _minX;
    _cachedMaxX = _maxX;

    return result;
  }

  /// Invalidate note lines cache (call when notes change)
  void _invalidateNoteLinesCache() {
    _cachedNoteLines = null;
  }

  /// Build vertical lines for note markers only (no touch cursor)
  /// Touch cursor is rendered as a separate overlay layer
  List<VerticalLine> _buildVerticalLines() {
    // Return only note lines (cached)
    return _getNotesWithStairLabels();
  }

  void _showAddNoteDialog(double x, double y) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final timeInSeconds = _xToSeconds(x).toStringAsFixed(2);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${l10n.addNote} (${timeInSeconds}s)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.currentPressure}: ${y.toStringAsFixed(1)}',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(Opacities.medium),
                fontSize: FontSizes.body,
              ),
            ),
            Spacing.verticalLg,
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: l10n.noteHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final dbService = UnifiedDatabaseService();
                final noteId = await dbService.saveGraphNote(
                  widget.session['id'],
                  x,
                  controller.text,
                );

                setState(() {
                  _graphNotes.add(
                    GraphNote(id: noteId, x: x, note: controller.text),
                  );
                  _graphNotes.sort((a, b) => a.x.compareTo(b.x));
                  _invalidateNoteLinesCache(); // Refresh note lines immediately
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.noteAdded)));
                }
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  String _getSessionTitle(AppLocalizations l10n) {
    final displayTitle = widget.session['displayTitle'] as String?;
    if (displayTitle != null && displayTitle.isNotEmpty) {
      return displayTitle;
    }
    final id = widget.session['id'];
    return '${l10n.measurement} #$id';
  }

  void _showEditTitleDialog(BuildContext context, AppLocalizations l10n) {
    final currentTitle = widget.session['displayTitle'] as String? ?? '';
    final controller = TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('제목 수정'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: _getSessionTitle(l10n),
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final newTitle = controller.text.trim();
              final sessionId = widget.session['id'] as int?;

              if (sessionId != null) {
                final repo = context.read<SessionRepository>();
                await repo.updateDisplayTitle(
                  sessionId,
                  newTitle.isEmpty ? null : newTitle,
                );

                setState(() {
                  widget.session['displayTitle'] = newTitle.isEmpty
                      ? null
                      : newTitle;
                });
              }

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final maxWidth = Responsive.maxContentWidth(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showEditTitleDialog(context, l10n),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.show_chart_rounded,
                size: IconSizes.sm,
                color: theme.colorScheme.primary,
              ),
              Spacing.horizontalMd,
              Flexible(
                child: Text(
                  _getSessionTitle(l10n),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: LetterSpacings.wider,
                    fontSize: FontSizes.titleSm,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacing.horizontalXs,
              Icon(
                Icons.edit,
                size: FontSizes.body,
                color: theme.colorScheme.outline,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Spacing.sm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.sm,
              ),
              decoration: BoxDecoration(
                color: _isConnected
                    ? ScoreColors.excellent.withOpacity(Opacities.low)
                    : StatusColors.disabled.withOpacity(Opacities.low),
                borderRadius: BorderRadii.smAll,
                border: Border.all(
                  color: _isConnected
                      ? ScoreColors.excellent.withOpacity(Opacities.mediumHigh)
                      : StatusColors.disabled.withOpacity(Opacities.mediumHigh),
                  width: ChartDimensions.strokeSmMedium,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isConnected
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth_disabled,
                    color: _isConnected
                        ? ScoreColors.excellent
                        : StatusColors.disabled,
                    size: IconSizes.sm,
                  ),
                  Spacing.horizontalXs,
                  Container(
                    width: Spacing.sm,
                    height: Spacing.sm,
                    decoration: BoxDecoration(
                      color: _isConnected
                          ? ScoreColors.excellent
                          : StatusColors.disabled,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: l10n.peakAnalysis,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PeakAnalysisPage(
                    chartData: widget.chartData,
                    session: widget.session,
                  ),
                ),
              );
            },
          ),
          Spacing.horizontalSm,
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  color: theme.colorScheme.surface,
                  child: Builder(
                    builder: (context) {
                      final settings = context.watch<SettingsProvider>();
                      final maxP = settings.convertPressure(
                        (widget.session['maxPressure'] as num).toDouble(),
                      );
                      final avgP = settings.convertPressure(
                        (widget.session['avgPressure'] as num).toDouble(),
                      );
                      final deviceSerial =
                          widget.session['deviceSerial'] as String?;
                      final deviceName =
                          widget.session['deviceName'] as String?;

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              StatInfo(
                                label: l10n.maxPressure.toUpperCase(),
                                value: maxP.toStringAsFixed(1),
                                unit: settings.pressureUnitSymbol,
                                color: theme.colorScheme.error,
                              ),
                              Container(
                                width: Dimensions.dividerHeight,
                                height: ChartDimensions.reservedSizeLarge,
                                color: theme.colorScheme.outline.withOpacity(
                                  Opacities.mediumHigh,
                                ),
                              ),
                              StatInfo(
                                label: l10n.avgPressure.toUpperCase(),
                                value: avgP.toStringAsFixed(1),
                                unit: settings.pressureUnitSymbol,
                                color: theme.colorScheme.secondary,
                              ),
                              Container(
                                width: Dimensions.dividerHeight,
                                height: ChartDimensions.reservedSizeLarge,
                                color: theme.colorScheme.outline.withOpacity(
                                  Opacities.mediumHigh,
                                ),
                              ),
                              StatInfo(
                                label: l10n.duration.toUpperCase(),
                                value: '${widget.session['duration']}',
                                unit: 's',
                                color: ScoreColors.warning,
                              ),
                            ],
                          ),
                          // Device info row
                          if (deviceSerial != null || deviceName != null) ...[
                            Spacing.verticalSm,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                                vertical: Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withOpacity(Opacities.low),
                                borderRadius: BorderRadii.smAll,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.devices,
                                    size: FontSizes.body,
                                    color: theme.colorScheme.primary,
                                  ),
                                  Spacing.horizontalSm,
                                  Text(
                                    deviceName ?? 'DiveChecker',
                                    style: TextStyle(
                                      fontSize: FontSizes.xs,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  if (deviceSerial != null) ...[
                                    Spacing.horizontalSm,
                                    Text(
                                      '(${deviceSerial.length > 8 ? '...${deviceSerial.substring(deviceSerial.length - 8)}' : deviceSerial})',
                                      style: TextStyle(
                                        fontSize: FontSizes.xs,
                                        fontFamily: 'monospace',
                                        color: theme.colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),

                // Chart section - responsive height based on device type
                Builder(
                  builder: (context) {
                    final chartHeight = Responsive.chartHeight(context);
                    final horizontalPadding = Responsive.value(
                      context,
                      mobile: Spacing.lg,
                      tablet: Spacing.xl,
                      desktop: Spacing.xxl,
                    );
                    return SizedBox(
                      height: chartHeight,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          Spacing.sm,
                          horizontalPadding,
                          Spacing.sm,
                        ),
                        child: GestureDetector(
                          onScaleStart: _handleScaleStart,
                          onScaleUpdate: _handleScaleUpdate,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(
                              Spacing.lg,
                              Spacing.xl,
                              Spacing.xxl,
                              Spacing.lg,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadii.lgAll,
                              border: Border.all(
                                color: theme.brightness == Brightness.dark
                                    ? theme.colorScheme.outline.withOpacity(0.3)
                                    : theme.colorScheme.outline.withOpacity(
                                        0.5,
                                      ),
                                width: ChartDimensions.strokeSmMedium,
                              ),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Calculate grid interval based on chart width
                                final chartWidth = constraints.maxWidth - 
                                    ChartDimensions.reservedSizeMax; // Subtract Y-axis space
                                final verticalGridInterval =
                                    _calculateVerticalGridInterval(chartWidth);

                                return LineChart(
                                      LineChartData(
                                        clipData: FlClipData.all(),
                                        minX: _minX,
                                        maxX: _maxX,
                                        minY: _calculateMinY(),
                                        maxY: _calculateMaxY(),
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: true,
                                          horizontalInterval:
                                              _calculateYInterval(),
                                          verticalInterval:
                                              verticalGridInterval,
                                          getDrawingHorizontalLine: (value) {
                                            final isDark =
                                                theme.brightness ==
                                                Brightness.dark;
                                            return FlLine(
                                              color: isDark
                                                  ? theme.colorScheme.outline
                                                        .withOpacity(0.5)
                                                  : theme.colorScheme.outline
                                                        .withOpacity(0.7),
                                              strokeWidth:
                                                  ChartDimensions.strokeThin,
                                            );
                                          },
                                          getDrawingVerticalLine: (value) {
                                            final isDark =
                                                theme.brightness ==
                                                Brightness.dark;
                                            return FlLine(
                                              color: isDark
                                                  ? theme.colorScheme.outline
                                                        .withOpacity(0.4)
                                                  : theme.colorScheme.outline
                                                        .withOpacity(0.6),
                                              strokeWidth:
                                                  ChartDimensions.strokeThin,
                                            );
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: ChartDimensions
                                                  .reservedSizeMax,
                                              interval: _calculateYInterval(),
                                              getTitlesWidget: (value, meta) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: Spacing.sm,
                                                      ),
                                                  child: Text(
                                                    '${value.toInt()}',
                                                    style: TextStyle(
                                                      fontSize: FontSizes.xxs,
                                                      color: theme
                                                          .colorScheme
                                                          .onSurface,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'monospace',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            axisNameWidget: Padding(
                                              padding: const EdgeInsets.only(
                                                right: Spacing.sm,
                                                bottom: Spacing.sm,
                                              ),
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontSize: FontSizes.xxs,
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing:
                                                      LetterSpacings.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: ChartDimensions
                                                  .reservedSizeLarge,
                                              interval: _calculateXInterval(),
                                              getTitlesWidget: (value, meta) {
                                                if (value < _minX ||
                                                    value > _maxX)
                                                  return const SizedBox.shrink();
                                                final seconds =
                                                    _xToSeconds(value);
                                                final timeLabel = _formatTimeLabel(seconds);
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: Spacing.sm,
                                                      ),
                                                  child: Text(
                                                    timeLabel,
                                                    style: TextStyle(
                                                      fontSize: FontSizes.xs,
                                                      color: theme
                                                          .colorScheme
                                                          .onSurface,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'monospace',
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                              reservedSize: 0,
                                            ),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                              reservedSize: 0,
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                            color:
                                                theme.brightness ==
                                                    Brightness.dark
                                                ? theme.colorScheme.outline
                                                      .withOpacity(0.3)
                                                : theme.colorScheme.outline
                                                      .withOpacity(0.5),
                                            width:
                                                ChartDimensions.strokeSmMedium,
                                          ),
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: widget.chartData,
                                            isCurved: false,
                                            color: theme.colorScheme.primary,
                                            barWidth:
                                                ChartDimensions.barWidthSmThin,
                                            dotData: const FlDotData(
                                              show: false,
                                            ),
                                            belowBarData: BarAreaData(
                                              show: false,
                                            ),
                                          ),
                                        ],
                                        showingTooltipIndicators:
                                            _getVisibleTooltipIndicators(),
                                        extraLinesData: ExtraLinesData(
                                          horizontalLines: [
                                            HorizontalLine(
                                              y: 0,
                                              color: ScoreColors.poor
                                                  .withOpacity(Opacities.high),
                                              strokeWidth: ChartDimensions
                                                  .strokeSmMedium,
                                              dashArray:
                                                  ChartDimensions.dashShort,
                                            ),
                                          ],
                                          verticalLines: _buildVerticalLines(),
                                        ),
                                        lineTouchData: LineTouchData(
                                          enabled: true,
                                          handleBuiltInTouches: false,
                                          touchTooltipData: LineTouchTooltipData(
                                            fitInsideHorizontally: true,
                                            fitInsideVertically: true,
                                            tooltipPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: Spacing.xs,
                                                  vertical: Spacing.xxs,
                                                ),
                                            tooltipRoundedRadius:
                                                BorderRadii.xs,
                                            tooltipMargin: Spacing.xs,
                                            getTooltipColor: (spot) =>
                                                Colors.transparent,
                                            getTooltipItems: (touchedSpots) {
                                              final isDark =
                                                  Theme.of(
                                                    context,
                                                  ).brightness ==
                                                  Brightness.dark;
                                              return touchedSpots.map((spot) {
                                                final fontSize =
                                                    _getFontSizeForSpot(spot);

                                                return LineTooltipItem(
                                                  spot.y.toStringAsFixed(1),
                                                  TextStyle(
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: fontSize,
                                                    shadows: [
                                                      Shadow(
                                                        color: isDark
                                                            ? Colors.black
                                                            : Colors.white,
                                                        blurRadius:
                                                            Shadows.blurSmall,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList();
                                            },
                                          ),
                                          getTouchedSpotIndicator:
                                              (barData, spotIndexes) {
                                                return spotIndexes.map((index) {
                                                  return TouchedSpotIndicatorData(
                                                    const FlLine(
                                                      color: Colors.transparent,
                                                      strokeWidth:
                                                          ChartDimensions
                                                              .strokeNone,
                                                    ),
                                                    FlDotData(show: false),
                                                  );
                                                }).toList();
                                              },
                                          touchCallback:
                                              (
                                                FlTouchEvent event,
                                                LineTouchResponse?
                                                touchResponse,
                                              ) {
                                                // Only handle tap - let pinch zoom work
                                                if (event is FlTapUpEvent &&
                                                    touchResponse?.lineBarSpots != null &&
                                                    touchResponse!.lineBarSpots!.isNotEmpty) {
                                                  final spot = touchResponse.lineBarSpots!.first;
                                                  _showAddNoteDialog(spot.x, spot.y);
                                                }
                                              },
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              Container(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                  child: Builder(
                    builder: (context) {
                      final isDark = theme.brightness == Brightness.dark;
                      final borderOpacity = isDark ? 0.3 : 0.5;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _panLeft,
                            icon: const Icon(Icons.chevron_left),
                            tooltip: l10n.panLeft,
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surface,
                              side: BorderSide(
                                color: theme.colorScheme.outline.withOpacity(
                                  borderOpacity,
                                ),
                              ),
                            ),
                          ),
                          Spacing.horizontalSm,
                          IconButton(
                            onPressed: _zoomOut,
                            icon: const Icon(Icons.zoom_out),
                            tooltip: l10n.zoomOut,
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surface,
                              side: BorderSide(
                                color: theme.colorScheme.outline.withOpacity(
                                  borderOpacity,
                                ),
                              ),
                            ),
                          ),
                          Spacing.horizontalSm,
                          IconButton(
                            onPressed: _resetZoom,
                            icon: const Icon(Icons.fit_screen),
                            tooltip: l10n.resetZoom,
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(Opacities.veryLow),
                              side: BorderSide(
                                color: theme.colorScheme.primary.withOpacity(
                                  borderOpacity,
                                ),
                              ),
                            ),
                          ),
                          Spacing.horizontalSm,
                          IconButton(
                            onPressed: _zoomIn,
                            icon: const Icon(Icons.zoom_in),
                            tooltip: l10n.zoomIn,
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surface,
                              side: BorderSide(
                                color: theme.colorScheme.outline.withOpacity(
                                  borderOpacity,
                                ),
                              ),
                            ),
                          ),
                          Spacing.horizontalSm,
                          IconButton(
                            onPressed: _panRight,
                            icon: const Icon(Icons.chevron_right),
                            tooltip: l10n.panRight,
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surface,
                              side: BorderSide(
                                color: theme.colorScheme.outline.withOpacity(
                                  borderOpacity,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                Spacing.verticalSm,

                // Notes section (scrolls with the page)
                Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.notes_rounded,
                            size: IconSizes.sm,
                            color: theme.colorScheme.primary,
                          ),
                          Spacing.horizontalSm,
                          Text(
                            l10n.notes,
                            style: TextStyle(
                              fontSize: FontSizes.title,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Spacing.verticalLg,

                      if (widget.session['notes'] != null &&
                          widget.session['notes'].isNotEmpty) ...[
                        Builder(
                          builder: (context) {
                            final isDark = theme.brightness == Brightness.dark;
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(Spacing.lg),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  isDark ? 0.05 : 0.08,
                                ),
                                borderRadius: BorderRadii.mdAll,
                                border: Border.all(
                                  color: theme.colorScheme.primary.withOpacity(
                                    isDark ? 0.3 : 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.note_outlined,
                                    size: FontSizes.title,
                                    color: theme.colorScheme.primary,
                                  ),
                                  Spacing.horizontalMd,
                                  Expanded(
                                    child: Text(
                                      widget.session['notes'],
                                      style: TextStyle(
                                        fontSize: FontSizes.md,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Spacing.verticalSm,
                      ],

                      if (_graphNotes.isNotEmpty) ...[
                        ..._graphNotes.asMap().entries.map((entry) {
                          final index = entry.key;
                          final note = entry.value;
                          final timeInSeconds = _xToSeconds(
                            note.x,
                          ).toStringAsFixed(2);
                          double? pressureAtNote;
                          if (note.x.toInt() >= 0 &&
                              note.x.toInt() < widget.chartData.length) {
                            pressureAtNote = widget.chartData[note.x.toInt()].y;
                          }

                          return GestureDetector(
                            onTap: () {
                              // 그래프 해당 시점으로 포커스
                              _focusOnTimePoint(note.x);

                              // 스낵바로 간단한 피드백
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Container(
                                        width: WidgetSizes.containerMediumLarge,
                                        height:
                                            WidgetSizes.containerMediumLarge,
                                        decoration: const BoxDecoration(
                                          color: ScoreColors.excellent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '#${index + 1}',
                                            style: const TextStyle(
                                              fontSize: FontSizes.xxs,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacing.horizontalMd,
                                      Text('${timeInSeconds}s - ${note.note}'),
                                    ],
                                  ),
                                  duration: AnimationDurations.snackBar,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Row(
                                    children: [
                                      Container(
                                        width: WidgetSizes.containerLarge,
                                        height: WidgetSizes.containerLarge,
                                        decoration: const BoxDecoration(
                                          color: ScoreColors.excellent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '#${index + 1}',
                                            style: const TextStyle(
                                              fontSize: FontSizes.xs,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacing.horizontalMd,
                                      Text(
                                        AppLocalizations.of(context)!.noteInfo,
                                      ),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InfoRow(
                                        icon: Icons.access_time,
                                        label: AppLocalizations.of(
                                          context,
                                        )!.elapsedTime,
                                        value: '${timeInSeconds}s',
                                        color: ScoreColors.intermediate,
                                      ),
                                      Spacing.verticalMd,
                                      if (pressureAtNote != null)
                                        InfoRow(
                                          icon: Icons.speed,
                                          label: AppLocalizations.of(
                                            context,
                                          )!.currentPressure,
                                          value:
                                              '${pressureAtNote.toStringAsFixed(1)} hPa',
                                          color: ScoreColors.poor,
                                        ),
                                      Spacing.verticalLg,
                                      const Divider(),
                                      Spacing.verticalSm,
                                      Text(
                                        AppLocalizations.of(context)!.notes,
                                        style: TextStyle(
                                          fontSize: FontSizes.bodySm,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(Opacities.medium),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacing.verticalSm,
                                      Text(
                                        note.note,
                                        style: const TextStyle(
                                          fontSize: FontSizes.body,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _focusOnTimePoint(note.x);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.center_focus_strong,
                                            size: IconSizes.sm + 2,
                                          ),
                                          Spacing.horizontalXs,
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.zoomIn,
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        AppLocalizations.of(context)!.close,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(Spacing.lg),
                              margin: const EdgeInsets.only(bottom: Spacing.sm),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withOpacity(
                                  Opacities.low,
                                ),
                                borderRadius: BorderRadii.mdAll,
                                border: Border.all(
                                  color: theme.colorScheme.secondary
                                      .withOpacity(Opacities.mediumHigh),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: WidgetSizes.containerXxl,
                                    height: WidgetSizes.containerXxl,
                                    decoration: const BoxDecoration(
                                      color: ScoreColors.excellent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '#${index + 1}',
                                        style: const TextStyle(
                                          fontSize: FontSizes.body,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacing.horizontalSm,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timeline,
                                            size: IconSizes.sm,
                                            color: theme.colorScheme.secondary,
                                          ),
                                          Spacing.horizontalXs,
                                          Text(
                                            '${timeInSeconds}s',
                                            style: TextStyle(
                                              fontSize: FontSizes.sm,
                                              color:
                                                  theme.colorScheme.secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacing.horizontalSm,
                                  Expanded(
                                    child: Text(
                                      note.note,
                                      style: TextStyle(
                                        fontSize: FontSizes.md,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.center_focus_strong,
                                    size: IconSizes.md,
                                    color: theme.colorScheme.secondary
                                        .withOpacity(Opacities.high),
                                  ),
                                  Spacing.horizontalSm,
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      size: IconSizes.md,
                                      color: theme.colorScheme.error,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      if (note.id != null) {
                                        final dbService =
                                            UnifiedDatabaseService();
                                        await dbService.deleteGraphNote(
                                          note.id!,
                                        );
                                      }
                                      setState(() {
                                        _graphNotes.remove(note);
                                        _invalidateNoteLinesCache(); // Refresh note lines immediately
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],

                      if ((widget.session['notes'] == null ||
                              widget.session['notes'].isEmpty) &&
                          _graphNotes.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(Spacing.xxl),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadii.mdAll,
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(
                                Opacities.mediumHigh,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.note_add_outlined,
                                size: IconSizes.huge,
                                color: theme.colorScheme.outline.withOpacity(
                                  Opacities.high,
                                ),
                              ),
                              Spacing.verticalSm,
                              Text(
                                l10n.noNotes,
                                style: TextStyle(
                                  fontSize: FontSizes.md,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Spacing.verticalXs,
                              Text(
                                l10n.tapGraphToAddNote,
                                style: TextStyle(
                                  fontSize: FontSizes.body,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
