// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../security/device_authenticator.dart';
import '../security/ecdsa_public_key.dart';

enum SerialConnectionState {
  disconnected,
  scanning,
  connecting,
  connected,
  error,
}

class SerialDeviceInfo {
  final String portName;
  final String? description;
  final String? manufacturer;
  final String? serialNumber;
  final int? vendorId;
  final int? productId;
  String? deviceName;  // Custom device name from MCU Flash
  
  SerialDeviceInfo({
    required this.portName,
    this.description,
    this.manufacturer,
    this.serialNumber,
    this.vendorId,
    this.productId,
    this.deviceName,
  });
  
  String get displayName {
    // If we have a custom device name from MCU, use it
    if (deviceName != null && deviceName!.isNotEmpty) {
      String shortSerial = '';
      if (serialNumber != null && serialNumber!.length >= 4) {
        shortSerial = serialNumber!.substring(serialNumber!.length - 4);
      }
      return shortSerial.isNotEmpty 
          ? '$deviceName-$shortSerial ($portName)'
          : '$deviceName ($portName)';
    }
    
    // For DiveChecker devices, show short serial (last 4 chars)
    if (description != null && description!.toLowerCase().contains('divechecker')) {
      String shortSerial = '';
      if (serialNumber != null && serialNumber!.length >= 4) {
        shortSerial = serialNumber!.substring(serialNumber!.length - 4);
      }
      return shortSerial.isNotEmpty 
          ? 'DiveChecker V1-$shortSerial ($portName)'
          : 'DiveChecker V1 ($portName)';
    }
    
    if (description != null && description!.isNotEmpty) {
      return '$description ($portName)';
    }
    if (manufacturer != null && manufacturer!.isNotEmpty) {
      return '$manufacturer ($portName)';
    }
    return portName;
  }
  
  /// Check if this is a verified DiveChecker device (for UI display purposes)
  /// More permissive - shows DiveChecker styling for potential devices
  bool get isDiveChecker {
    final desc = (description ?? '').toLowerCase();
    final mfr = (manufacturer ?? '').toLowerCase();
    return desc.contains('divechecker') ||
           mfr.contains('kodenet');
  }
  
  /// Check if this is a verified DiveChecker device (for auto-sync)
  /// STRICT - only auto-connect to devices with exact kodenet.io manufacturer
  bool get isVerifiedDiveChecker {
    final mfr = (manufacturer ?? '').toLowerCase();
    final desc = (description ?? '').toLowerCase();
    // Must have kodenet.io as manufacturer AND DiveChecker in description
    return mfr.contains('kodenet.io') && desc.contains('divechecker');
  }
}

class SerialProvider extends ChangeNotifier {
  static final SerialProvider _instance = SerialProvider._internal();
  factory SerialProvider() => _instance;
  SerialProvider._internal();
  
  SerialConnectionState _state = SerialConnectionState.disconnected;
  SerialPort? _port;
  SerialPortReader? _reader;
  SerialDeviceInfo? _connectedDevice;
  double _currentPressure = 0.0;
  String? _errorMessage;
  
  bool _isCalibrating = false;
  double _atmosphericPressureOffset = 0.0;
  List<double> _calibrationSamples = [];
  static const int _calibrationDurationMs = 3000;  // 3 seconds
  DateTime? _calibrationStartTime;
  
  final _pressureController = StreamController<double>.broadcast();
  StreamSubscription? _dataSubscription;
  
  Timer? _pingTimer;
  static const int _pingIntervalMs = 1000;
  
  // Track if device info was requested for current connection
  bool _deviceInfoRequested = false;
  
  // Sensor connection status from MCU
  bool _sensorConnected = true;  // Assume OK until told otherwise
  
  // ECDSA device authentication
  bool _isAuthenticated = false;
  bool _authenticationComplete = false;  // True when auth attempt finished (success or fail)
  String? _authNonce;  // Current nonce for authentication
  Completer<bool>? _authCompleter;
  
  // Current firmware output rate (Hz) - single source of truth
  int _outputRate = 8;  // Default 8Hz
  
  // Device name cache (serial -> name)
  static const String _deviceNameCacheKey = 'device_name_cache';
  Map<String, String> _deviceNameCache = {};
  
  // Data buffer for line parsing
  String _dataBuffer = '';
  
  SerialConnectionState get state => _state;
  bool get isConnected => _state == SerialConnectionState.connected;
  bool get isScanning => _state == SerialConnectionState.scanning;
  double get currentPressure => _currentPressure;
  String? get errorMessage => _errorMessage;
  Stream<double> get pressureStream => _pressureController.stream;
  SerialDeviceInfo? get connectedDevice => _connectedDevice;
  bool get isCalibrating => _isCalibrating;
  double get atmosphericPressureOffset => _atmosphericPressureOffset;
  bool get isSensorConnected => _sensorConnected;
  bool get isDeviceAuthenticated => _isAuthenticated;
  bool get isAuthenticationComplete => _authenticationComplete;  // True when auth finished
  
  /// Current firmware output rate in Hz (single source of truth for sampling/display/storage)
  int get outputRate => _outputRate;
  
  /// Output interval in milliseconds
  int get outputIntervalMs => 1000 ~/ _outputRate;
  
  double get calibrationProgress => _calibrationStartTime == null ? 0.0 
      : (DateTime.now().difference(_calibrationStartTime!).inMilliseconds / _calibrationDurationMs).clamp(0.0, 1.0);
  
  void _setState(SerialConnectionState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
  
  void _updatePressure(double rawPressure) {
    // During calibration, collect samples
    if (_isCalibrating) {
      _calibrationSamples.add(rawPressure);
      
      // Check if calibration time elapsed
      if (_calibrationStartTime != null) {
        final elapsed = DateTime.now().difference(_calibrationStartTime!).inMilliseconds;
        if (elapsed >= _calibrationDurationMs) {
          _finishCalibration();
        }
      }
      notifyListeners();
      return;  // Don't emit pressure during calibration
    }
    
    // Apply atmospheric pressure offset
    final adjustedPressure = rawPressure - _atmosphericPressureOffset;
    _currentPressure = adjustedPressure;
    _pressureController.add(adjustedPressure);
    notifyListeners();
  }
  
  Future<List<SerialDeviceInfo>> scanDevices() async {
    if (_state == SerialConnectionState.scanning) {
      return [];
    }
    
    _errorMessage = null;
    _setState(SerialConnectionState.scanning);
    
    // Load cached device names
    await _loadDeviceNameCache();
    
    try {
      final availablePorts = SerialPort.availablePorts;
      debugPrint('Found ${availablePorts.length} serial ports');
      
      final devices = <SerialDeviceInfo>[];
      
      for (final portName in availablePorts) {
        try {
          final port = SerialPort(portName);
          final serial = port.serialNumber;
          
          // Look up cached device name by serial number
          String? cachedName;
          if (serial != null && serial.isNotEmpty) {
            cachedName = _deviceNameCache[serial];
          }
          
          final device = SerialDeviceInfo(
            portName: portName,
            description: port.description,
            manufacturer: port.manufacturer,
            serialNumber: serial,
            vendorId: port.vendorId,
            productId: port.productId,
            deviceName: cachedName,  // Use cached name if available
          );
          
          devices.add(device);
          port.dispose();
          debugPrint('Port: $portName, Desc: ${device.description}, Mfr: ${device.manufacturer}');
        } catch (e) {
          // Skip ports that can't be opened for info
          devices.add(SerialDeviceInfo(portName: portName));
          debugPrint('Port: $portName (no info available)');
        }
      }
      
      // Auto-sync: Only sync from VERIFIED DiveChecker devices (kodenet.io + DiveChecker)
      // This prevents auto-connecting to unknown/malicious USB devices
      for (final device in devices) {
        if (device.isVerifiedDiveChecker) {
          debugPrint('Auto-sync: Verified DiveChecker at ${device.portName}');
          await _syncDeviceNameFromBeacon(device);
        }
      }
      
      _setState(SerialConnectionState.disconnected);
      notifyListeners();  // Update UI with synced names
      return devices;
      
    } catch (e) {
      debugPrint('Scan error: $e');
      _errorMessage = e.toString();
      _setState(SerialConnectionState.error);
      return [];
    }
  }
  
  /// Temporarily connect to device to receive BEACON and sync device name
  Future<void> _syncDeviceNameFromBeacon(SerialDeviceInfo device) async {
    SerialPort? tempPort;
    try {
      tempPort = SerialPort(device.portName);
      
      if (!tempPort.openReadWrite()) {
        debugPrint('Auto-sync: Failed to open ${device.portName}');
        return;
      }
      
      // Configure port
      try {
        final config = tempPort.config;
        config.baudRate = 115200;
        config.bits = 8;
        config.stopBits = 1;
        config.parity = SerialPortParity.none;
        config.setFlowControl(SerialPortFlowControl.none);
        tempPort.config = config;
      } catch (_) {}
      
      // Read data for up to 400ms to catch a BEACON (sent every 200ms)
      String buffer = '';
      final stopwatch = Stopwatch()..start();
      
      while (stopwatch.elapsedMilliseconds < 400) {
        try {
          final bytes = tempPort.read(256, timeout: 100);
          if (bytes.isNotEmpty) {
            buffer += String.fromCharCodes(bytes);
            
            // Check for BEACON line
            if (buffer.contains('\n')) {
              final lines = buffer.split('\n');
              for (final line in lines) {
                if (line.startsWith('BEACON:')) {
                  // Format: BEACON:<serial>:<name>
                  final parts = line.substring(7).split(':');
                  if (parts.length >= 2) {
                    final serial = parts[0];
                    final name = parts.sublist(1).join(':');  // Name may contain ':'
                    
                    if (serial.isNotEmpty && name.isNotEmpty) {
                      device.deviceName = name;
                      _saveDeviceNameToCache(serial, name);
                      debugPrint('Auto-sync: ${device.portName} -> $name');
                    }
                  }
                  stopwatch.stop();
                  break;
                }
              }
              if (!stopwatch.isRunning) break;
            }
          }
        } catch (_) {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 50));
      }
      
    } catch (e) {
      debugPrint('Auto-sync error for ${device.portName}: $e');
    } finally {
      try {
        tempPort?.close();
        tempPort?.dispose();
      } catch (_) {}
    }
  }
  
  Future<bool> connect(SerialDeviceInfo device) async {
    _errorMessage = null;
    _setState(SerialConnectionState.connecting);
    
    try {
      _port = SerialPort(device.portName);
      
      if (!_port!.openReadWrite()) {
        throw Exception('Failed to open port: ${SerialPort.lastError}');
      }
      
      try {
        final config = _port!.config;
        config.baudRate = 115200;
        config.bits = 8;
        config.stopBits = 1;
        config.parity = SerialPortParity.none;
        config.setFlowControl(SerialPortFlowControl.none);
        _port!.config = config;
      } catch (e) {
        debugPrint('Warning: Could not set port config: $e (continuing anyway)');
      }
      
      _connectedDevice = device;
      
      _reader = SerialPortReader(_port!);
      
      _dataSubscription?.cancel();
      _dataSubscription = _reader!.stream.listen(
        _handleData,
        onError: (error) {
          debugPrint('Serial error: $error');
          disconnect();
        },
        onDone: () {
          debugPrint('Serial stream closed');
          disconnect();
        },
      );
      
      _setState(SerialConnectionState.connected);
      
      _deviceInfoRequested = false;  // Reset flag for new connection
      _startPing();
      
      // Device info will be requested after first PONG response
      // Atmospheric calibration will start after sensor status is confirmed OK
      
      return true;
      
    } catch (e) {
      debugPrint('Connection error: $e');
      _errorMessage = 'Connection failed: $e';
      _port?.dispose();
      _port = null;
      _setState(SerialConnectionState.error);
      return false;
    }
  }
  
  void _handleData(Uint8List data) {
    _dataBuffer += String.fromCharCodes(data);
    
    while (_dataBuffer.contains('\n')) {
      final lineEnd = _dataBuffer.indexOf('\n');
      final line = _dataBuffer.substring(0, lineEnd).trim();
      _dataBuffer = _dataBuffer.substring(lineEnd + 1);
      
      _processLine(line);
    }
  }
  
  void _processLine(String line) {
    if (line.isEmpty) return;
    
    // Format: D:<delta_mPa> - delta pressure in mPa (x1000 precision)
    if (line.startsWith('D:')) {
      try {
        final valueStr = line.substring(2);
        final intValue = int.parse(valueStr);
        final pressure = intValue / 1000.0;  // mPa to Pa
        _updatePressure(pressure);
      } catch (e) {
        debugPrint('Failed to parse pressure: $line');
      }
      return;
    }
    
    if (line.startsWith('CFG:')) {
      try {
        final parts = line.substring(4).split(',');
        if (parts.length >= 2) {
          final oversampling = int.parse(parts[0]);
          final sampleRate = int.parse(parts[1]);
          // Update internal output rate state
          _outputRate = sampleRate;
          _onConfigReceived?.call(oversampling, sampleRate);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Failed to parse config: $line');
      }
      return;
    }
    
    // Handle device name saved confirmation (must be checked BEFORE 'INFO:Name ')
    if (line == 'INFO:Name saved') {
      debugPrint('Device name saved to MCU Flash');
      if (_connectedDevice != null) {
        notifyListeners();
      }
      _nameChangeCompleter?.complete(true);
      _nameChangeCompleter = null;
      return;
    }
    
    // Handle device name from MCU
    if (line.startsWith('INFO:Name ')) {
      final name = line.substring(10).trim();
      if (_connectedDevice != null && name.isNotEmpty) {
        _connectedDevice!.deviceName = name;
        debugPrint('Device name from MCU: $name');
        
        // Save to cache for future scans
        final serial = _connectedDevice!.serialNumber;
        if (serial != null && serial.isNotEmpty) {
          _saveDeviceNameToCache(serial, name);
        }
        
        notifyListeners();
      }
      return;
    }
    
    // Handle PIN changed confirmation
    if (line == 'INFO:PIN changed') {
      debugPrint('Device PIN changed');
      _pinChangeCompleter?.complete(true);
      _pinChangeCompleter = null;
      return;
    }
    
    // Handle sensor status from MCU
    if (line.startsWith('INFO:Sensor ')) {
      final status = line.substring(12).trim();
      _sensorConnected = (status == 'OK');
      debugPrint('Sensor status: $status (connected: $_sensorConnected)');
      
      // Start atmospheric calibration only when sensor is OK
      if (_sensorConnected && !_isCalibrating) {
        startAtmosphericCalibration();
      }
      
      notifyListeners();
      return;
    }
    
    // Handle error responses
    if (line == 'ERR:Wrong PIN') {
      debugPrint('Wrong PIN entered');
      _nameChangeCompleter?.complete(false);
      _nameChangeCompleter = null;
      _pinChangeCompleter?.complete(false);
      _pinChangeCompleter = null;
      return;
    }
    
    // Handle ECDSA authentication response
    if (line.startsWith('AUTH_OK:')) {
      final signature = line.substring(8).trim();
      debugPrint('Auth response received, signature length: ${signature.length}');
      
      if (_authNonce != null) {
        final isValid = DeviceAuthenticator.verifySignature(
          nonce: _authNonce!,
          signatureHex: signature,
          publicKey: ecdsaPublicKey,
        );
        
        _isAuthenticated = isValid;
        _authenticationComplete = true;  // Auth attempt finished
        debugPrint('Device authentication: ${isValid ? "SUCCESS ✓" : "FAILED ✗"}');
        _authCompleter?.complete(isValid);
        _authCompleter = null;
        _authNonce = null;
        notifyListeners();
      }
      return;
    }
    
    if (line.startsWith('AUTH_ERR:')) {
      debugPrint('Auth error: $line');
      _isAuthenticated = false;
      _authenticationComplete = true;  // Auth attempt finished (with error)
      _authCompleter?.complete(false);
      _authCompleter = null;
      _authNonce = null;
      notifyListeners();
      return;
    }
    
    if (line.startsWith('ERR:')) {
      debugPrint('[MCU Error] $line');
      _nameChangeCompleter?.complete(false);
      _nameChangeCompleter = null;
      _pinChangeCompleter?.complete(false);
      _pinChangeCompleter = null;
      return;
    }
    
    if (line.startsWith('INFO:')) {
      debugPrint('[MCU] $line');
      return;
    }
    
    if (line == 'PONG') {
      // Request device info after first successful ping
      if (!_deviceInfoRequested) {
        _deviceInfoRequested = true;
        _requestDeviceInfo();
        // Start authentication after device info request
        _authenticateDevice();
      }
      return;
    }
  }
  
  /// Authenticate the connected device using ECDSA challenge-response
  Future<bool> _authenticateDevice() async {
    if (_port == null) return false;
    
    // Generate random nonce
    _authNonce = DeviceAuthenticator.generateNonce();
    _authCompleter = Completer<bool>();
    
    // Send authentication challenge
    final command = 'A$_authNonce\n';
    _port!.write(Uint8List.fromList(command.codeUnits));
    debugPrint('Auth challenge sent: ${_authNonce!.substring(0, 16)}...');
    
    // Wait for response with timeout
    try {
      final result = await _authCompleter!.future.timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          debugPrint('Auth timeout');
          _isAuthenticated = false;
          _authenticationComplete = true;  // Auth attempt finished (timeout)
          _authNonce = null;
          notifyListeners();
          return false;
        },
      );
      return result;
    } catch (e) {
      debugPrint('Auth error: $e');
      _authenticationComplete = true;  // Auth attempt finished (error)
      notifyListeners();
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
    if (_port != null && _state == SerialConnectionState.connected) {
      sendCommand('P');  // Ping command
    }
  }
  
  void _requestDeviceInfo() {
    // Request device info (serial + name) from MCU
    if (_port != null && _state == SerialConnectionState.connected) {
      sendCommand('I');  // Info command
    }
  }
  
  /// Set device name on MCU (stored in Flash, persistent across power cycles)
  /// Returns a Future that completes with true if successful, false if wrong PIN
  Future<bool> setDeviceName(String name, String pin) async {
    if (_port == null || _state != SerialConnectionState.connected) {
      return false;
    }
    
    // Validate PIN format
    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      return false;
    }
    
    // Limit name: max 24 bytes (한글 8자 또는 영어 24자)
    String trimmedName = name;
    while (_getUtf8ByteLength(trimmedName) > 24 && trimmedName.isNotEmpty) {
      trimmedName = trimmedName.substring(0, trimmedName.length - 1);
    }
    
    _nameChangeCompleter = Completer<bool>();
    sendCommand('N$pin$trimmedName');
    
    // Wait for response with timeout
    try {
      final success = await _nameChangeCompleter!.future.timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
      
      // Update local device name on success
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
  /// Returns a Future that completes with true if successful, false if wrong old PIN
  Future<bool> changeDevicePin(String oldPin, String newPin) async {
    if (_port == null || _state != SerialConnectionState.connected) {
      return false;
    }
    
    // Validate PIN format
    if (oldPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(oldPin)) {
      return false;
    }
    if (newPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(newPin)) {
      return false;
    }
    
    _pinChangeCompleter = Completer<bool>();
    sendCommand('W$oldPin$newPin');
    
    // Wait for response with timeout
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
  
  Completer<bool>? _nameChangeCompleter;
  Completer<bool>? _pinChangeCompleter;
  
  /// Get current device name
  String? get deviceName => _connectedDevice?.deviceName;
  
  /// Get connected device serial number
  String? get deviceSerial => _connectedDevice?.serialNumber;
  
  Future<void> disconnect() async {
    _pingTimer?.cancel();
    _pingTimer = null;
    
    _dataSubscription?.cancel();
    _dataSubscription = null;
    
    _isCalibrating = false;
    _calibrationSamples.clear();
    _calibrationStartTime = null;
    _atmosphericPressureOffset = 0.0;
    
    _reader?.close();
    _reader = null;
    
    if (_port != null) {
      try {
        _port!.close();
        _port!.dispose();
      } catch (_) {}
      _port = null;
    }
    
    _connectedDevice = null;
    _currentPressure = 0.0;
    _dataBuffer = '';
    _deviceInfoRequested = false;
    _sensorConnected = true;  // Reset to assume OK for next connection
    _isAuthenticated = false;  // Reset authentication status
    _authenticationComplete = false;  // Reset auth complete flag
    _authNonce = null;
    _authCompleter = null;
    _setState(SerialConnectionState.disconnected);
  }
  
  // ============== Device Name Cache ==============
  
  Future<void> _loadDeviceNameCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_deviceNameCacheKey);
      if (cacheJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(cacheJson);
        _deviceNameCache = decoded.map((k, v) => MapEntry(k, v.toString()));
        debugPrint('Loaded ${_deviceNameCache.length} cached device names');
      }
    } catch (e) {
      debugPrint('Failed to load device name cache: $e');
    }
  }
  
  Future<void> _saveDeviceNameToCache(String serial, String name) async {
    try {
      _deviceNameCache[serial] = name;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_deviceNameCacheKey, jsonEncode(_deviceNameCache));
      debugPrint('Cached device name: $serial -> $name');
    } catch (e) {
      debugPrint('Failed to save device name cache: $e');
    }
  }
  
  Function(int oversampling, int sampleRate)? _onConfigReceived;
  
  void setConfigReceivedCallback(Function(int, int)? callback) {
    _onConfigReceived = callback;
  }
  
  Future<bool> sendCommand(String cmd) async {
    if (_port == null || !_port!.isOpen) {
      return false;
    }
    
    try {
      _port!.write(Uint8List.fromList('$cmd\n'.codeUnits));
      return true;
    } catch (e) {
      debugPrint('Failed to send command: $e');
      return false;
    }
  }
  
  Future<bool> setOversampling(int value) async {
    return sendCommand('O$value');
  }
  
  Future<bool> resetBaseline() async {
    return sendCommand('R');
  }

  /// Set firmware output rate (4-50 Hz)
  /// This is the single source of truth for sampling/display/storage rate
  Future<bool> setOutputRate(int hz) async {
    if (hz < 4 || hz > 50) return false;
    final success = await sendCommand('F$hz');
    if (success) {
      _outputRate = hz;
      notifyListeners();
    }
    return success;
  }
  
  void requestDeviceConfig() {
    sendCommand('C');
  }
  
  void startAtmosphericCalibration() {
    if (_isCalibrating) return;
    
    _isCalibrating = true;
    _calibrationSamples.clear();
    _calibrationStartTime = DateTime.now();
    _atmosphericPressureOffset = 0.0;  // Reset offset during calibration
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
    
    debugPrint('Atmospheric calibration complete: offset = $_atmosphericPressureOffset hPa (${_calibrationSamples.length} samples)');
    
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
  
  @override
  void dispose() {
    _pingTimer?.cancel();
    _dataSubscription?.cancel();
    _reader?.close();
    _port?.dispose();
    _pressureController.close();
    super.dispose();
  }
}
