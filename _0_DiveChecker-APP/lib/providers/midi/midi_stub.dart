// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Stub MIDI handler - throws unsupported error
/// Used when neither native nor web implementations are available
library;

import 'midi_interface.dart';

MidiHandler createMidiHandler() {
  throw UnsupportedError('MIDI not supported on this platform');
}
