// Copyright (C) 2025-2026 Createch (legal@createch.kr)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

export 'file_helper_stub.dart'
    if (dart.library.html) 'file_helper_web.dart'
    if (dart.library.io) 'file_helper_io.dart';
