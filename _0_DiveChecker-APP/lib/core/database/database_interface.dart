// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import '../../models/pressure_data.dart';

class GraphNote {
  final int? id;
  final int sessionId;
  final double timePoint;
  final String note;

  GraphNote({
    this.id,
    required this.sessionId,
    required this.timePoint,
    required this.note,
  });

  factory GraphNote.fromMap(Map<String, dynamic> map) {
    return GraphNote(
      id: map['id'] as int?,
      sessionId: map['session_id'] as int,
      timePoint: (map['time_point'] as num).toDouble(),
      note: map['note'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'session_id': sessionId,
      'time_point': timePoint,
      'note': note,
    };
  }
}

abstract class IDatabaseService {
  
  Future<int> createSession(MeasurementSession session);
  
  Future<void> updateSession(MeasurementSession session);
  
  Future<void> updateSessionTitle(int sessionId, String? title);
  
  Future<List<MeasurementSession>> getAllSessions();
  
  Future<void> deleteSession(int sessionId);
  
  Future<int> savePressureData(PressureData data);
  
  Future<void> savePressureDataBatch(List<PressureData> dataList);
  
  Future<List<PressureData>> getPressureDataBySession(int sessionId);
  
  Future<int> saveGraphNote(int sessionId, double timePoint, String note);
  
  Future<List<GraphNote>> getGraphNotesBySession(int sessionId);
  
  Future<void> deleteGraphNote(int noteId);
  
  /// Get all sessions filtered by device serial (null = all devices)
  Future<List<MeasurementSession>> getSessionsByDevice(String? deviceSerial);
  
  /// Get list of unique devices that have recorded sessions
  /// Returns list of {serial, name, sessionCount}
  Future<List<Map<String, dynamic>>> getUniqueDevices();
  
  Future<void> clearAll();
  
  Future<void> close();
}
