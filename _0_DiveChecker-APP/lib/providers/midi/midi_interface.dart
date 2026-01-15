// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Abstract MIDI interface for cross-platform support.
/// Implementations: native (flutter_midi_command), web (Web MIDI API)
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// MIDI device information
class MidiDeviceData {
  final String id;
  final String name;
  final bool isConnected;
  
  MidiDeviceData({
    required this.id,
    required this.name,
    this.isConnected = false,
  });
}

/// Abstract MIDI handler interface
abstract class MidiHandler {
  /// Get available MIDI devices
  Future<List<MidiDeviceData>> getDevices();
  
  /// Connect to a specific device
  Future<bool> connect(String deviceId);
  
  /// Disconnect from current device
  Future<void> disconnect();
  
  /// Send SysEx message
  Future<bool> sendSysEx(List<int> data);
  
  /// Stream of incoming MIDI data
  Stream<Uint8List> get onDataReceived;
  
  /// Stream of device setup changes
  Stream<void> get onDeviceSetupChanged;
  
  /// Check if currently connected
  bool get isConnected;
  
  /// Dispose resources
  void dispose();
}
