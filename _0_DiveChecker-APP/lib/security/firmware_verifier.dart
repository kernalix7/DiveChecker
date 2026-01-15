/// Firmware Signature Verification for DiveChecker OTA Updates
/// 
/// Verifies signed firmware packages before flashing.
/// Package format: [4-byte magic][4-byte fw_size][4-byte sig_size][signature][firmware]
/// 
/// Magic: "DC01" (0x44 0x43 0x30 0x31)
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';

import 'ecdsa_public_key.dart';

/// Firmware package information
class FirmwarePackage {
  final String fileName;
  final String filePath;
  final int firmwareSize;
  final int signatureSize;
  final Uint8List signature;
  final Uint8List firmwareData;
  final String firmwareHash;
  final bool isValid;
  final String? errorMessage;
  
  // Firmware version info (parsed from firmware if available)
  final int? versionMajor;
  final int? versionMinor;
  final int? versionPatch;
  final String? targetDevice;  // "DiveChecker-V1", etc.
  
  FirmwarePackage({
    required this.fileName,
    required this.filePath,
    required this.firmwareSize,
    required this.signatureSize,
    required this.signature,
    required this.firmwareData,
    required this.firmwareHash,
    required this.isValid,
    this.errorMessage,
    this.versionMajor,
    this.versionMinor,
    this.versionPatch,
    this.targetDevice,
  });
  
  /// Human readable firmware size
  String get firmwareSizeFormatted {
    if (firmwareSize < 1024) return '$firmwareSize B';
    if (firmwareSize < 1024 * 1024) return '${(firmwareSize / 1024).toStringAsFixed(1)} KB';
    return '${(firmwareSize / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
  
  /// Firmware version string (e.g., "4.5.0")
  String? get versionString {
    if (versionMajor == null) return null;
    return '$versionMajor.${versionMinor ?? 0}.${versionPatch ?? 0}';
  }
  
  /// Check if this firmware is newer than current version
  bool isNewerThan(int major, int minor, int patch) {
    if (versionMajor == null) return false;
    if (versionMajor! > major) return true;
    if (versionMajor! < major) return false;
    if ((versionMinor ?? 0) > minor) return true;
    if ((versionMinor ?? 0) < minor) return false;
    return (versionPatch ?? 0) > patch;
  }
  
  /// Extract the verified firmware to a .uf2 file for flashing
  /// Returns the path to the extracted file, or null on failure
  Future<String?> extractVerifiedFirmware(String outputDir) async {
    if (!isValid || firmwareData.isEmpty) {
      return null;
    }
    
    try {
      // Generate output filename based on original name
      final baseName = fileName.replaceAll('_signed.bin', '').replaceAll('.bin', '');
      final outputPath = '$outputDir/${baseName}_verified.uf2';
      
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(firmwareData);
      
      return outputPath;
    } catch (e) {
      debugPrint('Failed to extract firmware: $e');
      return null;
    }
  }
}

/// Firmware signature verifier using ECDSA P-256
class FirmwareVerifier {
  static const List<int> _magic = [0x44, 0x43, 0x30, 0x31]; // "DC01"
  static final ECDomainParameters _ecParams = ECCurve_secp256r1();
  
  /// List firmware files from a directory
  static Future<List<FileSystemEntity>> listFirmwareFiles(String directoryPath) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      return [];
    }
    
    final files = <FileSystemEntity>[];
    await for (final entity in dir.list()) {
      if (entity is File) {
        final name = entity.path.split('/').last;
        // Look for signed firmware files
        if (name.endsWith('_signed.bin') || name.endsWith('.bin')) {
          files.add(entity);
        }
      }
    }
    
    // Sort by modification time (newest first)
    files.sort((a, b) {
      final aStat = File(a.path).statSync();
      final bStat = File(b.path).statSync();
      return bStat.modified.compareTo(aStat.modified);
    });
    
    return files;
  }
  
  /// Parse and verify a signed firmware package
  static Future<FirmwarePackage> verifyFirmwareFile(String filePath) async {
    final file = File(filePath);
    final fileName = filePath.split('/').last;
    
    try {
      if (!await file.exists()) {
        return _errorPackage(fileName, filePath, 'File not found');
      }
      
      final bytes = await file.readAsBytes();
      
      // Minimum size check: magic(4) + fw_size(4) + sig_size(4) + min_sig(70) + min_fw(1)
      if (bytes.length < 83) {
        return _errorPackage(fileName, filePath, 'File too small');
      }
      
      // Check magic
      for (int i = 0; i < 4; i++) {
        if (bytes[i] != _magic[i]) {
          return _errorPackage(fileName, filePath, 'Invalid magic header (not a signed firmware)');
        }
      }
      
      // Parse header (little-endian)
      final firmwareSize = bytes[4] | (bytes[5] << 8) | (bytes[6] << 16) | (bytes[7] << 24);
      final signatureSize = bytes[8] | (bytes[9] << 8) | (bytes[10] << 16) | (bytes[11] << 24);
      
      // Validate sizes
      if (signatureSize < 70 || signatureSize > 72) {
        return _errorPackage(fileName, filePath, 'Invalid signature size: $signatureSize');
      }
      
      final expectedSize = 12 + signatureSize + firmwareSize;
      if (bytes.length != expectedSize) {
        return _errorPackage(fileName, filePath, 
            'Size mismatch: expected $expectedSize, got ${bytes.length}');
      }
      
      // Extract signature and firmware data
      final signature = Uint8List.fromList(bytes.sublist(12, 12 + signatureSize));
      final firmwareData = Uint8List.fromList(bytes.sublist(12 + signatureSize));
      
      // Compute firmware hash
      final sha256 = SHA256Digest();
      final firmwareHash = sha256.process(firmwareData);
      final hashHex = firmwareHash.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      
      // Try to extract version info from firmware (look for version string pattern)
      final versionInfo = _extractVersionInfo(firmwareData);
      
      // Verify signature
      final isValid = _verifySignature(firmwareData, signature);
      
      return FirmwarePackage(
        fileName: fileName,
        filePath: filePath,
        firmwareSize: firmwareSize,
        signatureSize: signatureSize,
        signature: signature,
        firmwareData: firmwareData,
        firmwareHash: hashHex,
        isValid: isValid,
        errorMessage: isValid ? null : 'Signature verification failed',
        versionMajor: versionInfo['major'],
        versionMinor: versionInfo['minor'],
        versionPatch: versionInfo['patch'],
        targetDevice: versionInfo['device'],
      );
    } catch (e) {
      return _errorPackage(fileName, filePath, 'Error: $e');
    }
  }
  
  /// Extract version info from firmware binary
  /// Looks for patterns like "DiveChecker Firmware v4.5.0" in the binary
  static Map<String, dynamic> _extractVersionInfo(Uint8List firmwareData) {
    final result = <String, dynamic>{};
    
    try {
      // Convert to string for pattern matching (only printable ASCII)
      final dataStr = String.fromCharCodes(
        firmwareData.where((b) => b >= 32 && b < 127)
      );
      
      // Look for version pattern: "v4.5.0" or "4.5.0"
      final versionRegex = RegExp(r'v?(\d+)\.(\d+)\.(\d+)');
      final match = versionRegex.firstMatch(dataStr);
      if (match != null) {
        result['major'] = int.tryParse(match.group(1) ?? '');
        result['minor'] = int.tryParse(match.group(2) ?? '');
        result['patch'] = int.tryParse(match.group(3) ?? '');
      }
      
      // Look for device identifier pattern: "DiveChecker" or "DiveChecker-V1"
      if (dataStr.contains('DiveChecker')) {
        final deviceMatch = RegExp(r'DiveChecker(?:-V\d+)?').firstMatch(dataStr);
        result['device'] = deviceMatch?.group(0) ?? 'DiveChecker';
      }
    } catch (e) {
      debugPrint('Version extraction error: $e');
    }
    
    return result;
  }
  
  /// Verify ECDSA signature
  static bool _verifySignature(Uint8List data, Uint8List signature) {
    try {
      // Hash the firmware data
      final sha256 = SHA256Digest();
      final hash = sha256.process(data);
      
      // Parse DER signature
      final ecSig = _parseDerSignature(signature);
      if (ecSig == null) {
        debugPrint('Failed to parse DER signature');
        return false;
      }
      
      // Load public key
      final ecPublicKey = _loadPublicKey(ecdsaPublicKey);
      if (ecPublicKey == null) {
        debugPrint('Failed to load public key');
        return false;
      }
      
      // Verify (use null digest since we already hashed)
      final verifier = ECDSASigner(null);
      verifier.init(false, PublicKeyParameter<ECPublicKey>(ecPublicKey));
      
      return verifier.verifySignature(hash, ecSig);
    } catch (e) {
      debugPrint('Signature verification error: $e');
      return false;
    }
  }
  
  /// Load EC public key from uncompressed format
  static ECPublicKey? _loadPublicKey(Uint8List publicKeyBytes) {
    if (publicKeyBytes.length != 65 || publicKeyBytes[0] != 0x04) {
      return null;
    }
    
    final x = _bytesToBigInt(publicKeyBytes.sublist(1, 33));
    final y = _bytesToBigInt(publicKeyBytes.sublist(33, 65));
    
    final Q = _ecParams.curve.createPoint(x, y);
    return ECPublicKey(Q, _ecParams);
  }
  
  /// Parse DER-encoded ECDSA signature
  static ECSignature? _parseDerSignature(Uint8List derSig) {
    try {
      if (derSig.length < 8 || derSig[0] != 0x30) {
        return null;
      }
      
      int pos = 2;
      
      // Parse r
      if (derSig[pos] != 0x02) return null;
      pos++;
      int rLen = derSig[pos];
      pos++;
      final rBytes = derSig.sublist(pos, pos + rLen);
      pos += rLen;
      
      // Parse s
      if (derSig[pos] != 0x02) return null;
      pos++;
      int sLen = derSig[pos];
      pos++;
      final sBytes = derSig.sublist(pos, pos + sLen);
      
      final r = _bytesToBigInt(rBytes);
      final s = _bytesToBigInt(sBytes);
      
      return ECSignature(r, s);
    } catch (e) {
      return null;
    }
  }
  
  /// Convert bytes to BigInt
  static BigInt _bytesToBigInt(Uint8List bytes) {
    BigInt result = BigInt.zero;
    for (int i = 0; i < bytes.length; i++) {
      result = (result << 8) | BigInt.from(bytes[i]);
    }
    return result;
  }
  
  /// Create error package
  static FirmwarePackage _errorPackage(String fileName, String filePath, String error) {
    return FirmwarePackage(
      fileName: fileName,
      filePath: filePath,
      firmwareSize: 0,
      signatureSize: 0,
      signature: Uint8List(0),
      firmwareData: Uint8List(0),
      firmwareHash: '',
      isValid: false,
      errorMessage: error,
    );
  }
}
