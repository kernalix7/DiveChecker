// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

Future<String?> downloadFile(String content, String filename) async {
  try {
    Directory? directory;
    
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getDownloadsDirectory();
    }
    
    directory ??= await getApplicationDocumentsDirectory();
    
    final file = File('${directory.path}/$filename');
    await file.writeAsString(content);
    
    return file.path;
  } catch (e) {
    return null;
  }
}

Future<String?> pickAndReadFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = File(result.files.single.path!);
    return await file.readAsString();
  } catch (e) {
    return null;
  }
}
