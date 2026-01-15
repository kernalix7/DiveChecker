// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'platform_utils_stub.dart'
    if (dart.library.io) 'platform_utils_io.dart';

Future<void> initializeDesktopDatabase() async {
  await initializeDatabase();
}
