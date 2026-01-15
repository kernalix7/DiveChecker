// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/pressure_data.dart';
import 'unified_database_service.dart';

import 'dart:async';

class BackupData {
  final String version;
  final DateTime exportDate;
  final String appName;
  final List<MeasurementSession> sessions;
  final Map<int, List<PressureData>> pressureData;
  final Map<int, List<Map<String, dynamic>>> graphNotes;

  BackupData({
    required this.version,
    required this.exportDate,
    required this.appName,
    required this.sessions,
    required this.pressureData,
    required this.graphNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'exportDate': exportDate.toIso8601String(),
      'appName': appName,
      'sessions': sessions.map((s) => s.toMap()).toList(),
      'pressureData': pressureData.map(
        (sessionId, dataList) => MapEntry(
          sessionId.toString(),
          dataList.map((d) => d.toMap()).toList(),
        ),
      ),
      'graphNotes': graphNotes.map(
        (sessionId, notes) => MapEntry(sessionId.toString(), notes),
      ),
    };
  }

  factory BackupData.fromJson(Map<String, dynamic> json) {
    final sessions = (json['sessions'] as List)
        .map((s) => MeasurementSession.fromMap(s))
        .toList();

    final pressureData = <int, List<PressureData>>{};
    final pressureJson = json['pressureData'] as Map<String, dynamic>;
    pressureJson.forEach((sessionIdStr, dataList) {
      final sessionId = int.parse(sessionIdStr);
      pressureData[sessionId] = (dataList as List)
          .map((d) => PressureData.fromMap(d))
          .toList();
    });

    final graphNotes = <int, List<Map<String, dynamic>>>{};
    final notesJson = json['graphNotes'] as Map<String, dynamic>;
    notesJson.forEach((sessionIdStr, notes) {
      final sessionId = int.parse(sessionIdStr);
      graphNotes[sessionId] = (notes as List)
          .map((n) => Map<String, dynamic>.from(n))
          .toList();
    });

    return BackupData(
      version: json['version'] ?? '1.0',
      exportDate: DateTime.parse(json['exportDate']),
      appName: json['appName'] ?? 'DiveChecker',
      sessions: sessions,
      pressureData: pressureData,
      graphNotes: graphNotes,
    );
  }

  BackupStats get stats {
    int totalDataPoints = 0;
    int totalNotes = 0;
    
    for (var dataList in pressureData.values) {
      totalDataPoints += dataList.length;
    }
    for (var notesList in graphNotes.values) {
      totalNotes += notesList.length;
    }

    return BackupStats(
      sessionCount: sessions.length,
      dataPointCount: totalDataPoints,
      noteCount: totalNotes,
    );
  }
}

class BackupStats {
  final int sessionCount;
  final int dataPointCount;
  final int noteCount;

  BackupStats({
    required this.sessionCount,
    required this.dataPointCount,
    required this.noteCount,
  });
}

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  final UnifiedDatabaseService _db = UnifiedDatabaseService();
  
  static const String _backupVersion = '1.0';
  static const String _appName = 'DiveChecker';

  Future<BackupData> createBackup({
    void Function(double progress, String status)? onProgress,
  }) async {
    onProgress?.call(0.0, 'Loading sessions...');
    
    final sessions = await _db.getAllSessions();
    
    final pressureData = <int, List<PressureData>>{};
    final graphNotes = <int, List<Map<String, dynamic>>>{};
    
    for (var i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      final sessionId = session.id!;
      
      final progress = (i + 1) / sessions.length;
      onProgress?.call(progress * 0.9, 'Loading session ${i + 1}/${sessions.length}...');
      
      pressureData[sessionId] = await _db.getPressureDataBySession(sessionId);
      
      graphNotes[sessionId] = await _db.getGraphNotesBySession(sessionId);
    }
    
    onProgress?.call(1.0, 'Backup complete!');
    
    return BackupData(
      version: _backupVersion,
      exportDate: DateTime.now(),
      appName: _appName,
      sessions: sessions,
      pressureData: pressureData,
      graphNotes: graphNotes,
    );
  }

  String backupToJson(BackupData backup) {
    return const JsonEncoder.withIndent('  ').convert(backup.toJson());
  }

  BackupData? parseBackup(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return BackupData.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  BackupValidationResult validateBackup(BackupData backup) {
    final errors = <String>[];
    final warnings = <String>[];

    if (backup.version != _backupVersion) {
      warnings.add('Backup version (${backup.version}) differs from current ($_backupVersion)');
    }

    if (backup.appName != _appName) {
      warnings.add('Backup from different app: ${backup.appName}');
    }

    if (backup.sessions.isEmpty) {
      warnings.add('No sessions in backup');
    }

    for (var session in backup.sessions) {
      if (session.id == null) {
        errors.add('Session missing ID');
      }
    }

    return BackupValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  Future<RestoreResult> restoreBackup(
    BackupData backup, {
    RestoreMode mode = RestoreMode.replace,
    void Function(double progress, String status)? onProgress,
  }) async {
    int sessionsRestored = 0;
    int dataPointsRestored = 0;
    int notesRestored = 0;
    final errors = <String>[];

    try {
      onProgress?.call(0.0, 'Preparing restore...');

      final sessionIdMap = <int, int>{};

      if (mode == RestoreMode.replace) {
        onProgress?.call(0.05, 'Clearing existing data...');
        final existingSessions = await _db.getAllSessions();
        for (var session in existingSessions) {
          await _db.deleteSession(session.id!);
        }
      }

      for (var i = 0; i < backup.sessions.length; i++) {
        final oldSession = backup.sessions[i];
        final oldId = oldSession.id!;
        
        final progress = 0.1 + (i / backup.sessions.length) * 0.3;
        onProgress?.call(progress, 'Restoring session ${i + 1}/${backup.sessions.length}...');

        try {
          final newSession = MeasurementSession(
            startTime: oldSession.startTime,
            endTime: oldSession.endTime,
            maxPressure: oldSession.maxPressure,
            avgPressure: oldSession.avgPressure,
            notes: oldSession.notes,
          );
          
          final newId = await _db.createSession(newSession);
          sessionIdMap[oldId] = newId;
          sessionsRestored++;
        } catch (e) {
          errors.add('Failed to restore session $oldId: $e');
        }
      }

      var processedSessions = 0;
      final totalSessions = backup.pressureData.length;
      
      for (var entry in backup.pressureData.entries) {
        final oldSessionId = entry.key;
        final dataList = entry.value;
        final newSessionId = sessionIdMap[oldSessionId];
        
        if (newSessionId == null) {
          errors.add('No mapping for session $oldSessionId');
          continue;
        }

        final progress = 0.4 + (processedSessions / totalSessions) * 0.4;
        onProgress?.call(progress, 'Restoring pressure data...');

        try {
          final newDataList = dataList.map((d) => PressureData(
            pressure: d.pressure,
            timestamp: d.timestamp,
            sessionId: newSessionId,
          )).toList();

          await _db.savePressureDataBatch(newDataList);
          dataPointsRestored += newDataList.length;
        } catch (e) {
          errors.add('Failed to restore pressure data for session $oldSessionId: $e');
        }
        
        processedSessions++;
      }

      processedSessions = 0;
      final totalNoteSessions = backup.graphNotes.length;
      
      for (var entry in backup.graphNotes.entries) {
        final oldSessionId = entry.key;
        final notes = entry.value;
        final newSessionId = sessionIdMap[oldSessionId];
        
        if (newSessionId == null) continue;

        final progress = 0.8 + (processedSessions / totalNoteSessions) * 0.2;
        onProgress?.call(progress, 'Restoring notes...');

        for (var note in notes) {
          try {
            await _db.saveGraphNote(
              newSessionId,
              (note['time_point'] as num).toDouble(),
              note['note'] as String,
            );
            notesRestored++;
          } catch (e) {
            errors.add('Failed to restore note: $e');
          }
        }
        
        processedSessions++;
      }

      onProgress?.call(1.0, 'Restore complete!');

    } catch (e) {
      errors.add('Restore failed: $e');
    }

    return RestoreResult(
      success: errors.isEmpty,
      sessionsRestored: sessionsRestored,
      dataPointsRestored: dataPointsRestored,
      notesRestored: notesRestored,
      errors: errors,
    );
  }

  String generateBackupFilename() {
    final now = DateTime.now();
    final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    return 'divechecker_backup_$timestamp.json';
  }

  bool get isWeb => kIsWeb;
}

enum RestoreMode {
  replace,
  merge,
}

class BackupValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  BackupValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });
}

class RestoreResult {
  final bool success;
  final int sessionsRestored;
  final int dataPointsRestored;
  final int notesRestored;
  final List<String> errors;

  RestoreResult({
    required this.success,
    required this.sessionsRestored,
    required this.dataPointsRestored,
    required this.notesRestored,
    required this.errors,
  });
}
