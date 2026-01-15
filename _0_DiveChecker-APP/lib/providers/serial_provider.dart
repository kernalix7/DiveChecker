// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Legacy compatibility layer - re-exports MidiProvider as SerialProvider
/// This file allows existing code to continue using SerialProvider naming
/// while actually using the new cross-platform MidiProvider.
library;

export 'midi_provider.dart';

// Type aliases for backward compatibility
import 'midi_provider.dart';

/// @deprecated Use MidiConnectionState instead
typedef SerialConnectionState = MidiConnectionState;

/// @deprecated Use MidiDeviceInfo instead  
typedef SerialDeviceInfo = MidiDeviceInfo;

/// @deprecated Use MidiProvider instead
typedef SerialProvider = MidiProvider;
