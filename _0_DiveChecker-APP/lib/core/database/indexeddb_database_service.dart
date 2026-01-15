// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:idb_shim/idb_browser.dart';
import '../../models/pressure_data.dart';
import 'database_interface.dart';

class IndexedDbDatabaseService implements IDatabaseService {
  static IndexedDbDatabaseService? _instance;
  
  IndexedDbDatabaseService._();
  
  static IndexedDbDatabaseService get instance {
    _instance ??= IndexedDbDatabaseService._();
    return _instance!;
  }
  
  static const String _dbName = 'divechecker_db';
  static const int _dbVersion = 1;
  
  static const String _sessionsStore = 'sessions';
  static const String _pressureDataStore = 'pressure_data';
  static const String _graphNotesStore = 'graph_notes';

  Database? _db;
  final IdbFactory _idbFactory = idbFactoryBrowser;
  
  List<MeasurementSession>? _sessionsCache;
  final Map<int, List<PressureData>> _pressureDataCache = {};
  final Map<int, List<GraphNote>> _graphNotesCache = {};
  
  bool _sessionsCacheValid = false;
  final Set<int> _pressureCacheValidSessions = {};
  final Set<int> _notesCacheValidSessions = {};
  
  void _invalidateSessionsCache() {
    _sessionsCacheValid = false;
    _sessionsCache = null;
  }
  
  void _invalidatePressureCache(int sessionId) {
    _pressureCacheValidSessions.remove(sessionId);
    _pressureDataCache.remove(sessionId);
  }
  
  void _invalidateNotesCache(int sessionId) {
    _notesCacheValidSessions.remove(sessionId);
    _graphNotesCache.remove(sessionId);
  }
  
  void clearCache() {
    _sessionsCache = null;
    _sessionsCacheValid = false;
    _pressureDataCache.clear();
    _pressureCacheValidSessions.clear();
    _graphNotesCache.clear();
    _notesCacheValidSessions.clear();
  }

  Future<Database> get database async {
    _db ??= await _openDatabase();
    return _db!;
  }

  Future<Database> _openDatabase() async {
    return await _idbFactory.open(
      _dbName,
      version: _dbVersion,
      onUpgradeNeeded: (VersionChangeEvent event) {
        final db = event.database;
        
        if (!db.objectStoreNames.contains(_sessionsStore)) {
          final store = db.createObjectStore(_sessionsStore, keyPath: 'id', autoIncrement: true);
          store.createIndex('start_time', 'start_time');
        }
        
        if (!db.objectStoreNames.contains(_pressureDataStore)) {
          final store = db.createObjectStore(_pressureDataStore, keyPath: 'id', autoIncrement: true);
          store.createIndex('session_id', 'session_id');
          store.createIndex('timestamp', 'timestamp');
        }
        
        if (!db.objectStoreNames.contains(_graphNotesStore)) {
          final store = db.createObjectStore(_graphNotesStore, keyPath: 'id', autoIncrement: true);
          store.createIndex('session_id', 'session_id');
          store.createIndex('time_point', 'time_point');
        }
      },
    );
  }

  @override
  Future<int> createSession(MeasurementSession session) async {
    final db = await database;
    final txn = db.transaction(_sessionsStore, idbModeReadWrite);
    final store = txn.objectStore(_sessionsStore);
    
    final sessionMap = session.toMap()..remove('id');
    final id = await store.add(sessionMap);
    await txn.completed;
    
    _invalidateSessionsCache();
    return id as int;
  }

  @override
  Future<void> updateSession(MeasurementSession session) async {
    final db = await database;
    final txn = db.transaction(_sessionsStore, idbModeReadWrite);
    final store = txn.objectStore(_sessionsStore);
    
    await store.put(session.toMap());
    await txn.completed;
    
    _invalidateSessionsCache();
  }

  @override
  Future<void> updateSessionTitle(int sessionId, String? title) async {
    final db = await database;
    final txn = db.transaction(_sessionsStore, idbModeReadWrite);
    final store = txn.objectStore(_sessionsStore);
    
    // Get existing session
    final existing = await store.getObject(sessionId);
    if (existing != null) {
      final map = Map<String, dynamic>.from(existing as Map);
      map['display_title'] = title;
      await store.put(map);
    }
    
    await txn.completed;
    _invalidateSessionsCache();
  }

  @override
  Future<List<MeasurementSession>> getAllSessions() async {
    if (_sessionsCacheValid && _sessionsCache != null) {
      return List.from(_sessionsCache!);
    }
    
    final db = await database;
    final txn = db.transaction(_sessionsStore, idbModeReadOnly);
    final store = txn.objectStore(_sessionsStore);
    
    final sessions = <MeasurementSession>[];
    final cursor = store.openCursor(autoAdvance: true);
    
    await cursor.forEach((cursor) {
      final map = Map<String, dynamic>.from(cursor.value as Map);
      map['id'] = cursor.key;
      sessions.add(MeasurementSession.fromMap(map));
    });
    
    await txn.completed;
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    
    _sessionsCache = List.from(sessions);
    _sessionsCacheValid = true;
    
    return sessions;
  }

  @override
  Future<void> deleteSession(int sessionId) async {
    final db = await database;
    
    // Delete notes
    var txn = db.transaction(_graphNotesStore, idbModeReadWrite);
    var store = txn.objectStore(_graphNotesStore);
    var index = store.index('session_id');
    var cursor = index.openCursor(key: sessionId, autoAdvance: false);
    await cursor.forEach((c) async {
      await c.delete();
      c.next();
    });
    await txn.completed;
    
    // Delete pressure data
    txn = db.transaction(_pressureDataStore, idbModeReadWrite);
    store = txn.objectStore(_pressureDataStore);
    index = store.index('session_id');
    cursor = index.openCursor(key: sessionId, autoAdvance: false);
    await cursor.forEach((c) async {
      await c.delete();
      c.next();
    });
    await txn.completed;
    
    // Delete session
    txn = db.transaction(_sessionsStore, idbModeReadWrite);
    store = txn.objectStore(_sessionsStore);
    await store.delete(sessionId);
    await txn.completed;
    
    _invalidateSessionsCache();
    _invalidatePressureCache(sessionId);
    _invalidateNotesCache(sessionId);
  }

  @override
  Future<int> savePressureData(PressureData data) async {
    final db = await database;
    final txn = db.transaction(_pressureDataStore, idbModeReadWrite);
    final store = txn.objectStore(_pressureDataStore);
    
    final dataMap = data.toMap()..remove('id');
    final id = await store.add(dataMap);
    await txn.completed;
    
    _invalidatePressureCache(data.sessionId);
    return id as int;
  }

  @override
  Future<void> savePressureDataBatch(List<PressureData> dataList) async {
    if (dataList.isEmpty) return;
    
    final db = await database;
    final txn = db.transaction(_pressureDataStore, idbModeReadWrite);
    final store = txn.objectStore(_pressureDataStore);
    
    final futures = <Future>[];
    for (var data in dataList) {
      final dataMap = data.toMap()..remove('id');
      futures.add(store.add(dataMap));
    }
    
    await Future.wait(futures);
    await txn.completed;
    
    for (var sessionId in dataList.map((d) => d.sessionId).toSet()) {
      _invalidatePressureCache(sessionId);
    }
  }

  @override
  Future<List<PressureData>> getPressureDataBySession(int sessionId) async {
    if (_pressureCacheValidSessions.contains(sessionId) && 
        _pressureDataCache.containsKey(sessionId)) {
      return List.from(_pressureDataCache[sessionId]!);
    }
    
    final db = await database;
    final txn = db.transaction(_pressureDataStore, idbModeReadOnly);
    final store = txn.objectStore(_pressureDataStore);
    final index = store.index('session_id');
    
    final dataList = <PressureData>[];
    final cursor = index.openCursor(key: sessionId, autoAdvance: true);
    
    await cursor.forEach((cursor) {
      final map = Map<String, dynamic>.from(cursor.value as Map);
      map['id'] = cursor.primaryKey;
      dataList.add(PressureData.fromMap(map));
    });
    
    await txn.completed;
    dataList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    _pressureDataCache[sessionId] = List.from(dataList);
    _pressureCacheValidSessions.add(sessionId);
    
    return dataList;
  }

  @override
  Future<int> saveGraphNote(int sessionId, double timePoint, String note) async {
    final db = await database;
    final txn = db.transaction(_graphNotesStore, idbModeReadWrite);
    final store = txn.objectStore(_graphNotesStore);
    
    final noteMap = {
      'session_id': sessionId,
      'time_point': timePoint,
      'note': note,
    };
    
    final id = await store.add(noteMap);
    await txn.completed;
    
    _invalidateNotesCache(sessionId);
    return id as int;
  }

  @override
  Future<List<GraphNote>> getGraphNotesBySession(int sessionId) async {
    if (_notesCacheValidSessions.contains(sessionId) && 
        _graphNotesCache.containsKey(sessionId)) {
      return List.from(_graphNotesCache[sessionId]!);
    }
    
    final db = await database;
    final txn = db.transaction(_graphNotesStore, idbModeReadOnly);
    final store = txn.objectStore(_graphNotesStore);
    final index = store.index('session_id');
    
    final notes = <GraphNote>[];
    final cursor = index.openCursor(key: sessionId, autoAdvance: true);
    
    await cursor.forEach((cursor) {
      final map = Map<String, dynamic>.from(cursor.value as Map);
      map['id'] = cursor.primaryKey;
      notes.add(GraphNote.fromMap(map));
    });
    
    await txn.completed;
    notes.sort((a, b) => a.timePoint.compareTo(b.timePoint));
    
    _graphNotesCache[sessionId] = List.from(notes);
    _notesCacheValidSessions.add(sessionId);
    
    return notes;
  }

  @override
  Future<void> deleteGraphNote(int noteId) async {
    final db = await database;
    final txn = db.transaction(_graphNotesStore, idbModeReadWrite);
    final store = txn.objectStore(_graphNotesStore);
    
    await store.delete(noteId);
    await txn.completed;
    
    _graphNotesCache.clear();
    _notesCacheValidSessions.clear();
  }

  @override
  Future<List<MeasurementSession>> getSessionsByDevice(String? deviceSerial) async {
    final allSessions = await getAllSessions();
    if (deviceSerial == null) {
      return allSessions;
    }
    return allSessions.where((s) => s.deviceSerial == deviceSerial).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getUniqueDevices() async {
    final allSessions = await getAllSessions();
    
    // Group by device serial
    final deviceMap = <String, Map<String, dynamic>>{};
    
    for (final session in allSessions) {
      if (session.deviceSerial != null) {
        final serial = session.deviceSerial!;
        if (!deviceMap.containsKey(serial)) {
          deviceMap[serial] = {
            'serial': serial,
            'name': session.deviceName ?? 'DiveChecker',
            'sessionCount': 1,
            'lastUsed': session.startTime.toIso8601String(),
          };
        } else {
          deviceMap[serial]!['sessionCount'] = (deviceMap[serial]!['sessionCount'] as int) + 1;
          // Update name to most recent
          if (session.startTime.isAfter(DateTime.parse(deviceMap[serial]!['lastUsed'] as String))) {
            deviceMap[serial]!['name'] = session.deviceName ?? 'DiveChecker';
            deviceMap[serial]!['lastUsed'] = session.startTime.toIso8601String();
          }
        }
      }
    }
    
    // Sort by last used
    final devices = deviceMap.values.toList();
    devices.sort((a, b) => (b['lastUsed'] as String).compareTo(a['lastUsed'] as String));
    
    return devices;
  }

  @override
  Future<void> clearAll() async {
    final db = await database;
    final txn = db.transactionList(
      [_sessionsStore, _pressureDataStore, _graphNotesStore],
      idbModeReadWrite,
    );
    
    await txn.objectStore(_sessionsStore).clear();
    await txn.objectStore(_pressureDataStore).clear();
    await txn.objectStore(_graphNotesStore).clear();
    
    await txn.completed;
    clearCache();
  }

  @override
  Future<void> close() async {
    _db?.close();
    _db = null;
    clearCache();
  }
}
