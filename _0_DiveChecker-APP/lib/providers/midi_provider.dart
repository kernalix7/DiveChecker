// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// MIDI-based communication provider for DiveChecker device.
/// Cross-platform: iOS, Android, Linux, Windows, macOS, Web
library;

import 'dart:async';
import 'dart:convert';

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
  String? firmwareSerial; // Serial number from firmware (CMD_DEVICE_INFO)

  MidiDeviceInfo({
    required this.device,
    this.deviceName,
  });

  String get id => device.id;
  String get name => device.name;
  
  /// Port name - uses MIDI device ID
  String get portName => device.id;
  
  /// Manufacturer - MIDI devices don't expose this, return null
  String? get manufacturer => null;
  
  /// Serial number - returns firmware-reported serial if available
  String? get serialNumber => firmwareSerial;
  
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
/// - 0x01: Pressure data (5 bytes: 7-bit encoded int32 delta_x1000)
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

  // Command bytes — Device -> App
  static const int _cmdPressure = 0x01;
  static const int _cmdDeviceInfo = 0x02;
  static const int _cmdConfig = 0x03;
  static const int _cmdAuthResponse = 0x04;
  static const int _cmdSensorStatus = 0x05;
  static const int _cmdOverrangeAlert = 0x06;
  static const int _cmdTemperature = 0x07;
  static const int _cmdDiagnostics = 0x08;
  static const int _cmdFullConfig = 0x09;
  static const int _cmdAck = 0x0A;
  
  // Command bytes — Bidirectional
  static const int _cmdPing = 0x10;
  static const int _cmdPong = 0x11;
  
  // Command bytes — App -> Device
  static const int _cmdRequestInfo = 0x20;
  static const int _cmdSetName = 0x21;
  static const int _cmdSetOutputRate = 0x22;
  static const int _cmdResetBaseline = 0x23;
  static const int _cmdGetConfig = 0x24;
  static const int _cmdSetLed = 0x25;
  static const int _cmdResetSensor = 0x26;
  static const int _cmdFactoryReset = 0x27;
  static const int _cmdSetNoiseFloor = 0x28;
  static const int _cmdGetTemperature = 0x29;
  static const int _cmdEnterBootloader = 0x2A;
  static const int _cmdGetDiagnostics = 0x2B;
  static const int _cmdSetOversampling = 0x2C;
  static const int _cmdSetIirFilter = 0x2D;
  static const int _cmdSoftReboot = 0x2E;
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
  static const int _calibrationTimeoutMs = 5000; // Timeout if no data received
  static const int _minCalibrationSamples = 8; // Minimum samples for valid calibration
  DateTime? _calibrationStartTime;
  Timer? _calibrationTimeoutTimer;

  final _pressureController = StreamController<double>.broadcast();
  StreamSubscription? _midiSubscription;

  Timer? _pingTimer;
  static const int _pingIntervalMs = 1000;
  
  // Throttle notifyListeners for pressure updates (reduce UI rebuilds)
  DateTime _lastNotifyTime = DateTime.now();
  static const int _notifyThrottleMs = 125;  // 8Hz — matches default output rate

  bool _deviceInfoRequested = false;
  bool _sensorConnected = true;
  
  // Over-range alert state
  bool _isOverrange = false;
  final _overrangeController = StreamController<void>.broadcast();
  static const int _overrangeDisplayMs = 5000;  // Show warning for 5 seconds
  Timer? _overrangeTimer;
  int _overrangeAlertCount = 0;          // Consecutive alerts within window
  Timer? _overrangeWindowTimer;
  static const int _overrangeAlertThreshold = 3;   // Show warning after N alerts
  static const int _overrangeWindowMs = 10000;      // Reset counter after 10s of silence

  // ECDSA authentication
  static const bool _authenticationEnabled = true; // ECDSA verification enabled
  bool _isAuthenticated = false;
  bool _authenticationComplete = false;
  bool _authenticationStarted = false; // Guard against duplicate auth
  String? _authNonce;
  Completer<bool>? _authCompleter;

  int _outputRate = 8;
  
  // SysEx buffering for fragmented messages
  static const int _maxSysexBufferSize = 512;  // Prevent OOM from malicious/broken SysEx
  final List<int> _sysexBuffer = [];
  bool _inSysex = false;
  DateTime? _sysexStartTime;  // SysEx timeout tracking

  // Device name cache
  static const String _deviceNameCacheKey = 'midi_device_name_cache';
  Map<String, String> _deviceNameCache = {};

  // Completers for async commands
  Completer<bool>? _nameChangeCompleter;
  Completer<bool>? _pinChangeCompleter;
  
  // Extended config state (from CMD_FULL_CONFIG)
  int _ledBrightness = 50;
  int _noiseFloor = 1;
  int _oversampling = 5;   // 0=skip,1=x1,2=x2,3=x4,4=x8,5=x16
  int _iirFilter = 1;      // 0=off,1=x2,2=x4,3=x8,4=x16
  
  // Firmware version (from CMD_DEVICE_INFO)
  String? _firmwareVersion;
  
  // Temperature
  double _temperature = 0.0;  // °C
  
  // Diagnostics
  int _uptimeSec = 0;
  int _sensorErrors = 0;
  int _overrangeCount = 0;
  int _i2cRecoveryCount = 0;
  double _cpuTemperature = 0.0;
  
  // ACK handling
  final _ackController = StreamController<({int cmd, int status})>.broadcast();
  Completer<int>? _pendingAckCompleter;
  int _pendingAckCmd = 0;

  // Unexpected disconnect notification
  final _disconnectController = StreamController<void>.broadcast();
  StreamSubscription? _setupSubscription;

  // Pong timeout tracking
  DateTime? _lastPongTime;
  static const int _pongTimeoutMs = 8000;  // 8 seconds without pong = lost

  // MIDI stream error resilience — single transient errors are ignored
  int _consecutiveMidiErrors = 0;
  static const int _maxConsecutiveMidiErrors = 3;

  // Debounce for device re-enumeration
  Timer? _setupDebounceTimer;

  // Auto-reconnect on unexpected disconnect
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;
  Timer? _reconnectTimer;
  bool _suppressReconnect = false;  // Suppress after intentional BOOTSEL/soft reboot

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
  bool get isOverrange => _isOverrange;
  Stream<void> get overrangeStream => _overrangeController.stream;
  int get outputRate => _outputRate;
  int get outputIntervalMs => 1000 ~/ _outputRate;
  String? get deviceName => _connectedDevice?.deviceName;
  String? get deviceSerial => _connectedDevice?.firmwareSerial ?? _connectedDevice?.id;
  
  // Extended config getters
  int get ledBrightness => _ledBrightness;
  int get noiseFloor => _noiseFloor;
  int get oversampling => _oversampling;
  int get iirFilter => _iirFilter;
  String? get firmwareVersion => _firmwareVersion;
  double get temperature => _temperature;
  int get uptimeSec => _uptimeSec;
  int get sensorErrors => _sensorErrors;
  int get overrangeCount => _overrangeCount;
  int get i2cRecoveryCount => _i2cRecoveryCount;
  double get cpuTemperature => _cpuTemperature;
  Stream<({int cmd, int status})> get ackStream => _ackController.stream;
  Stream<void> get disconnectStream => _disconnectController.stream;

  double get calibrationProgress => _calibrationStartTime == null
      ? 0.0
      : (DateTime.now().difference(_calibrationStartTime!).inMilliseconds /
              _calibrationDurationMs)
          .clamp(0.0, 1.0);

  void _setState(MidiConnectionState newState) {
    if (_isDisposed) return;  // Prevent notifyListeners on disposed provider
    if (_state != newState) {
      // Cancel ping timer when leaving connected state
      if (_state == MidiConnectionState.connected && newState != MidiConnectionState.connected) {
        _pingTimer?.cancel();
        _pingTimer = null;
      }
      _state = newState;
      notifyListeners();
    }
  }

  void _updatePressure(double rawPressure) {
    if (_isCalibrating) {
      if (_calibrationSamples.length < 500) {
        _calibrationSamples.add(rawPressure);
      }
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
    // Throttled notifyListeners - max 5/sec for UI widgets reading currentPressure
    final now = DateTime.now();
    if (now.difference(_lastNotifyTime).inMilliseconds >= _notifyThrottleMs) {
      _lastNotifyTime = now;
      notifyListeners();
    }
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
      if (kDebugMode) debugPrint('Found ${devices.length} MIDI devices');

      final midiDevices = <MidiDeviceInfo>[];
      for (final device in devices) {
        final cachedName = _deviceNameCache[device.id];
        midiDevices.add(MidiDeviceInfo(
          device: device,
          deviceName: cachedName,
        ));
        if (kDebugMode) debugPrint('MIDI Device: ${device.name} (${device.id})');
      }

      _setState(MidiConnectionState.disconnected);
      return midiDevices;
    } catch (e) {
      if (kDebugMode) debugPrint('Scan error: $e');
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
        (data) {
          _consecutiveMidiErrors = 0;
          _handleMidiData(data);
        },
        onError: (error) {
          _consecutiveMidiErrors++;
          if (kDebugMode) {
            debugPrint('MIDI error ($_consecutiveMidiErrors/$_maxConsecutiveMidiErrors): $error');
          }
          if (_consecutiveMidiErrors >= _maxConsecutiveMidiErrors) {
            _onUnexpectedDisconnect();
          }
        },
      );

      // Listen to device setup changes (USB plug/unplug)
      _setupSubscription?.cancel();
      _setupSubscription = _midiHandler.onDeviceSetupChanged.listen((_) {
        _checkDeviceStillConnected();
      });

      _setState(MidiConnectionState.connected);
      _deviceInfoRequested = false;
      _lastPongTime = DateTime.now();
      _reconnectAttempts = 0;  // Reset reconnect counter on successful connect
      _suppressReconnect = false;  // Allow auto-reconnect for this connection
      _startPing();

      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Connection error: $e');
      _errorMessage = 'Connection failed: $e';
      _setState(MidiConnectionState.error);
      return false;
    }
  }

  /// Handle incoming MIDI data with SysEx buffering
  void _handleMidiData(Uint8List data) {
    if (data.isEmpty) return;

    try {
      // Process each byte for SysEx reassembly
      for (final byte in data) {
      if (byte == 0xF0) {
        // Start of SysEx
        _sysexBuffer.clear();
        _sysexBuffer.add(byte);
        _inSysex = true;
        _sysexStartTime = DateTime.now();
      } else if (byte == 0xF7 && _inSysex) {
        // End of SysEx
        _sysexBuffer.add(byte);
        _inSysex = false;
        _sysexStartTime = null;
        
        // Process complete SysEx message
        final completeMessage = Uint8List.fromList(_sysexBuffer);
        _sysexBuffer.clear();
        if (kDebugMode && completeMessage.length > 10) {
          debugPrint('SysEx (${completeMessage.length} bytes) cmd=0x${completeMessage.length > 3 ? completeMessage[3].toRadixString(16) : "?"}');
        }
        _handleSysEx(completeMessage);
      } else if (_inSysex) {
        // Check SysEx timeout (500ms max for assembly)
        if (_sysexStartTime != null &&
            DateTime.now().difference(_sysexStartTime!).inMilliseconds > 500) {
          if (kDebugMode) debugPrint('SysEx timeout - discarding incomplete buffer');
          _inSysex = false;
          _sysexBuffer.clear();
          _sysexStartTime = null;
          continue;
        }
        // Check buffer size limit
        if (_sysexBuffer.length >= _maxSysexBufferSize) {
          if (kDebugMode) debugPrint('SysEx buffer overflow - discarding');
          _inSysex = false;
          _sysexBuffer.clear();
          _sysexStartTime = null;
          continue;
        }
        // Middle of SysEx - only accept valid data bytes (< 0x80)
        // Except for real-time messages which can appear anywhere
        if (byte < 0x80) {
          _sysexBuffer.add(byte);
        } else if (byte >= 0xF8) {
          // Real-time messages - ignore, don't break SysEx
        } else {
          // Invalid byte in SysEx, abort
          if (kDebugMode) {
            debugPrint('SysEx aborted due to invalid byte: 0x${byte.toRadixString(16)}');
          }
          _inSysex = false;
          _sysexBuffer.clear();
          _sysexStartTime = null;
        }
      }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error handling MIDI data: $e');
      // Reset SysEx state on error
      _inSysex = false;
      _sysexBuffer.clear();
      _sysexStartTime = null;
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
      case _cmdOverrangeAlert:
        _handleOverrangeAlert();
        break;
      case _cmdTemperature:
        _handleTemperature(payload);
        break;
      case _cmdDiagnostics:
        _handleDiagnostics(payload);
        break;
      case _cmdFullConfig:
        _handleFullConfig(payload);
        break;
      case _cmdAck:
        _handleAck(payload);
        break;
      case _cmdPong:
        _handlePong();
        break;
    }
  }

  void _handlePressureData(Uint8List payload) {
    // Firmware sends 5 bytes of 7-bit encoded data
    // data[0] = (val >> 28) & 0x0F | sign_bit(0x40)
    // data[1] = (val >> 21) & 0x7F
    // data[2] = (val >> 14) & 0x7F
    // data[3] = (val >> 7) & 0x7F
    // data[4] = val & 0x7F
    if (payload.length < 5) return;
    
    final bool isNegative = (payload[0] & 0x40) != 0;
    int val = ((payload[0] & 0x0F) << 28) |
              ((payload[1] & 0x7F) << 21) |
              ((payload[2] & 0x7F) << 14) |
              ((payload[3] & 0x7F) << 7) |
              (payload[4] & 0x7F);
    
    if (isNegative) {
      val = -val;
    }
    
    // val is delta_x1000 (hPa * 1000), convert to hPa
    final pressure = val / 1000.0;
    _updatePressure(pressure);
  }

  void _handleDeviceInfo(Uint8List payload) {
    // Firmware format: [serial_len][serial...][name_len][name...][fw_len][fw...][sensor_ok]
    if (payload.isEmpty) return;
    
    int idx = 0;
    
    // Parse serial
    if (idx >= payload.length) return;
    final serialLen = payload[idx++];
    if (idx + serialLen > payload.length) return;
    final serial = utf8.decode(payload.sublist(idx, idx + serialLen), allowMalformed: true);
    idx += serialLen;
    if (kDebugMode) debugPrint('Device serial: $serial');
    
    // Store firmware serial in device info
    if (_connectedDevice != null && serial.isNotEmpty) {
      _connectedDevice!.firmwareSerial = serial;
    }
    
    // Parse name
    if (idx >= payload.length) return;
    final nameLen = payload[idx++];
    if (idx + nameLen > payload.length) return;
    final name = utf8.decode(payload.sublist(idx, idx + nameLen), allowMalformed: true);
    idx += nameLen;
    
    // Parse firmware version
    if (idx >= payload.length) return;
    final fwLen = payload[idx++];
    if (idx + fwLen > payload.length) return;
    final fwVersion = String.fromCharCodes(payload.sublist(idx, idx + fwLen));
    idx += fwLen;
    if (kDebugMode) debugPrint('Firmware version: $fwVersion');
    _firmwareVersion = fwVersion;
    
    // Parse sensor status
    if (idx >= payload.length) return;
    final sensorOk = payload[idx] == 0x01;
    _sensorConnected = sensorOk;
    if (kDebugMode) debugPrint('Sensor status: ${sensorOk ? "OK" : "NOT CONNECTED"}');
    
    // Update device name
    if (_connectedDevice != null && name.isNotEmpty) {
      _connectedDevice!.deviceName = name;
      _saveDeviceNameToCache(_connectedDevice!.id, name);
      notifyListeners();
    }
  }

  void _handleConfig(Uint8List payload) {
    if (payload.isNotEmpty) {
      _outputRate = payload[0].clamp(4, 50);
      notifyListeners();
    }
  }

  void _handleAuthResponse(Uint8List payload) {
    if (_authNonce == null) {
      if (kDebugMode) debugPrint('Auth response received but no nonce pending');
      return;
    }

    if (kDebugMode) {
      debugPrint('Auth response payload length: ${payload.length}');
      debugPrint('Auth response raw: ${payload.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
    }

    // Firmware sends signature as nibble-encoded (2 bytes per original byte)
    // Decode nibbles back to bytes
    final signatureBytes = <int>[];
    for (int i = 0; i + 1 < payload.length; i += 2) {
      final highNibble = payload[i] & 0x0F;
      final lowNibble = payload[i + 1] & 0x0F;
      signatureBytes.add((highNibble << 4) | lowNibble);
    }
    
    final signatureHex = signatureBytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    if (kDebugMode) {
      debugPrint('Auth nonce: $_authNonce');
      debugPrint('Auth signature (${signatureBytes.length} bytes): $signatureHex');
    }

    final isValid = DeviceAuthenticator.verifySignature(
      nonce: _authNonce!,
      signatureHex: signatureHex,
      publicKey: ecdsaPublicKey,
    );

    _isAuthenticated = isValid;
    _authenticationComplete = true;
    if (kDebugMode) debugPrint('Device authentication: ${isValid ? "SUCCESS ✓" : "FAILED ✗"}');
    _authCompleter?.complete(isValid);
    _authCompleter = null;
    _authNonce = null;
    notifyListeners();
    
    // Start atmospheric calibration after authentication completes
    if (_sensorConnected && !_isCalibrating) {
      startAtmosphericCalibration();
    }
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

  void _handleOverrangeAlert() {
    _overrangeAlertCount++;

    // Reset counter after window of silence
    _overrangeWindowTimer?.cancel();
    _overrangeWindowTimer = Timer(Duration(milliseconds: _overrangeWindowMs), () {
      _overrangeAlertCount = 0;
    });

    if (kDebugMode) debugPrint('WARN: Sensor over-range detected! ($_overrangeAlertCount/$_overrangeAlertThreshold)');

    // Only show warning after N consecutive alerts within the time window
    if (_overrangeAlertCount < _overrangeAlertThreshold) return;

    _isOverrange = true;
    _overrangeController.add(null);
    _overrangeAlertCount = 0;
    notifyListeners();

    _overrangeTimer?.cancel();
    _overrangeTimer = Timer(Duration(milliseconds: _overrangeDisplayMs), () {
      if (_isDisposed) return;
      _isOverrange = false;
      _overrangeTimer = null;
      notifyListeners();
    });
  }

  void _handleTemperature(Uint8List payload) {
    // Format: [sign][high7][low7]
    if (payload.length < 3) return;
    final isNegative = payload[0] == 0x01;
    int absVal = ((payload[1] & 0x7F) << 7) | (payload[2] & 0x7F);
    _temperature = (isNegative ? -absVal : absVal) / 100.0;
    notifyListeners();
  }

  void _handleDiagnostics(Uint8List payload) {
    if (payload.length < 14) return;
    int idx = 0;
    
    // Uptime: 5 bytes (32-bit, 7-bit encoded)
    _uptimeSec = ((payload[idx] & 0x0F) << 28) |
                 ((payload[idx + 1] & 0x7F) << 21) |
                 ((payload[idx + 2] & 0x7F) << 14) |
                 ((payload[idx + 3] & 0x7F) << 7) |
                 (payload[idx + 4] & 0x7F);
    idx += 5;
    
    // Sensor errors: 2 bytes
    _sensorErrors = ((payload[idx] & 0x7F) << 7) | (payload[idx + 1] & 0x7F);
    idx += 2;
    
    // Over-range count: 2 bytes
    _overrangeCount = ((payload[idx] & 0x7F) << 7) | (payload[idx + 1] & 0x7F);
    idx += 2;
    
    // I2C recovery count: 2 bytes
    _i2cRecoveryCount = ((payload[idx] & 0x7F) << 7) | (payload[idx + 1] & 0x7F);
    idx += 2;
    
    // CPU temp x100: sign + 2 bytes
    final tempNeg = payload[idx] == 0x01;
    idx++;
    int absTemp = ((payload[idx] & 0x7F) << 7) | (payload[idx + 1] & 0x7F);
    _cpuTemperature = (tempNeg ? -absTemp : absTemp) / 100.0;
    
    notifyListeners();
  }

  void _handleFullConfig(Uint8List payload) {
    // Format: [output_rate][led_brightness][noise_floor][oversampling][iir_filter]
    if (payload.length < 5) return;
    _outputRate = payload[0].clamp(4, 50);
    _ledBrightness = payload[1].clamp(0, 100);
    _noiseFloor = payload[2].clamp(0, 50);
    _oversampling = payload[3].clamp(0, 5);
    _iirFilter = payload[4].clamp(0, 4);
    notifyListeners();
  }

  void _handleAck(Uint8List payload) {
    if (payload.length < 2) return;
    final cmd = payload[0];
    final status = payload[1];
    if (kDebugMode) {
      debugPrint('ACK: cmd=0x${cmd.toRadixString(16)} status=$status');
    }
    _ackController.add((cmd: cmd, status: status));
    
    // Complete pending ACK completer
    if (_pendingAckCompleter != null && cmd == _pendingAckCmd) {
      _pendingAckCompleter!.complete(status);
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
    }

    // Complete name/pin change completers based on command-specific ACKs
    if (cmd == _cmdSetName && _nameChangeCompleter != null && !_nameChangeCompleter!.isCompleted) {
      _nameChangeCompleter!.complete(status == 0);
    }
    if (cmd == _cmdSetPin && _pinChangeCompleter != null && !_pinChangeCompleter!.isCompleted) {
      _pinChangeCompleter!.complete(status == 0);
    }
  }

  void _handlePong() {
    _lastPongTime = DateTime.now();
    if (!_deviceInfoRequested) {
      _deviceInfoRequested = true;
      _requestDeviceInfo();
      setOutputRate(8);  // Force default output rate on connection

      // Skip authentication if disabled
      if (!_authenticationEnabled) {
        _isAuthenticated = true;
        _authenticationComplete = true;
        notifyListeners();
      } else if (!_authenticationStarted) {
        _authenticationStarted = true;
        _authenticateDevice();
      }
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
      if (kDebugMode) debugPrint('Failed to send MIDI: $e');
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
      // Check pong timeout
      if (_lastPongTime != null &&
          DateTime.now().difference(_lastPongTime!).inMilliseconds > _pongTimeoutMs) {
        if (kDebugMode) debugPrint('Pong timeout - device unresponsive');
        _onUnexpectedDisconnect();
        return;
      }
      _sendSysEx(_cmdPing);
    }
  }

  /// Check if connected device is still present after setup change
  /// Debounced to avoid rapid re-enumeration on USB hotplug events
  Future<void> _checkDeviceStillConnected() async {
    if (_connectedDevice == null || _state != MidiConnectionState.connected) return;

    // Debounce: cancel any pending check and wait 300ms
    _setupDebounceTimer?.cancel();
    _setupDebounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (_connectedDevice == null || _state != MidiConnectionState.connected) return;
      try {
        final devices = await _midiHandler.getDevices();
        final stillPresent = devices.any((d) => d.id == _connectedDevice!.id);
        if (!stillPresent) {
          if (kDebugMode) debugPrint('Device removed from MIDI setup');
          _onUnexpectedDisconnect();
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Setup check error: $e');
      }
    });
  }

  /// Handle unexpected disconnect (USB unplug, device power off, etc.)
  /// Attempts auto-reconnect with exponential backoff (up to 3 attempts)
  void _onUnexpectedDisconnect() {
    if (_state != MidiConnectionState.connected) return;
    final deviceToReconnect = _connectedDevice;
    _disconnectController.add(null);
    disconnect();
    
    // Skip auto-reconnect if explicitly suppressed (BOOTSEL, soft reboot)
    if (_suppressReconnect) {
      if (kDebugMode) debugPrint('Auto-reconnect suppressed (intentional disconnect)');
      _reconnectAttempts = 0;
      return;
    }
    
    // Auto-reconnect: try to re-establish connection
    if (deviceToReconnect != null && _reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      final delay = Duration(seconds: _reconnectAttempts * 2); // 2, 4, 6 sec
      if (kDebugMode) {
        debugPrint('Auto-reconnect attempt $_reconnectAttempts/$_maxReconnectAttempts in ${delay.inSeconds}s');
      }
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(delay, () async {
        if (_isDisposed || _state == MidiConnectionState.connected) return;
        final success = await connect(deviceToReconnect);
        if (!success && _reconnectAttempts < _maxReconnectAttempts) {
          // Check if device still exists before retrying
          final devices = await _midiHandler.getDevices();
          final deviceStillExists = devices.any((d) => d.id == deviceToReconnect.device.id);
          if (deviceStillExists) {
            _onUnexpectedDisconnect(); // Retry chain
          } else {
            // Device gone (e.g., BOOTSEL mode) - stop trying
            _reconnectAttempts = 0;
            if (kDebugMode) debugPrint('Device no longer available, stopping reconnect');
          }
        } else if (!success) {
          _reconnectAttempts = 0; // Give up, reset for next manual connect
          if (kDebugMode) debugPrint('Auto-reconnect failed after $_maxReconnectAttempts attempts');
        }
      });
    }
  }

  void _requestDeviceInfo() {
    if (_state == MidiConnectionState.connected) {
      _sendSysEx(_cmdRequestInfo);
    }
  }

  Future<bool> _authenticateDevice() async {
    if (_connectedDevice == null) return false;

    // Cancel any pending authentication
    if (_authCompleter != null && !_authCompleter!.isCompleted) {
      _authCompleter!.complete(false);
    }
    
    _authNonce = DeviceAuthenticator.generateNonce();
    _authCompleter = Completer<bool>();

    // Send auth challenge with nonce
    final nonceBytes = _authNonce!.codeUnits;
    final sent = await _sendSysEx(_cmdAuthChallenge, nonceBytes);
    if (!sent) {
      _authenticationComplete = true;
      _authCompleter = null;
      return false;
    }

    try {
      final completer = _authCompleter;
      if (completer == null) return false;
      
      final result = await completer.future.timeout(
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

    // Cancel any pending name change
    if (_nameChangeCompleter != null && !_nameChangeCompleter!.isCompleted) {
      _nameChangeCompleter!.complete(false);
    }
    _nameChangeCompleter = Completer<bool>();

    // Format: <pin_4_bytes> <name_bytes_utf8>
    final payload = [...pin.codeUnits, ...utf8.encode(trimmedName)];
    final sent = await _sendSysEx(_cmdSetName, payload);
    if (!sent) {
      _nameChangeCompleter = null;
      return false;
    }

    try {
      final completer = _nameChangeCompleter;
      if (completer == null) return false;
      
      final success = await completer.future.timeout(
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
    } finally {
      _nameChangeCompleter = null;
    }
  }

  /// Change device PIN
  Future<bool> changeDevicePin(String oldPin, String newPin) async {
    if (_connectedDevice == null) return false;
    if (oldPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(oldPin)) return false;
    if (newPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(newPin)) return false;

    // Cancel any pending PIN change
    if (_pinChangeCompleter != null && !_pinChangeCompleter!.isCompleted) {
      _pinChangeCompleter!.complete(false);
    }
    _pinChangeCompleter = Completer<bool>();
    
    final payload = [...oldPin.codeUnits, ...newPin.codeUnits];
    final sent = await _sendSysEx(_cmdSetPin, payload);
    if (!sent) {
      _pinChangeCompleter = null;
      return false;
    }

    try {
      final completer = _pinChangeCompleter;
      if (completer == null) return false;
      
      return await completer.future.timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
    } catch (_) {
      return false;
    } finally {
      _pinChangeCompleter = null;
    }
  }

  int _getUtf8ByteLength(String str) => utf8.encode(str).length;

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

  /// Request full device configuration
  Future<bool> requestFullConfig() async {
    return _sendSysEx(_cmdGetConfig);
  }

  /// Set LED brightness (0-100)
  Future<int> setLedBrightness(int brightness) async {
    final clamped = brightness.clamp(0, 100);
    _setupAckCompleter(_cmdSetLed);
    final sent = await _sendSysEx(_cmdSetLed, [clamped]);
    if (!sent) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2;
    }
    return _waitForAckResult();
  }

  /// Reset sensor manually
  Future<int> resetSensor() async {
    _setupAckCompleter(_cmdResetSensor);
    final sent = await _sendSysEx(_cmdResetSensor);
    if (!sent) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2;
    }
    return _waitForAckResult();
  }

  /// Factory reset (requires PIN)
  Future<int> factoryReset(String pin) async {
    if (pin.length != 4) return 1;
    final pinBytes = pin.codeUnits;
    _setupAckCompleter(_cmdFactoryReset);
    final sent = await _sendSysEx(_cmdFactoryReset, pinBytes);
    if (!sent) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2;
    }
    return _waitForAckResult();
  }

  /// Set noise floor threshold (0-50, represents x1000 hPa)
  Future<int> setNoiseFloor(int threshold) async {
    final clamped = threshold.clamp(0, 50);
    _setupAckCompleter(_cmdSetNoiseFloor);
    final sent = await _sendSysEx(_cmdSetNoiseFloor, [clamped]);
    if (!sent) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2;
    }
    return _waitForAckResult();
  }

  /// Request current temperature
  Future<bool> requestTemperature() async {
    return _sendSysEx(_cmdGetTemperature);
  }

  /// Enter bootloader mode (requires PIN, device will disconnect!)
  Future<int> enterBootloader(String pin) async {
    if (pin.length != 4) return 1;
    final pinBytes = pin.codeUnits;
    _setupAckCompleter(_cmdEnterBootloader);
    final sent = await _sendSysEx(_cmdEnterBootloader, pinBytes);
    if (!sent) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2;
    }
    final result = await _waitForAckResult();
    if (result == 0) {
      // Device will enter BOOTSEL and disappear - suppress auto-reconnect
      _suppressReconnect = true;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      // Clean disconnect after ACK is processed
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_isDisposed && _state == MidiConnectionState.connected) {
          disconnect();
        }
      });
    }
    return result;
  }

  /// Soft reboot device (requires PIN, sends CMD_SOFT_REBOOT)
  /// Returns: 0=success, 1=invalid data, 2=wrong PIN/rate limited, -1=timeout, -2=send failed
  Timer? _softRebootTimer;
  Future<int> softReboot(String pin) async {
    if (pin.length != 4) return 1;
    final pinBytes = pin.codeUnits;
    _setupAckCompleter(_cmdSoftReboot);
    final sent = await _sendSysEx(_cmdSoftReboot, pinBytes);
    if (!sent) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2;
    }
    final result = await _waitForAckResult();
    if (result == 0) {
      // Device will reboot and disconnect - suppress auto-reconnect
      _suppressReconnect = true;
      _reconnectTimer?.cancel();
      _softRebootTimer?.cancel();
      _softRebootTimer = Timer(const Duration(milliseconds: 500), () {
        if (!_isDisposed) disconnect();
      });
    }
    return result;
  }

  /// Request runtime diagnostics
  Future<bool> requestDiagnostics() async {
    return _sendSysEx(_cmdGetDiagnostics);
  }

  /// Set BMP280 pressure oversampling (0=skip, 1=x1, 2=x2, 3=x4, 4=x8, 5=x16)
  Future<int> setOversampling(int value) async {
    if (value < 0 || value > 5) return 1;
    _setupAckCompleter(_cmdSetOversampling);
    final sent = await _sendSysEx(_cmdSetOversampling, [value]);
    if (!sent) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2;
    }
    return _waitForAckResult();
  }

  /// Set BMP280 IIR filter coefficient (0=off, 1=x2, 2=x4, 3=x8, 4=x16)
  Future<int> setIirFilter(int value) async {
    if (value < 0 || value > 4) return 1;
    _setupAckCompleter(_cmdSetIirFilter);
    final sent = await _sendSysEx(_cmdSetIirFilter, [value]);
    if (!sent) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2;
    }
    return _waitForAckResult();
  }

  /// Prepare a new ACK completer, cancelling any pending one
  void _setupAckCompleter(int cmdId) {
    if (_pendingAckCompleter != null && !_pendingAckCompleter!.isCompleted) {
      _pendingAckCompleter!.complete(-1); // cancel previous
    }
    _pendingAckCmd = cmdId;
    _pendingAckCompleter = Completer<int>();
  }

  /// Wait for ACK response (completer already set up by caller)
  Future<int> _waitForAckResult({int timeoutMs = 3000}) async {
    try {
      return await _pendingAckCompleter!.future.timeout(
        Duration(milliseconds: timeoutMs),
        onTimeout: () {
          _pendingAckCompleter = null;
          _pendingAckCmd = 0;
          return -1; // timeout
        },
      );
    } catch (e) {
      _pendingAckCompleter = null;
      _pendingAckCmd = 0;
      return -2; // error
    }
  }

  /// Request device config
  void requestDeviceConfig() {
    _sendSysEx(_cmdRequestInfo);
  }

  /// Start atmospheric calibration
  void startAtmosphericCalibration() {
    if (_isCalibrating) return;

    _isCalibrating = true;
    _calibrationSamples.clear();
    _calibrationStartTime = DateTime.now();
    _atmosphericPressureOffset = 0.0;
    
    // Set timeout timer in case no data is received
    _calibrationTimeoutTimer?.cancel();
    _calibrationTimeoutTimer = Timer(
      Duration(milliseconds: _calibrationTimeoutMs),
      _handleCalibrationTimeout,
    );
    
    notifyListeners();
  }
  
  void _handleCalibrationTimeout() {
    if (_isDisposed) return;
    if (!_isCalibrating) return;
    
    if (kDebugMode) {
      debugPrint('Calibration timeout - samples collected: ${_calibrationSamples.length}');
    }
    
    // If we have enough samples, finish calibration
    if (_calibrationSamples.length >= _minCalibrationSamples) {
      _finishCalibration();
    } else {
      // Not enough samples - cancel and use 0 offset
      if (kDebugMode) {
        debugPrint('Calibration failed - not enough samples');
      }
      _isCalibrating = false;
      _calibrationStartTime = null;
      _calibrationSamples.clear();
      notifyListeners();
    }
  }

  void _finishCalibration() {
    _calibrationTimeoutTimer?.cancel();
    _calibrationTimeoutTimer = null;
    
    if (_calibrationSamples.length < _minCalibrationSamples) {
      if (kDebugMode) {
        debugPrint('Calibration incomplete - only ${_calibrationSamples.length} samples');
      }
      _isCalibrating = false;
      _calibrationStartTime = null;
      _calibrationSamples.clear();
      notifyListeners();
      return;
    }

    // Remove outliers using IQR method for more stable calibration
    final sortedSamples = List<double>.from(_calibrationSamples)..sort();
    final n = sortedSamples.length;
    final q1Index = (n * 0.25).floor();
    final q3Index = (n * 0.75).floor();
    final q1 = sortedSamples[q1Index];
    final q3 = sortedSamples[q3Index];
    final iqr = q3 - q1;
    final lowerBound = q1 - 1.5 * iqr;
    final upperBound = q3 + 1.5 * iqr;
    
    final filteredSamples = sortedSamples
        .where((s) => s >= lowerBound && s <= upperBound)
        .toList();
    
    if (filteredSamples.isEmpty) {
      // Fallback to simple average if filtering removed all samples
      final sum = _calibrationSamples.reduce((a, b) => a + b);
      _atmosphericPressureOffset = sum / _calibrationSamples.length;
    } else {
      final sum = filteredSamples.reduce((a, b) => a + b);
      _atmosphericPressureOffset = sum / filteredSamples.length;
    }

    if (kDebugMode) {
      debugPrint(
          'Atmospheric calibration complete: offset = $_atmosphericPressureOffset '
          '(${filteredSamples.length}/${_calibrationSamples.length} samples after filtering)');
    }

    _isCalibrating = false;
    _calibrationStartTime = null;
    _calibrationSamples.clear();
    notifyListeners();
  }

  void cancelCalibration() {
    _calibrationTimeoutTimer?.cancel();
    _calibrationTimeoutTimer = null;
    _isCalibrating = false;
    _calibrationStartTime = null;
    _calibrationSamples.clear();
    notifyListeners();
  }

  /// Disconnect from device
  Future<void> disconnect() async {
    _pingTimer?.cancel();
    _pingTimer = null;

    _setupSubscription?.cancel();
    _setupSubscription = null;
    _lastPongTime = null;

    _midiSubscription?.cancel();
    _midiSubscription = null;

    _overrangeTimer?.cancel();
    _overrangeTimer = null;
    _overrangeWindowTimer?.cancel();
    _overrangeWindowTimer = null;
    _overrangeAlertCount = 0;
    _isOverrange = false;

    _softRebootTimer?.cancel();
    _softRebootTimer = null;

    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _calibrationTimeoutTimer?.cancel();
    _calibrationTimeoutTimer = null;

    _isCalibrating = false;
    _calibrationSamples.clear();
    _calibrationStartTime = null;
    _atmosphericPressureOffset = 0.0;
    
    // Clear SysEx buffer and error state
    _sysexBuffer.clear();
    _inSysex = false;
    _consecutiveMidiErrors = 0;

    // Cancel debounce timer
    _setupDebounceTimer?.cancel();
    _setupDebounceTimer = null;

    // Reset state flags BEFORE async disconnect so UI updates immediately
    _currentPressure = 0.0;
    _deviceInfoRequested = false;
    _sensorConnected = true;
    _isAuthenticated = false;
    _authenticationComplete = false;
    _authenticationStarted = false;
    _authNonce = null;

    // Reset config/diagnostics to defaults (prevent stale data on next connection)
    _temperature = 0.0;
    _uptimeSec = 0;
    _sensorErrors = 0;
    _overrangeCount = 0;
    _i2cRecoveryCount = 0;
    _cpuTemperature = 0.0;
    _ledBrightness = 50;
    _noiseFloor = 1;
    _oversampling = 5;
    _iirFilter = 1;
    _outputRate = 8;
    _firmwareVersion = null;

    // Complete any pending completers to unblock awaiting callers
    if (_authCompleter != null && !_authCompleter!.isCompleted) {
      _authCompleter!.complete(false);
    }
    _authCompleter = null;
    if (_nameChangeCompleter != null && !_nameChangeCompleter!.isCompleted) {
      _nameChangeCompleter!.complete(false);
    }
    _nameChangeCompleter = null;
    if (_pinChangeCompleter != null && !_pinChangeCompleter!.isCompleted) {
      _pinChangeCompleter!.complete(false);
    }
    _pinChangeCompleter = null;
    if (_pendingAckCompleter != null && !_pendingAckCompleter!.isCompleted) {
      _pendingAckCompleter!.complete(-1);
    }
    _pendingAckCompleter = null;
    _pendingAckCmd = 0;

    // Notify UI immediately — dismisses calibration overlay, loading states
    _setState(MidiConnectionState.disconnected);

    // Now do async native disconnect (may be slow if device already unplugged)
    final device = _connectedDevice;
    _connectedDevice = null;
    if (device != null) {
      try {
        await _midiHandler.disconnect();
      } catch (_) {}
    }
  }

  // Device name cache
  Future<void> _loadDeviceNameCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_deviceNameCacheKey);
      if (cacheJson != null) {
        final Map<String, dynamic> decoded =
            cacheJson.isNotEmpty ? _parseJson(cacheJson) : {};
        _deviceNameCache = decoded.map((k, v) => MapEntry(k, v.toString()));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to load device name cache: $e');
    }
  }

  Map<String, dynamic> _parseJson(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveDeviceNameToCache(String id, String name) async {
    try {
      _deviceNameCache[id] = name;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_deviceNameCacheKey, jsonEncode(_deviceNameCache));
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to save device name cache: $e');
    }
  }

  bool _isShutDown = false;

  /// Alias for backwards compatibility — guards against use-after-dispose.
  bool get _isDisposed => _isShutDown;

  @override
  // ignore: must_call_super
  void dispose() {
    // No-op for singleton: dispose() may be called by the framework when a
    // ChangeNotifierProvider is removed from the widget tree, but the singleton
    // must remain usable if it is re-provided later.  Use shutdown() for
    // permanent teardown at app exit.
  }

  /// Permanently release all resources.  Call only once at app exit.
  /// After this the singleton is no longer usable.
  void shutdown() {
    if (_isShutDown) return;
    _isShutDown = true;

    _pingTimer?.cancel();
    _pingTimer = null;

    _setupSubscription?.cancel();
    _setupSubscription = null;

    _calibrationTimeoutTimer?.cancel();
    _calibrationTimeoutTimer = null;

    _setupDebounceTimer?.cancel();
    _setupDebounceTimer = null;

    _softRebootTimer?.cancel();
    _softRebootTimer = null;

    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _midiSubscription?.cancel();
    _midiSubscription = null;

    // Cancel any pending operations
    if (_authCompleter != null && !_authCompleter!.isCompleted) {
      _authCompleter!.complete(false);
    }
    _authCompleter = null;

    if (_nameChangeCompleter != null && !_nameChangeCompleter!.isCompleted) {
      _nameChangeCompleter!.complete(false);
    }
    _nameChangeCompleter = null;

    if (_pinChangeCompleter != null && !_pinChangeCompleter!.isCompleted) {
      _pinChangeCompleter!.complete(false);
    }
    _pinChangeCompleter = null;

    _overrangeTimer?.cancel();
    _overrangeTimer = null;
    _overrangeWindowTimer?.cancel();
    _overrangeWindowTimer = null;

    // NOTE: Do NOT close stream controllers in singleton shutdown().
    // They cannot be recreated, and the singleton may be re-provided.
    // The streams will be garbage collected when the app exits.

    // Dispose native MIDI handler
    _midiHandler.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isShutDown) {
      super.notifyListeners();
    }
  }
}
