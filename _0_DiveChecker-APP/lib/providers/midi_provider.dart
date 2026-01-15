// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// MIDI-based communication provider for DiveChecker device.
/// Cross-platform: iOS, Android, Linux, Windows, macOS, Web
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../security/device_authenticator.dart';
import '../security/ecdsa_public_key.dart';
import 'midi/midi_handler.dart';

enum MidiConnectionState {
  disconnected,
  scanning,
  connecting,
  connected,
  error,
}

class MidiDeviceInfo {
  final MidiDeviceData device;
  String? deviceName; // Custom device name from MCU Flash

  MidiDeviceInfo({
    required this.device,
    this.deviceName,
  });

  String get id => device.id;
  String get name => device.name;
  
  // Compatibility getters for SerialDeviceInfo interface
  /// Port name - uses MIDI device ID for compatibility
  String get portName => device.id;
  
  /// Manufacturer - MIDI devices don't expose this, return null
  String? get manufacturer => null;
  
  /// Serial number - MIDI devices don't expose this, return null
  String? get serialNumber => null;
  
  /// Vendor ID - MIDI devices don't expose this, return null
  int? get vendorId => null;
  
  /// Product ID - MIDI devices don't expose this, return null
  int? get productId => null;
  
  /// Description - uses device name
  String? get description => device.name;

  String get displayName {
    if (deviceName != null && deviceName!.isNotEmpty) {
      return deviceName!;
    }
    if (name.toLowerCase().contains('divechecker')) {
      return 'DiveChecker V1';
    }
    return name;
  }

  bool get isDiveChecker {
    return name.toLowerCase().contains('divechecker') ||
        name.toLowerCase().contains('kodenet');
  }
  
  /// Strict verification - for MIDI, same as isDiveChecker
  bool get isVerifiedDiveChecker => isDiveChecker;
}

/// MIDI SysEx Protocol for DiveChecker
/// 
/// SysEx format: `F0 [manufacturer_id] [device_id] [command] [data...] F7`
/// Manufacturer ID: 0x7D (educational/development use)
/// Device ID: 0x01 (DiveChecker)
/// 
/// Commands:
/// - 0x01: Pressure data (4 bytes: int32 mPa, big-endian)
/// - 0x02: Device info response
/// - 0x03: Config response
/// - 0x04: Auth response
/// - 0x10: Ping
/// - 0x11: Pong
/// - 0x20: Request device info
/// - 0x21: Set device name
/// - 0x22: Set output rate
/// - 0x23: Reset baseline
/// - 0x30: Auth challenge
class MidiProvider extends ChangeNotifier {
  static final MidiProvider _instance = MidiProvider._internal();
  factory MidiProvider() => _instance;
  MidiProvider._internal() {
    _initMidiHandler();
  }

  // MIDI handler instance (platform-specific)
  late final MidiHandler _midiHandler;
  
  void _initMidiHandler() {
    _midiHandler = createMidiHandler();
  }

  // SysEx protocol constants
  static const int _manufacturerId = 0x7D; // Educational/development
  static const int _deviceId = 0x01; // DiveChecker

  // Command bytes
  static const int _cmdPressure = 0x01;
  static const int _cmdDeviceInfo = 0x02;
  static const int _cmdConfig = 0x03;
  static const int _cmdAuthResponse = 0x04;
  static const int _cmdSensorStatus = 0x05;
  static const int _cmdPing = 0x10;
  static const int _cmdPong = 0x11;
  static const int _cmdRequestInfo = 0x20;
  static const int _cmdSetName = 0x21;
  static const int _cmdSetOutputRate = 0x22;
  static const int _cmdResetBaseline = 0x23;
  static const int _cmdAuthChallenge = 0x30;
  static const int _cmdSetPin = 0x31;

  MidiConnectionState _state = MidiConnectionState.disconnected;
  MidiDeviceInfo? _connectedDevice;
  double _currentPressure = 0.0;
  String? _errorMessage;

  bool _isCalibrating = false;
  double _atmosphericPressureOffset = 0.0;
  final List<double> _calibrationSamples = [];
  static const int _calibrationDurationMs = 3000;
  DateTime? _calibrationStartTime;

  final _pressureController = StreamController<double>.broadcast();
  StreamSubscription? _midiSubscription;

  Timer? _pingTimer;
  static const int _pingIntervalMs = 1000;

  bool _deviceInfoRequested = false;
  bool _sensorConnected = true;

  // ECDSA authentication
  bool _isAuthenticated = false;
  bool _authenticationComplete = false;
  String? _authNonce;
  Completer<bool>? _authCompleter;

  int _outputRate = 8;

  // Device name cache
  static const String _deviceNameCacheKey = 'midi_device_name_cache';
  Map<String, String> _deviceNameCache = {};

  // Completers for async commands
  Completer<bool>? _nameChangeCompleter;
  Completer<bool>? _pinChangeCompleter;

  // Getters
  MidiConnectionState get state => _state;
  bool get isConnected => _state == MidiConnectionState.connected;
  bool get isScanning => _state == MidiConnectionState.scanning;
  double get currentPressure => _currentPressure;
  String? get errorMessage => _errorMessage;
  Stream<double> get pressureStream => _pressureController.stream;
  MidiDeviceInfo? get connectedDevice => _connectedDevice;
  bool get isCalibrating => _isCalibrating;
  double get atmosphericPressureOffset => _atmosphericPressureOffset;
  bool get isSensorConnected => _sensorConnected;
  bool get isDeviceAuthenticated => _isAuthenticated;
  bool get isAuthenticationComplete => _authenticationComplete;
  int get outputRate => _outputRate;
  int get outputIntervalMs => 1000 ~/ _outputRate;
  String? get deviceName => _connectedDevice?.deviceName;
  String? get deviceSerial => _connectedDevice?.id;

  double get calibrationProgress => _calibrationStartTime == null
      ? 0.0
      : (DateTime.now().difference(_calibrationStartTime!).inMilliseconds /
              _calibrationDurationMs)
          .clamp(0.0, 1.0);

  void _setState(MidiConnectionState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  void _updatePressure(double rawPressure) {
    if (_isCalibrating) {
      _calibrationSamples.add(rawPressure);
      if (_calibrationStartTime != null) {
        final elapsed =
            DateTime.now().difference(_calibrationStartTime!).inMilliseconds;
        if (elapsed >= _calibrationDurationMs) {
          _finishCalibration();
        }
      }
      notifyListeners();
      return;
    }

    final adjustedPressure = rawPressure - _atmosphericPressureOffset;
    _currentPressure = adjustedPressure;
    _pressureController.add(adjustedPressure);
    notifyListeners();
  }

  /// Scan for MIDI devices
  Future<List<MidiDeviceInfo>> scanDevices() async {
    if (_state == MidiConnectionState.scanning) {
      return [];
    }

    _errorMessage = null;
    _setState(MidiConnectionState.scanning);

    await _loadDeviceNameCache();

    try {
      final devices = await _midiHandler.getDevices();
      debugPrint('Found ${devices.length} MIDI devices');

      final midiDevices = <MidiDeviceInfo>[];
      for (final device in devices) {
        final cachedName = _deviceNameCache[device.id];
        midiDevices.add(MidiDeviceInfo(
          device: device,
          deviceName: cachedName,
        ));
        debugPrint('MIDI Device: ${device.name} (${device.id})');
      }

      _setState(MidiConnectionState.disconnected);
      return midiDevices;
    } catch (e) {
      debugPrint('Scan error: $e');
      _errorMessage = e.toString();
      _setState(MidiConnectionState.error);
      return [];
    }
  }

  /// Connect to a MIDI device
  Future<bool> connect(MidiDeviceInfo device) async {
    _errorMessage = null;
    _setState(MidiConnectionState.connecting);

    try {
      await _midiHandler.connect(device.device.id);
      _connectedDevice = device;

      // Listen to MIDI messages
      _midiSubscription?.cancel();
      _midiSubscription = _midiHandler.onDataReceived.listen(
        _handleMidiData,
        onError: (error) {
          debugPrint('MIDI error: $error');
          disconnect();
        },
      );

      _setState(MidiConnectionState.connected);
      _deviceInfoRequested = false;
      _startPing();

      return true;
    } catch (e) {
      debugPrint('Connection error: $e');
      _errorMessage = 'Connection failed: $e';
      _setState(MidiConnectionState.error);
      return false;
    }
  }

  /// Handle incoming MIDI data
  void _handleMidiData(Uint8List data) {
    if (data.isEmpty) return;

    // Check for SysEx (F0 ... F7)
    if (data[0] == 0xF0 && data.last == 0xF7) {
      _handleSysEx(data);
    }
  }

  /// Handle SysEx message
  void _handleSysEx(Uint8List data) {
    // Minimum: F0 <mfr> <dev> <cmd> F7 = 5 bytes
    if (data.length < 5) return;

    // Verify manufacturer and device ID
    if (data[1] != _manufacturerId || data[2] != _deviceId) return;

    final command = data[3];
    final payload = data.sublist(4, data.length - 1); // Remove F0, header, F7

    switch (command) {
      case _cmdPressure:
        _handlePressureData(payload);
        break;
      case _cmdDeviceInfo:
        _handleDeviceInfo(payload);
        break;
      case _cmdConfig:
        _handleConfig(payload);
        break;
      case _cmdAuthResponse:
        _handleAuthResponse(payload);
        break;
      case _cmdSensorStatus:
        _handleSensorStatus(payload);
        break;
      case _cmdPong:
        _handlePong();
        break;
    }
  }

  void _handlePressureData(Uint8List payload) {
    if (payload.length < 4) return;
    // 4 bytes big-endian int32 (mPa)
    final mPa = (payload[0] << 24) |
        (payload[1] << 16) |
        (payload[2] << 8) |
        payload[3];
    final pressure = mPa / 1000.0; // mPa to Pa
    _updatePressure(pressure);
  }

  void _handleDeviceInfo(Uint8List payload) {
    // Format: <name_length> <name_bytes...>
    if (payload.isEmpty) return;
    final nameLength = payload[0];
    if (payload.length >= nameLength + 1) {
      final name = String.fromCharCodes(payload.sublist(1, 1 + nameLength));
      if (_connectedDevice != null && name.isNotEmpty) {
        _connectedDevice!.deviceName = name;
        _saveDeviceNameToCache(_connectedDevice!.id, name);
        notifyListeners();
      }
    }
  }

  void _handleConfig(Uint8List payload) {
    if (payload.length >= 2) {
      final oversampling = payload[0];
      final sampleRate = payload[1];
      _outputRate = sampleRate;
      _onConfigReceived?.call(oversampling, sampleRate);
      notifyListeners();
    }
  }

  void _handleAuthResponse(Uint8List payload) {
    if (_authNonce == null) return;

    // Payload contains signature
    final signatureHex = payload
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    final isValid = DeviceAuthenticator.verifySignature(
      nonce: _authNonce!,
      signatureHex: signatureHex,
      publicKey: ecdsaPublicKey,
    );

    _isAuthenticated = isValid;
    _authenticationComplete = true;
    debugPrint('Device authentication: ${isValid ? "SUCCESS ✓" : "FAILED ✗"}');
    _authCompleter?.complete(isValid);
    _authCompleter = null;
    _authNonce = null;
    notifyListeners();
  }

  void _handleSensorStatus(Uint8List payload) {
    if (payload.isNotEmpty) {
      _sensorConnected = payload[0] == 1;
      if (_sensorConnected && !_isCalibrating) {
        startAtmosphericCalibration();
      }
      notifyListeners();
    }
  }

  void _handlePong() {
    if (!_deviceInfoRequested) {
      _deviceInfoRequested = true;
      _requestDeviceInfo();
      _authenticateDevice();
    }
  }

  /// Send SysEx command
  Future<bool> _sendSysEx(int command, [List<int>? payload]) async {
    if (_connectedDevice == null) return false;

    final data = <int>[
      0xF0, // SysEx start
      _manufacturerId,
      _deviceId,
      command,
      ...?payload,
      0xF7, // SysEx end
    ];

    try {
      return await _midiHandler.sendSysEx(data);
    } catch (e) {
      debugPrint('Failed to send MIDI: $e');
      return false;
    }
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(
      Duration(milliseconds: _pingIntervalMs),
      (_) => _sendPing(),
    );
  }

  void _sendPing() {
    if (_state == MidiConnectionState.connected) {
      _sendSysEx(_cmdPing);
    }
  }

  void _requestDeviceInfo() {
    if (_state == MidiConnectionState.connected) {
      _sendSysEx(_cmdRequestInfo);
    }
  }

  Future<bool> _authenticateDevice() async {
    if (_connectedDevice == null) return false;

    _authNonce = DeviceAuthenticator.generateNonce();
    _authCompleter = Completer<bool>();

    // Send auth challenge with nonce
    final nonceBytes = _authNonce!.codeUnits;
    _sendSysEx(_cmdAuthChallenge, nonceBytes);

    try {
      final result = await _authCompleter!.future.timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          _isAuthenticated = false;
          _authenticationComplete = true;
          _authNonce = null;
          notifyListeners();
          return false;
        },
      );
      return result;
    } catch (e) {
      _authenticationComplete = true;
      notifyListeners();
      return false;
    }
  }

  /// Set device name
  Future<bool> setDeviceName(String name, String pin) async {
    if (_connectedDevice == null) return false;
    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) return false;

    // Truncate name to 24 bytes
    var trimmedName = name;
    while (_getUtf8ByteLength(trimmedName) > 24 && trimmedName.isNotEmpty) {
      trimmedName = trimmedName.substring(0, trimmedName.length - 1);
    }

    _nameChangeCompleter = Completer<bool>();

    // Format: <pin_4_bytes> <name_bytes>
    final payload = [...pin.codeUnits, ...trimmedName.codeUnits];
    _sendSysEx(_cmdSetName, payload);

    try {
      final success = await _nameChangeCompleter!.future.timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
      if (success && _connectedDevice != null) {
        _connectedDevice!.deviceName = trimmedName;
        notifyListeners();
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  /// Change device PIN
  Future<bool> changeDevicePin(String oldPin, String newPin) async {
    if (_connectedDevice == null) return false;
    if (oldPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(oldPin)) return false;
    if (newPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(newPin)) return false;

    _pinChangeCompleter = Completer<bool>();
    final payload = [...oldPin.codeUnits, ...newPin.codeUnits];
    _sendSysEx(_cmdSetPin, payload);

    try {
      return await _pinChangeCompleter!.future.timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
    } catch (_) {
      return false;
    }
  }

  int _getUtf8ByteLength(String str) {
    return str.codeUnits.fold(0, (sum, code) {
      if (code <= 0x7F) return sum + 1;
      if (code <= 0x7FF) return sum + 2;
      return sum + 3;
    });
  }

  /// Set output rate
  Future<bool> setOutputRate(int hz) async {
    if (hz < 4 || hz > 50) return false;
    final success = await _sendSysEx(_cmdSetOutputRate, [hz]);
    if (success) {
      _outputRate = hz;
      notifyListeners();
    }
    return success;
  }

  /// Reset pressure baseline
  Future<bool> resetBaseline() async {
    return _sendSysEx(_cmdResetBaseline);
  }

  /// Request device config
  void requestDeviceConfig() {
    _sendSysEx(_cmdRequestInfo);
  }
  
  /// Legacy compatibility: Send command string (translates to SysEx)
  /// 
  /// Supported commands:
  /// - 'P' : Ping
  /// - 'I' : Request device info
  /// - 'C' : Request config
  /// - 'R' : Reset baseline
  /// - `O[value]` : Set oversampling
  /// - `F[hz]` : Set output rate
  /// - `N:[pin]:[name]` or `N[pin][name]` : Set device name
  /// - `W:[oldPin]:[newPin]` or `W[oldPin][newPin]` : Change PIN
  /// - `A[nonce]` : Auth challenge
  Future<bool> sendCommand(String cmd) async {
    if (cmd.isEmpty) return false;
    
    final prefix = cmd[0];
    final payload = cmd.length > 1 ? cmd.substring(1) : '';
    
    switch (prefix) {
      case 'P':
        return _sendSysEx(_cmdPing);
      case 'I':
        return _sendSysEx(_cmdRequestInfo);
      case 'C':
        return _sendSysEx(_cmdRequestInfo); // Config is part of device info
      case 'R':
        return _sendSysEx(_cmdResetBaseline);
      case 'O':
        // Oversampling - not supported via MIDI, ignore
        return true;
      case 'F':
        final hz = int.tryParse(payload);
        if (hz != null) {
          return setOutputRate(hz);
        }
        return false;
      case 'N':
        // Name change: N:<pin>:<name> or N<pin><name>
        if (payload.contains(':')) {
          final parts = payload.split(':');
          if (parts.length >= 2) {
            return setDeviceName(parts.sublist(1).join(':'), parts[0]);
          }
        } else if (payload.length >= 4) {
          final pin = payload.substring(0, 4);
          final name = payload.substring(4);
          return setDeviceName(name, pin);
        }
        return false;
      case 'W':
        // PIN change: W:<oldPin>:<newPin> or W<oldPin><newPin>
        if (payload.contains(':')) {
          final parts = payload.split(':');
          if (parts.length >= 2) {
            return changeDevicePin(parts[0], parts[1]);
          }
        } else if (payload.length >= 8) {
          final oldPin = payload.substring(0, 4);
          final newPin = payload.substring(4, 8);
          return changeDevicePin(oldPin, newPin);
        }
        return false;
      case 'A':
        // Auth challenge - handled internally
        return true;
      default:
        debugPrint('Unknown command: $cmd');
        return false;
    }
  }

  Function(int oversampling, int sampleRate)? _onConfigReceived;

  void setConfigReceivedCallback(Function(int, int)? callback) {
    _onConfigReceived = callback;
  }

  /// Start atmospheric calibration
  void startAtmosphericCalibration() {
    if (_isCalibrating) return;

    _isCalibrating = true;
    _calibrationSamples.clear();
    _calibrationStartTime = DateTime.now();
    _atmosphericPressureOffset = 0.0;
    notifyListeners();
  }

  void _finishCalibration() {
    if (_calibrationSamples.isEmpty) {
      _isCalibrating = false;
      _calibrationStartTime = null;
      notifyListeners();
      return;
    }

    final sum = _calibrationSamples.reduce((a, b) => a + b);
    _atmosphericPressureOffset = sum / _calibrationSamples.length;

    debugPrint(
        'Atmospheric calibration complete: offset = $_atmosphericPressureOffset (${_calibrationSamples.length} samples)');

    _isCalibrating = false;
    _calibrationStartTime = null;
    _calibrationSamples.clear();
    notifyListeners();
  }

  void cancelCalibration() {
    _isCalibrating = false;
    _calibrationStartTime = null;
    _calibrationSamples.clear();
    notifyListeners();
  }

  /// Disconnect from device
  Future<void> disconnect() async {
    _pingTimer?.cancel();
    _pingTimer = null;

    _midiSubscription?.cancel();
    _midiSubscription = null;

    _isCalibrating = false;
    _calibrationSamples.clear();
    _calibrationStartTime = null;
    _atmosphericPressureOffset = 0.0;

    if (_connectedDevice != null) {
      try {
        await _midiHandler.disconnect();
      } catch (_) {}
    }

    _connectedDevice = null;
    _currentPressure = 0.0;
    _deviceInfoRequested = false;
    _sensorConnected = true;
    _isAuthenticated = false;
    _authenticationComplete = false;
    _authNonce = null;
    _authCompleter = null;
    _setState(MidiConnectionState.disconnected);
  }

  // Device name cache
  Future<void> _loadDeviceNameCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_deviceNameCacheKey);
      if (cacheJson != null) {
        final Map<String, dynamic> decoded =
            Map<String, dynamic>.from(await Future.value(
          cacheJson.isNotEmpty ? _parseJson(cacheJson) : {},
        ));
        _deviceNameCache = decoded.map((k, v) => MapEntry(k, v.toString()));
      }
    } catch (e) {
      debugPrint('Failed to load device name cache: $e');
    }
  }

  Map<String, dynamic> _parseJson(String json) {
    // Simple JSON parsing for cache
    try {
      return Map<String, String>.fromEntries(
        json
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll('"', '')
            .split(',')
            .where((s) => s.contains(':'))
            .map((s) {
          final parts = s.split(':');
          return MapEntry(parts[0].trim(), parts[1].trim());
        }),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveDeviceNameToCache(String id, String name) async {
    try {
      _deviceNameCache[id] = name;
      final prefs = await SharedPreferences.getInstance();
      final json = _deviceNameCache.entries
          .map((e) => '"${e.key}":"${e.value}"')
          .join(',');
      await prefs.setString(_deviceNameCacheKey, '{$json}');
    } catch (e) {
      debugPrint('Failed to save device name cache: $e');
    }
  }

  @override
  void dispose() {
    _pingTimer?.cancel();
    _midiSubscription?.cancel();
    _pressureController.close();
    super.dispose();
  }
}
