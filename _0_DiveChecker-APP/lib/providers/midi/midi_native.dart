// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
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
  
  StreamController<Uint8List>? _dataController;
  StreamController<void>? _setupController;
  StreamSubscription? _dataSubscription;
  StreamSubscription? _setupSubscription;
  
  MidiDevice? _connectedDevice;
  
  NativeMidiHandler() {
    _dataController = StreamController<Uint8List>.broadcast();
    _setupController = StreamController<void>.broadcast();
    
    // Listen to device setup changes
    _setupSubscription = _midiCommand.onMidiSetupChanged?.listen((_) {
      _setupController?.add(null);
    });
    
    // Listen to incoming MIDI data
    _dataSubscription = _midiCommand.onMidiDataReceived?.listen((packet) {
      if (packet.data.isNotEmpty) {
        _dataController?.add(Uint8List.fromList(packet.data));
      }
    });
  }
  
  @override
  Future<List<MidiDeviceData>> getDevices() async {
    final devices = await _midiCommand.devices ?? [];
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
      
      await _midiCommand.connectToDevice(device);
      _connectedDevice = device;
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Native MIDI connect error: $e');
      return false;
    }
  }
  
  @override
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      _midiCommand.disconnectDevice(_connectedDevice!);
      _connectedDevice = null;
    }
  }
  
  @override
  Future<bool> sendSysEx(List<int> data) async {
    if (_connectedDevice == null) return false;
    
    try {
      _midiCommand.sendData(Uint8List.fromList(data), deviceId: _connectedDevice!.id);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Native MIDI send error: $e');
      return false;
    }
  }
  
  @override
  Stream<Uint8List> get onDataReceived => _dataController!.stream;
  
  @override
  Stream<void> get onDeviceSetupChanged => _setupController!.stream;
  
  @override
  bool get isConnected => _connectedDevice != null;
  
  @override
  void dispose() {
    _dataSubscription?.cancel();
    _setupSubscription?.cancel();
    _dataController?.close();
    _setupController?.close();
    disconnect();
  }
}

/// Factory function for conditional import
MidiHandler createMidiHandler() => NativeMidiHandler();
