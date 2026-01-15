// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/pressure_data.dart';
import 'database_interface.dart';

class SqliteDatabaseService implements IDatabaseService {
  static SqliteDatabaseService? _instance;
  static Database? _database;
  
  SqliteDatabaseService._();
  
  static SqliteDatabaseService get instance {
    _instance ??= SqliteDatabaseService._();
    return _instance!;
  }
  
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'divechecker.db');
    
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_time TEXT NOT NULL,
        end_time TEXT,
        max_pressure REAL NOT NULL,
        avg_pressure REAL NOT NULL,
        sample_rate INTEGER NOT NULL DEFAULT 8,
        notes TEXT,
        display_title TEXT,
        device_serial TEXT,
        device_name TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE pressure_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pressure REAL NOT NULL,
        timestamp TEXT NOT NULL,
        session_id INTEGER NOT NULL,
        FOREIGN KEY (session_id) REFERENCES sessions (id)
      )
    ''');
    
    await db.execute('''
      CREATE TABLE graph_notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        time_point REAL NOT NULL,
        note TEXT NOT NULL,
        FOREIGN KEY (session_id) REFERENCES sessions (id)
      )
    ''');
    
    await db.execute('CREATE INDEX idx_pressure_session ON pressure_data(session_id)');
    await db.execute('CREATE INDEX idx_notes_session ON graph_notes(session_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS graph_notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          session_id INTEGER NOT NULL,
          time_point REAL NOT NULL,
          note TEXT NOT NULL,
          FOREIGN KEY (session_id) REFERENCES sessions (id)
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE sessions ADD COLUMN display_title TEXT');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE sessions ADD COLUMN device_serial TEXT');
      await db.execute('ALTER TABLE sessions ADD COLUMN device_name TEXT');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_sessions_device ON sessions(device_serial)');
    }
  }

  @override
  Future<int> createSession(MeasurementSession session) async {
    final db = await database;
    return await db.insert('sessions', session.toMap());
  }

  @override
  Future<void> updateSession(MeasurementSession session) async {
    final db = await database;
    await db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  @override
  Future<void> updateSessionTitle(int sessionId, String? title) async {
    final db = await database;
    await db.update(
      'sessions',
      {'display_title': title},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  @override
  Future<List<MeasurementSession>> getAllSessions() async {
    final db = await database;
    final maps = await db.query('sessions', orderBy: 'start_time DESC');
    return maps.map((m) => MeasurementSession.fromMap(m)).toList();
  }

  @override
  Future<void> deleteSession(int sessionId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('graph_notes', where: 'session_id = ?', whereArgs: [sessionId]);
      await txn.delete('pressure_data', where: 'session_id = ?', whereArgs: [sessionId]);
      await txn.delete('sessions', where: 'id = ?', whereArgs: [sessionId]);
    });
  }

  @override
  Future<int> savePressureData(PressureData data) async {
    final db = await database;
    return await db.insert('pressure_data', data.toMap());
  }

  @override
  Future<void> savePressureDataBatch(List<PressureData> dataList) async {
    if (dataList.isEmpty) return;
    
    final db = await database;
    final batch = db.batch();
    
    for (var data in dataList) {
      batch.insert('pressure_data', data.toMap());
    }
    
    await batch.commit(noResult: true);
  }

  @override
  Future<List<PressureData>> getPressureDataBySession(int sessionId) async {
    final db = await database;
    final maps = await db.query(
      'pressure_data',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((m) => PressureData.fromMap(m)).toList();
  }

  @override
  Future<int> saveGraphNote(int sessionId, double timePoint, String note) async {
    final db = await database;
    return await db.insert('graph_notes', {
      'session_id': sessionId,
      'time_point': timePoint,
      'note': note,
    });
  }

  @override
  Future<List<GraphNote>> getGraphNotesBySession(int sessionId) async {
    final db = await database;
    final maps = await db.query(
      'graph_notes',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'time_point ASC',
    );
    return maps.map((m) => GraphNote.fromMap(m)).toList();
  }

  @override
  Future<void> deleteGraphNote(int noteId) async {
    final db = await database;
    await db.delete('graph_notes', where: 'id = ?', whereArgs: [noteId]);
  }

  @override
  Future<List<MeasurementSession>> getSessionsByDevice(String? deviceSerial) async {
    final db = await database;
    if (deviceSerial == null) {
      // Return all sessions
      return getAllSessions();
    }
    final maps = await db.query(
      'sessions',
      where: 'device_serial = ?',
      whereArgs: [deviceSerial],
      orderBy: 'start_time DESC',
    );
    return maps.map((m) => MeasurementSession.fromMap(m)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getUniqueDevices() async {
    final db = await database;
    // Get unique devices with their latest name and session count
    final result = await db.rawQuery('''
      SELECT 
        device_serial,
        device_name,
        COUNT(*) as session_count,
        MAX(start_time) as last_used
      FROM sessions 
      WHERE device_serial IS NOT NULL
      GROUP BY device_serial
      ORDER BY last_used DESC
    ''');
    
    return result.map((row) => {
      'serial': row['device_serial'] as String?,
      'name': row['device_name'] as String?,
      'sessionCount': row['session_count'] as int,
      'lastUsed': row['last_used'] as String?,
    }).toList();
  }

  @override
  Future<void> clearAll() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('graph_notes');
      await txn.delete('pressure_data');
      await txn.delete('sessions');
    });
  }

  @override
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
