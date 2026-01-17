// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Web MIDI handler using Web MIDI API
/// Supports: Chrome, Edge, Opera (Chromium-based browsers)
library;

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';

import 'midi_interface.dart';

// Web MIDI API bindings using extension types
@JS('navigator.requestMIDIAccess')
external JSPromise<MIDIAccess> _requestMIDIAccess();

extension type MIDIAccess._(JSObject _) implements JSObject {
  external JSObject get inputs;
  external JSObject get outputs;
  external set onstatechange(JSFunction? callback);
}

extension type MIDIPort._(JSObject _) implements JSObject {
  external String get id;
  external String get name;
  external String get state;
  external String get type;
}

extension type MIDIInput._(JSObject _) implements MIDIPort {
  external set onmidimessage(JSFunction? callback);
  external JSPromise<MIDIInput> open();
  external JSPromise<MIDIInput> close();
}

extension type MIDIOutput._(JSObject _) implements MIDIPort {
  external void send(JSUint8Array data);
  external JSPromise<MIDIOutput> open();
  external JSPromise<MIDIOutput> close();
}

extension type MIDIMessageEvent._(JSObject _) implements JSObject {
  external JSUint8Array get data;
}

/// Factory function for conditional import
MidiHandler createMidiHandler() => WebMidiHandler();

class WebMidiHandler implements MidiHandler {
  MIDIAccess? _midiAccess;
  MIDIInput? _connectedInput;
  MIDIOutput? _connectedOutput;
  
  final _dataController = StreamController<Uint8List>.broadcast();
  final _setupController = StreamController<void>.broadcast();
  
  bool _initialized = false;
  
  WebMidiHandler();
  
  Future<bool> _ensureInitialized() async {
    if (_initialized) return _midiAccess != null;
    
    try {
      final access = await _requestMIDIAccess().toDart;
      _midiAccess = access;
      
      _midiAccess!.onstatechange = ((JSObject event) {
        _setupController.add(null);
      }).toJS;
      
      _initialized = true;
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Web MIDI API not available: $e');
      _initialized = true;
      return false;
    }
  }
  
  List<T> _iterateMap<T>(JSObject map, T Function(JSObject) transform) {
    final result = <T>[];
    final entries = map.callMethod<JSObject>('values'.toJS);
    
    while (true) {
      final next = entries.callMethod<JSObject>('next'.toJS);
      final done = (next.getProperty<JSBoolean>('done'.toJS)).toDart;
      if (done) break;
      
      final value = next.getProperty<JSObject>('value'.toJS);
      result.add(transform(value));
    }
    
    return result;
  }
  
  @override
  Future<List<MidiDeviceData>> getDevices() async {
    if (!await _ensureInitialized() || _midiAccess == null) {
      return [];
    }
    
    final devices = <MidiDeviceData>[];
    
    // Get all input devices
    final inputs = _midiAccess!.inputs;
    final inputList = _iterateMap<MidiDeviceData>(inputs, (obj) {
      final input = MIDIInput._(obj);
      return MidiDeviceData(
        id: input.id,
        name: input.name,
        isConnected: input.state == 'connected',
      );
    });
    devices.addAll(inputList);
    
    return devices;
  }
  
  @override
  Future<bool> connect(String deviceId) async {
    if (!await _ensureInitialized() || _midiAccess == null) {
      return false;
    }
    
    try {
      // Find and connect input
      final inputs = _midiAccess!.inputs;
      final inputObj = inputs.callMethod<JSAny?>('get'.toJS, deviceId.toJS);
      if (inputObj != null && !inputObj.isUndefinedOrNull) {
        _connectedInput = MIDIInput._(inputObj as JSObject);
        await _connectedInput!.open().toDart;
        
        _connectedInput!.onmidimessage = ((MIDIMessageEvent event) {
          final data = event.data.toDart;
          _dataController.add(data);
        }).toJS;
      }
      
      // Find and connect output (same device ID or matching pattern)
      final outputs = _midiAccess!.outputs;
      final outputObj = outputs.callMethod<JSAny?>('get'.toJS, deviceId.toJS);
      if (outputObj != null && !outputObj.isUndefinedOrNull) {
        _connectedOutput = MIDIOutput._(outputObj as JSObject);
        await _connectedOutput!.open().toDart;
      }
      
      return _connectedInput != null || _connectedOutput != null;
    } catch (e) {
      if (kDebugMode) debugPrint('Web MIDI connect error: $e');
      return false;
    }
  }
  
  @override
  Future<void> disconnect() async {
    try {
      if (_connectedInput != null) {
        _connectedInput!.onmidimessage = null;
        await _connectedInput!.close().toDart;
      }
      if (_connectedOutput != null) {
        await _connectedOutput!.close().toDart;
      }
    } catch (_) {}
    _connectedInput = null;
    _connectedOutput = null;
  }
  
  @override
  Future<bool> sendSysEx(List<int> data) async {
    if (_connectedOutput == null) return false;
    
    try {
      final jsData = Uint8List.fromList(data).toJS;
      _connectedOutput!.send(jsData);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Web MIDI send error: $e');
      return false;
    }
  }
  
  @override
  Stream<Uint8List> get onDataReceived => _dataController.stream;
  
  @override
  Stream<void> get onDeviceSetupChanged => _setupController.stream;
  
  @override
  bool get isConnected => _connectedInput != null || _connectedOutput != null;
  
  @override
  void dispose() {
    disconnect();
    _dataController.close();
    _setupController.close();
  }
}
