// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Native MIDI handler using flutter_midi_command
/// Supports: iOS, Android, macOS, Windows, Linux
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

import 'midi_interface.dart';

class NativeMidiHandler implements MidiHandler {
  final MidiCommand _midiCommand = MidiCommand();
  
  late final StreamController<Uint8List> _dataController;
  late final StreamController<void> _setupController;
  StreamSubscription? _dataSubscription;
  StreamSubscription? _setupSubscription;
  
  MidiDevice? _connectedDevice;
  bool _isDisposed = false;
  
  NativeMidiHandler() {
    _dataController = StreamController<Uint8List>.broadcast();
    _setupController = StreamController<void>.broadcast();
    
    // Listen to device setup changes
    _setupSubscription = _midiCommand.onMidiSetupChanged?.listen((_) {
      _setupController.add(null);
    });
    
    // Listen to incoming MIDI data
    _dataSubscription = _midiCommand.onMidiDataReceived?.listen((packet) {
      if (packet.data.isNotEmpty) {
        _dataController.add(Uint8List.fromList(packet.data));
      }
    });
  }
  
  @override
  Future<List<MidiDeviceData>> getDevices() async {
    var devices = await _midiCommand.devices ?? [];
    
    // On iOS, CoreMIDI may take a moment to enumerate USB devices.
    // If no devices found on first try, wait briefly and retry once.
    if (devices.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      devices = await _midiCommand.devices ?? [];
    }
    
    return devices.map((d) => MidiDeviceData(
      id: d.id,
      name: d.name,
      isConnected: d.connected,
    )).toList();
  }
  
  @override
  Future<bool> connect(String deviceId) async {
    try {
      final devices = await _midiCommand.devices ?? [];
      final device = devices.firstWhere(
        (d) => d.id == deviceId,
        orElse: () => throw Exception('Device not found'),
      );

      // Reset the global MIDI data listener to drain any stale OS-level buffers
      // from the previous device connection
      _dataSubscription?.cancel();

      await _midiCommand.connectToDevice(device);
      _connectedDevice = device;

      // Re-establish the listener on a fresh stream state
      _dataSubscription = _midiCommand.onMidiDataReceived?.listen((packet) {
        if (packet.data.isNotEmpty && !_isDisposed) {
          _dataController.add(Uint8List.fromList(packet.data));
        }
      });

      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Native MIDI connect error: $e');
      return false;
    }
  }
  
  @override
  Future<void> disconnect() async {
    // Cancel the data listener to stop processing stale buffered data
    _dataSubscription?.cancel();
    _dataSubscription = null;

    final device = _connectedDevice;
    _connectedDevice = null;  // Clear FIRST to prevent any further writes
    if (device != null) {
      try {
        // Device may already be gone (BOOTSEL, unplug) - catch any native errors
        _midiCommand.disconnectDevice(device);
      } catch (e) {
        if (kDebugMode) debugPrint('Native MIDI disconnect (device may be gone): $e');
      }
    }
  }
  
  @override
  Future<bool> sendSysEx(List<int> data) async {
    final device = _connectedDevice;
    if (device == null) return false;
    
    try {
      _midiCommand.sendData(Uint8List.fromList(data), deviceId: device.id);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Native MIDI send error: $e');
      // Device may have disappeared - clear reference
      _connectedDevice = null;
      return false;
    }
  }
  
  @override
  Stream<Uint8List> get onDataReceived => _dataController.stream;
  
  @override
  Stream<void> get onDeviceSetupChanged => _setupController.stream;
  
  @override
  bool get isConnected => _connectedDevice != null;
  
  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _dataSubscription?.cancel();
    _setupSubscription?.cancel();
    disconnect();
    _dataController.close();
    _setupController.close();
  }
}

/// Factory function for conditional import
MidiHandler createMidiHandler() => NativeMidiHandler();
