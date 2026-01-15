// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Conditional MIDI handler export
/// Automatically selects native or web implementation
library;

export 'midi_interface.dart';

// Conditional import: web uses midi_web.dart, native uses midi_native.dart
export 'midi_stub.dart'
    if (dart.library.js_interop) 'midi_web.dart'
    if (dart.library.io) 'midi_native.dart';
