// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';

Future<String?> downloadFile(String content, String filename) async {
  try {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    
    html.Url.revokeObjectUrl(url);
    return filename;
  } catch (e) {
    return null;
  }
}

Future<String?> pickAndReadFile() async {
  try {
    final uploadInput = html.FileUploadInputElement()
      ..accept = '.json';
    uploadInput.click();

    await uploadInput.onChange.first;
    
    if (uploadInput.files?.isEmpty ?? true) {
      return null;
    }

    final file = uploadInput.files!.first;
    final reader = html.FileReader();
    reader.readAsText(file);
    
    await reader.onLoad.first;
    return reader.result as String?;
  } catch (e) {
    return null;
  }
}
