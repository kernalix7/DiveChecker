// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

import '../models/pressure_data.dart';
import '../services/unified_database_service.dart';

class SessionData {
  final int? id;
  final DateTime date;
  final double maxPressure;
  final double avgPressure;
  final int duration;
  final String notes;
  final String? displayTitle;
  final String? deviceSerial;
  final String? deviceName;
  final List<FlSpot> chartData;
  final List<Map<String, dynamic>> graphNotes;

  const SessionData({
    this.id,
    required this.date,
    required this.maxPressure,
    required this.avgPressure,
    required this.duration,
    this.notes = '',
    this.displayTitle,
    this.deviceSerial,
    this.deviceName,
    this.chartData = const [],
    this.graphNotes = const [],
  });

  factory SessionData.fromSession(
    MeasurementSession session, {
    List<FlSpot> chartData = const [],
    List<Map<String, dynamic>> graphNotes = const [],
  }) {
    return SessionData(
      id: session.id,
      date: session.startTime,
      maxPressure: session.maxPressure,
      avgPressure: session.avgPressure,
      duration: session.duration,
      notes: session.notes ?? '',
      displayTitle: session.displayTitle,
      deviceSerial: session.deviceSerial,
      deviceName: session.deviceName,
      chartData: chartData,
      graphNotes: graphNotes,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date,
    'maxPressure': maxPressure,
    'avgPressure': avgPressure,
    'duration': duration,
    'notes': notes,
    'displayTitle': displayTitle,
    'deviceSerial': deviceSerial,
    'deviceName': deviceName,
    'chartData': chartData,
    'graphNotes': graphNotes,
  };

  SessionData copyWith({
    int? id,
    DateTime? date,
    double? maxPressure,
    double? avgPressure,
    int? duration,
    String? notes,
    String? displayTitle,
    String? deviceSerial,
    String? deviceName,
    List<FlSpot>? chartData,
    List<Map<String, dynamic>>? graphNotes,
  }) {
    return SessionData(
      id: id ?? this.id,
      date: date ?? this.date,
      maxPressure: maxPressure ?? this.maxPressure,
      avgPressure: avgPressure ?? this.avgPressure,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      displayTitle: displayTitle ?? this.displayTitle,
      deviceSerial: deviceSerial ?? this.deviceSerial,
      deviceName: deviceName ?? this.deviceName,
      chartData: chartData ?? this.chartData,
      graphNotes: graphNotes ?? this.graphNotes,
    );
  }
}

class SessionRepository extends ChangeNotifier {
  final UnifiedDatabaseService _dbService;
  
  List<SessionData> _sessions = [];
  bool _isLoading = false;
  String? _error;
  String? _deviceFilter;  // null = all devices

  SessionRepository({UnifiedDatabaseService? dbService})
      : _dbService = dbService ?? UnifiedDatabaseService();

  List<SessionData> get sessions => List.unmodifiable(_sessions);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get count => _sessions.length;
  bool get isEmpty => _sessions.isEmpty;
  String? get deviceFilter => _deviceFilter;

  Future<void> loadSessions() async {
    // Prevent duplicate loading
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dbSessions = _deviceFilter == null 
          ? await _dbService.getAllSessions()
          : await _dbService.getSessionsByDevice(_deviceFilter);
      _sessions = [];

      for (var session in dbSessions) {
        // Skip if already exists (by ID)
        if (_sessions.any((s) => s.id == session.id)) continue;
        
        // Load pressure data
        final pressureData = await _dbService.getPressureDataBySession(session.id!);
        final chartData = pressureData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.pressure);
        }).toList();

        // Load graph notes
        final graphNotes = await _dbService.getGraphNotesBySession(session.id!);

        _sessions.add(SessionData.fromSession(
          session,
          chartData: chartData,
          graphNotes: graphNotes,
        ));
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('SessionRepository: Error loading sessions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Filter sessions by device serial
  Future<void> filterByDevice(String? deviceSerial) async {
    _deviceFilter = deviceSerial;
    await loadSessions();
  }
  
  /// Get list of unique devices with session counts
  Future<List<Map<String, dynamic>>> getUniqueDevices() async {
    try {
      return await _dbService.getUniqueDevices();
    } catch (e) {
      debugPrint('Error getting unique devices: $e');
      return [];
    }
  }

  void addSession(SessionData session) {
    _sessions.insert(0, session);
    notifyListeners();
  }

  Future<void> deleteSession(int sessionId) async {
    try {
      await _dbService.deleteSession(sessionId);
      _sessions.removeWhere((s) => s.id == sessionId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  SessionData? getSessionById(int id) {
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> refresh() => loadSessions();

  Future<void> updateDisplayTitle(int sessionId, String? title) async {
    try {
      await _dbService.updateSessionTitle(sessionId, title);
      
      // Update cache
      final index = _sessions.indexWhere((s) => s.id == sessionId);
      if (index != -1) {
        _sessions[index] = _sessions[index].copyWith(displayTitle: title);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
