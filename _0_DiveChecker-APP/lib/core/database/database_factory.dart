// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'database_interface.dart';
import 'sqlite_database_service.dart';
import 'indexeddb_database_service.dart';

export 'database_interface.dart';

class DatabaseServiceFactory {
  static IDatabaseService? _instance;
  
  static IDatabaseService get instance {
    if (_instance != null) return _instance!;
    
    if (kIsWeb) {
      _instance = IndexedDbDatabaseService.instance;
    } else {
      _instance = SqliteDatabaseService.instance;
    }
    
    return _instance!;
  }
  
  static void reset() {
    _instance = null;
  }
}

IDatabaseService get db => DatabaseServiceFactory.instance;
