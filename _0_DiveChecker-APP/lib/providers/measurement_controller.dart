// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/chart_point.dart';
import '../models/pressure_data.dart';
import '../services/unified_database_service.dart';
import '../constants/app_constants.dart';
import 'midi_provider.dart';


class MeasurementState {
  final bool isMeasuring;
  final bool isPaused;
  final double currentPressure;
  final List<ChartPoint> pressureData;
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
    List<ChartPoint>? pressureData,
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
  final MidiProvider _midiProvider;
  final UnifiedDatabaseService _dbService = UnifiedDatabaseService();
  
  MeasurementState _state = const MeasurementState();
  MeasurementState get state => _state;
  
  Timer? _measurementTimer;
  StreamSubscription<double>? _pressureSubscription;
  
  // Single data list - firmware output rate = display rate = storage rate
  final List<ChartPoint> _dataList = [];
  
  // Incremental statistics - avoid recalculating from entire list
  double _sumPressure = 0.0;
  double _maxPressureValue = 0.0;
  
  MeasurementController({
    required MidiProvider midiProvider,
  })  : _midiProvider = midiProvider {
    _pressureSubscription = _midiProvider.pressureStream.listen(_onPressureReceived);
  }
  
  void _onPressureReceived(double pressure) {
    // Firmware already applies averaging filter (100Hz → outputRate with mean)
    // Just use the filtered value directly - no decimation needed
    _state = _state.copyWith(currentPressure: pressure);
    
    if (_state.isMeasuring && !_state.isPaused && _state.sessionStartTime != null) {
      final sampleIntervalMs = 1000.0 / outputRate;
      final xMs = _dataList.length * sampleIntervalMs;
      
      _dataList.add(ChartPoint(xMs, pressure));
      _sumPressure += pressure;
      if (pressure > _maxPressureValue) {
        _maxPressureValue = pressure;
      }
      
      if (_dataList.length > MeasurementConfig.maxDataPoints) {
        final removed = _dataList.removeAt(0);
        _sumPressure -= removed.y;
        if (removed.y >= _maxPressureValue) {
          _maxPressureValue = _dataList.isEmpty ? 0.0 : _dataList.map((e) => e.y).reduce(max);
        }
        if (_dataList.length % 100 == 0) {
          _sumPressure = _dataList.fold<double>(0.0, (sum, p) => sum + p.y);
        }
      }
      
      // Data-driven UI update with throttle
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      if (nowMs - _lastNotifyMs >= _minNotifyIntervalMs) {
        _lastNotifyMs = nowMs;
        _updateMeasurementState();
      }
    } else {
      notifyListeners();
    }
  }
  
  /// Current firmware output rate (Hz)
  int get outputRate => _midiProvider.outputRate;
  
  /// Actual duration in seconds: sample count / Hz
  int get actualDurationSeconds {
    if (_dataList.isEmpty) return 0;
    return (_dataList.length / outputRate).round();
  }
  
  bool get isConnected => _midiProvider.isConnected;
  
  double get currentPressure => _midiProvider.currentPressure;
  
  void startMeasurement() {
    if (!isConnected) return;
    
    _dataList.clear();
    _sumPressure = 0.0;
    _maxPressureValue = 0.0;
    
    _state = MeasurementState(
      isMeasuring: true,
      isPaused: false,
      currentPressure: _midiProvider.currentPressure,
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
  
  int _lastNotifyMs = 0;
  static const int _minNotifyIntervalMs = 100;

  void _startMeasurementTimer() {
    _measurementTimer?.cancel();
    _lastNotifyMs = 0;
  }

  void _updateMeasurementState() {
    if (_state.sessionStartTime == null) return;
    
    final elapsedMs = DateTime.now().difference(_state.sessionStartTime!).inMilliseconds;
    
    double minX = _state.minX;
    double maxX = _state.maxX;
    if (elapsedMs > maxX) {
      minX = elapsedMs - 30000;
      maxX = elapsedMs.toDouble();
    }
    
    final avgPressure = _dataList.isEmpty ? 0.0 : _sumPressure / _dataList.length;
    
    _state = _state.copyWith(
      pressureData: List.unmodifiable(_dataList),
      maxPressure: _maxPressureValue,
      avgPressure: avgPressure,
      minX: minX,
      maxX: maxX,
      elapsedTime: Duration(milliseconds: elapsedMs),
    );
    notifyListeners();
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
      final startTime = _state.sessionStartTime ?? DateTime.now();
      // Calculate endTime based on actual data: startTime + (samples / Hz) seconds
      final actualDurationMs = _dataList.isEmpty ? 0 : (_dataList.length * 1000 / outputRate).round();
      final endTime = startTime.add(Duration(milliseconds: actualDurationMs));
      
      final session = MeasurementSession(
        startTime: startTime,
        endTime: endTime,
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
    _measurementTimer = null;
    _dataList.clear();
    _sumPressure = 0.0;
    _maxPressureValue = 0.0;
    _state = const MeasurementState();
    notifyListeners();
  }
  
  bool _isDisposed = false;
  
  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    
    _measurementTimer?.cancel();
    _measurementTimer = null;
    _pressureSubscription?.cancel();
    _pressureSubscription = null;
    _dataList.clear();
    super.dispose();
  }
  
  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }
}
