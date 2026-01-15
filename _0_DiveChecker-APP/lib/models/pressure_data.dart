// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

class PressureData {
  final int? id;
  final double pressure;
  final DateTime timestamp;
  final int sessionId;

  const PressureData({
    this.id,
    required this.pressure,
    required this.timestamp,
    required this.sessionId,
  });

  factory PressureData.fromMap(Map<String, dynamic> map) {
    return PressureData(
      id: map['id'],
      pressure: (map['pressure'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      sessionId: map['session_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'pressure': pressure,
      'timestamp': timestamp.toIso8601String(),
      'session_id': sessionId,
    };
  }
  
  PressureData copyWith({
    int? id,
    double? pressure,
    DateTime? timestamp,
    int? sessionId,
  }) {
    return PressureData(
      id: id ?? this.id,
      pressure: pressure ?? this.pressure,
      timestamp: timestamp ?? this.timestamp,
      sessionId: sessionId ?? this.sessionId,
    );
  }
  
  @override
  String toString() => 'PressureData(id: $id, pressure: $pressure, sessionId: $sessionId)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PressureData &&
        other.id == id &&
        other.pressure == pressure &&
        other.timestamp == timestamp &&
        other.sessionId == sessionId;
  }
  
  @override
  int get hashCode => Object.hash(id, pressure, timestamp, sessionId);
}

class MeasurementSession {
  final int? id;
  final DateTime startTime;
  final DateTime? endTime;
  final double maxPressure;
  final double avgPressure;
  final int sampleRate;         // Sample rate in Hz at time of recording
  final String? notes;
  final String? displayTitle;
  final String? deviceSerial;   // Device unique serial number
  final String? deviceName;     // Device display name at time of recording

  const MeasurementSession({
    this.id,
    required this.startTime,
    this.endTime,
    required this.maxPressure,
    required this.avgPressure,
    this.sampleRate = 8,        // Default 8Hz
    this.notes,
    this.displayTitle,
    this.deviceSerial,
    this.deviceName,
  });

  factory MeasurementSession.fromMap(Map<String, dynamic> map) {
    return MeasurementSession(
      id: map['id'],
      startTime: DateTime.parse(map['start_time']),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      maxPressure: (map['max_pressure'] as num).toDouble(),
      avgPressure: (map['avg_pressure'] as num).toDouble(),
      sampleRate: map['sample_rate'] ?? 8,
      notes: map['notes'],
      displayTitle: map['display_title'],
      deviceSerial: map['device_serial'],
      deviceName: map['device_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'max_pressure': maxPressure,
      'avg_pressure': avgPressure,
      'sample_rate': sampleRate,
      'notes': notes,
      'display_title': displayTitle,
      'device_serial': deviceSerial,
      'device_name': deviceName,
    };
  }

  int get duration {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inSeconds;
  }
  
  Duration get durationDelta {
    if (endTime == null) return Duration.zero;
    return endTime!.difference(startTime);
  }
  
  bool get isRunning => endTime == null;
  
  MeasurementSession copyWith({
    int? id,
    DateTime? startTime,
    DateTime? endTime,
    double? maxPressure,
    double? avgPressure,
    int? sampleRate,
    String? notes,
    String? displayTitle,
    String? deviceSerial,
    String? deviceName,
  }) {
    return MeasurementSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      maxPressure: maxPressure ?? this.maxPressure,
      avgPressure: avgPressure ?? this.avgPressure,
      sampleRate: sampleRate ?? this.sampleRate,
      notes: notes ?? this.notes,
      displayTitle: displayTitle ?? this.displayTitle,
      deviceSerial: deviceSerial ?? this.deviceSerial,
      deviceName: deviceName ?? this.deviceName,
    );
  }
  
  @override
  String toString() => 'MeasurementSession(id: $id, duration: ${duration}s, max: $maxPressure, device: $deviceSerial)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeasurementSession &&
        other.id == id &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.maxPressure == maxPressure &&
        other.avgPressure == avgPressure &&
        other.notes == notes &&
        other.deviceSerial == deviceSerial;
  }
  
  @override
  int get hashCode => Object.hash(id, startTime, endTime, maxPressure, avgPressure, notes, deviceSerial);
}
