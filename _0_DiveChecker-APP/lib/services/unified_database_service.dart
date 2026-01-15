// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Unified Database Service
/// 
/// Automatically selects the appropriate storage backend:
/// - Web: IndexedDB via idb_shim
/// - Native (Mobile/Desktop): SQLite
/// 
/// This provides a unified API regardless of platform.
/// 
/// Uses the new IDatabaseService interface from core/database.
library;

import '../models/pressure_data.dart';
import '../core/database/database_factory.dart';

/// Unified database interface that works on all platforms
/// 
/// Delegates to platform-specific implementation via DatabaseServiceFactory
class UnifiedDatabaseService {
  static final UnifiedDatabaseService _instance = UnifiedDatabaseService._internal();
  factory UnifiedDatabaseService() => _instance;
  UnifiedDatabaseService._internal();

  /// Get the platform-specific database service
  IDatabaseService get _db => DatabaseServiceFactory.instance;

  /// Create a new measurement session
  Future<int> createSession(MeasurementSession session) async {
    return await _db.createSession(session);
  }

  /// Save individual pressure data point
  Future<int> savePressureData(PressureData data) async {
    return await _db.savePressureData(data);
  }

  /// Batch save pressure data for performance optimization
  Future<void> savePressureDataBatch(List<PressureData> dataList) async {
    await _db.savePressureDataBatch(dataList);
  }

  /// Update session (on completion)
  Future<void> updateSession(MeasurementSession session) async {
    await _db.updateSession(session);
  }

  /// Update session display title
  Future<void> updateSessionTitle(int sessionId, String? title) async {
    await _db.updateSessionTitle(sessionId, title);
  }

  /// Get all measurement sessions
  Future<List<MeasurementSession>> getAllSessions() async {
    return await _db.getAllSessions();
  }

  /// Get pressure data for a specific session
  Future<List<PressureData>> getPressureDataBySession(int sessionId) async {
    return await _db.getPressureDataBySession(sessionId);
  }

  /// Delete a session and all related data
  Future<void> deleteSession(int sessionId) async {
    await _db.deleteSession(sessionId);
  }

  /// Save a graph note at a specific time point
  Future<int> saveGraphNote(int sessionId, double timePoint, String note) async {
    return await _db.saveGraphNote(sessionId, timePoint, note);
  }

  /// Get all graph notes for a session
  Future<List<Map<String, dynamic>>> getGraphNotesBySession(int sessionId) async {
    final notes = await _db.getGraphNotesBySession(sessionId);
    // Convert GraphNote to Map for backward compatibility
    return notes.map((note) => note.toMap()).toList();
  }

  /// Delete a graph note
  Future<void> deleteGraphNote(int noteId) async {
    await _db.deleteGraphNote(noteId);
  }
  
  /// Get sessions filtered by device serial (null = all devices)
  Future<List<MeasurementSession>> getSessionsByDevice(String? deviceSerial) async {
    return await _db.getSessionsByDevice(deviceSerial);
  }
  
  /// Get list of unique devices that have recorded sessions
  Future<List<Map<String, dynamic>>> getUniqueDevices() async {
    return await _db.getUniqueDevices();
  }
}

