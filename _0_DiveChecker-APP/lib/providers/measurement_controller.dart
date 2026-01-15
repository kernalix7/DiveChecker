// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

import '../models/pressure_data.dart';
import '../services/unified_database_service.dart';
import '../constants/app_constants.dart';
import 'serial_provider.dart';
import 'settings_provider.dart';

class MeasurementState {
  final bool isMeasuring;
  final bool isPaused;
  final double currentPressure;
  final List<FlSpot> pressureData;
  final double maxPressure;
  final double avgPressure;
  final double minX;
  final double maxX;
  final DateTime? sessionStartTime;
  final Duration elapsedTime;
  
  const MeasurementState({
    this.isMeasuring = false,
    this.isPaused = false,
    this.currentPressure = 0.0,
    this.pressureData = const [],
    this.maxPressure = 0.0,
    this.avgPressure = 0.0,
    this.minX = 0,
    this.maxX = 30000,
    this.sessionStartTime,
    this.elapsedTime = Duration.zero,
  });
  
  MeasurementState copyWith({
    bool? isMeasuring,
    bool? isPaused,
    double? currentPressure,
    List<FlSpot>? pressureData,
    double? maxPressure,
    double? avgPressure,
    double? minX,
    double? maxX,
    DateTime? sessionStartTime,
    Duration? elapsedTime,
  }) {
    return MeasurementState(
      isMeasuring: isMeasuring ?? this.isMeasuring,
      isPaused: isPaused ?? this.isPaused,
      currentPressure: currentPressure ?? this.currentPressure,
      pressureData: pressureData ?? this.pressureData,
      maxPressure: maxPressure ?? this.maxPressure,
      avgPressure: avgPressure ?? this.avgPressure,
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
    );
  }
}

class MeasurementController extends ChangeNotifier {
  final SerialProvider _serialProvider;
  final UnifiedDatabaseService _dbService = UnifiedDatabaseService();
  
  MeasurementState _state = const MeasurementState();
  MeasurementState get state => _state;
  
  Timer? _measurementTimer;
  StreamSubscription<double>? _pressureSubscription;
  
  // Single data list - firmware output rate = display rate = storage rate
  final List<FlSpot> _dataList = [];
  
  MeasurementController({
    required SerialProvider serialProvider,
    SettingsProvider? settingsProvider,  // Keep for backward compatibility but unused
  })  : _serialProvider = serialProvider {
    _pressureSubscription = _serialProvider.pressureStream.listen(_onPressureReceived);
  }
  
  void _onPressureReceived(double pressure) {
    // Firmware already applies averaging filter (100Hz → outputRate with mean)
    // Just use the filtered value directly - no decimation needed
    _state = _state.copyWith(currentPressure: pressure);
    
    if (_state.isMeasuring && !_state.isPaused && _state.sessionStartTime != null) {
      final elapsedMs = DateTime.now().difference(_state.sessionStartTime!).inMilliseconds;
      
      // Store all data - firmware output rate = display rate = storage rate
      _dataList.add(FlSpot(elapsedMs.toDouble(), pressure));
      
      if (_dataList.length > MeasurementConfig.maxDataPoints) {
        _dataList.removeAt(0);
      }
    }
    
    notifyListeners();
  }
  
  /// Current firmware output rate (Hz)
  int get outputRate => _serialProvider.outputRate;
  
  bool get isConnected => _serialProvider.isConnected;
  
  double get currentPressure => _serialProvider.currentPressure;
  
  void startMeasurement() {
    if (!isConnected) return;
    
    _dataList.clear();
    
    _state = MeasurementState(
      isMeasuring: true,
      isPaused: false,
      currentPressure: _serialProvider.currentPressure,
      pressureData: [],
      maxPressure: 0.0,
      avgPressure: 0.0,
      minX: 0,
      maxX: 30000,
      sessionStartTime: DateTime.now(),
      elapsedTime: Duration.zero,
    );
    notifyListeners();
    
    _startMeasurementTimer();
  }
  
  void _startMeasurementTimer() {
    const updateIntervalMs = 100;
    
    _measurementTimer = Timer.periodic(
      const Duration(milliseconds: updateIntervalMs),
      (timer) {
        if (_state.sessionStartTime == null || _state.isPaused) return;
        
        final elapsedMs = DateTime.now().difference(_state.sessionStartTime!).inMilliseconds;
        
        double minX = _state.minX;
        double maxX = _state.maxX;
        if (elapsedMs > maxX) {
          minX = elapsedMs - 30000;
          maxX = elapsedMs.toDouble();
        }
        
        double maxPressure = 0.0;
        double avgPressure = 0.0;
        if (_dataList.isNotEmpty) {
          maxPressure = _dataList.map((e) => e.y).reduce(max);
          avgPressure = _dataList.map((e) => e.y).reduce((a, b) => a + b) / _dataList.length;
        }
        
        _state = _state.copyWith(
          pressureData: List.unmodifiable(_dataList),
          maxPressure: maxPressure,
          avgPressure: avgPressure,
          minX: minX,
          maxX: maxX,
          elapsedTime: Duration(milliseconds: elapsedMs),
        );
        notifyListeners();
      },
    );
  }
  
  void stopMeasurement() {
    _measurementTimer?.cancel();
    _state = _state.copyWith(
      isMeasuring: false,
      isPaused: false,
    );
    notifyListeners();
  }
  
  void togglePause() {
    final newPausedState = !_state.isPaused;
    _state = _state.copyWith(isPaused: newPausedState);
    
    if (newPausedState) {
      _measurementTimer?.cancel();
    } else {
      _startMeasurementTimer();
    }
    notifyListeners();
  }
  
  Future<int> saveSession(String notes, {String? deviceSerial, String? deviceName}) async {
    try {
      final session = MeasurementSession(
        startTime: _state.sessionStartTime ?? DateTime.now(),
        endTime: DateTime.now(),
        maxPressure: _state.maxPressure,
        avgPressure: _state.avgPressure,
        sampleRate: outputRate,  // Save current firmware output rate
        notes: notes.isEmpty ? null : notes,
        deviceSerial: deviceSerial,
        deviceName: deviceName,
      );
      
      final sessionId = await _dbService.createSession(session);
      
      // Save data (firmware output rate = storage rate)
      await _dbService.savePressureDataBatch(
        _dataList.map((spot) => PressureData(
          pressure: spot.y,
          timestamp: (_state.sessionStartTime ?? DateTime.now()).add(
            Duration(milliseconds: spot.x.toInt()),
          ),
          sessionId: sessionId,
        )).toList(),
      );
      
      return sessionId;
    } catch (e) {
      rethrow;
    }
  }
  
  void reset() {
    _measurementTimer?.cancel();
    _dataList.clear();
    _state = const MeasurementState();
    notifyListeners();
  }
  
  @override
  void dispose() {
    _measurementTimer?.cancel();
    _pressureSubscription?.cancel();
    super.dispose();
  }
}
