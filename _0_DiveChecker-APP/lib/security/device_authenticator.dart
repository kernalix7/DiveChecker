/// ECDSA Device Authentication for DiveChecker
/// 
/// This module handles challenge-response authentication with
/// DiveChecker hardware using ECDSA P-256 signatures.
/// 
/// Flow:
/// 1. App generates random 32-byte nonce
/// 2. App sends: A<nonce_hex>\n
/// 3. MCU signs SHA256(nonce) with private key
/// 4. MCU responds: AUTH_OK:<signature_hex>\n
/// 5. App verifies signature with public key
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';

/// ECDSA Device Authenticator
class DeviceAuthenticator {
  // P-256 curve parameters
  static final ECDomainParameters _ecParams = ECCurve_secp256r1();
  
  /// Generate a random 32-byte nonce as hex string
  static String generateNonce() {
    final random = Random.secure();
    final nonce = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      nonce[i] = random.nextInt(256);
    }
    return _bytesToHex(nonce);
  }
  
  /// Verify ECDSA signature from MCU
  /// 
  /// [nonce] - The nonce that was sent to MCU (hex string, 64 chars)
  /// [signatureHex] - The signature from MCU (DER format, hex string)
  /// [publicKey] - The device public key (65 bytes, uncompressed)
  /// 
  /// Returns true if signature is valid (device is authentic)
  static bool verifySignature({
    required String nonce,
    required String signatureHex,
    required Uint8List publicKey,
  }) {
    try {
      // Convert nonce hex to bytes
      final nonceBytes = _hexToBytes(nonce);
      if (nonceBytes.length != 32) {
        debugPrint('Invalid nonce length: ${nonceBytes.length}');
        return false;
      }
      
      // Hash the nonce with SHA-256 (same as MCU)
      final sha256 = SHA256Digest();
      final hash = sha256.process(nonceBytes);
      
      // Parse the DER-encoded signature
      final signature = _hexToBytes(signatureHex);
      final ecSig = _parseDerSignature(signature);
      if (ecSig == null) {
        debugPrint('Failed to parse signature');
        return false;
      }
      
      // Load public key
      final ecPublicKey = _loadPublicKey(publicKey);
      if (ecPublicKey == null) {
        debugPrint('Failed to load public key');
        return false;
      }
      
      // Verify signature (use NullDigest since hash is already computed)
      final verifier = ECDSASigner(null);
      verifier.init(false, PublicKeyParameter<ECPublicKey>(ecPublicKey));
      
      return verifier.verifySignature(hash, ecSig);
    } catch (e) {
      debugPrint('Signature verification error: $e');
      return false;
    }
  }
  
  /// Load EC public key from uncompressed format (04 || X || Y)
  static ECPublicKey? _loadPublicKey(Uint8List publicKeyBytes) {
    if (publicKeyBytes.length != 65 || publicKeyBytes[0] != 0x04) {
      return null;
    }
    
    final x = _bytesToBigInt(publicKeyBytes.sublist(1, 33));
    final y = _bytesToBigInt(publicKeyBytes.sublist(33, 65));
    
    final Q = _ecParams.curve.createPoint(x, y);
    return ECPublicKey(Q, _ecParams);
  }
  
  /// Parse DER-encoded ECDSA signature to ECSignature
  static ECSignature? _parseDerSignature(Uint8List derSig) {
    try {
      // DER format: 30 <len> 02 <r_len> <r> 02 <s_len> <s>
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
  
  /// Convert bytes to hex string
  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
  
  /// Convert hex string to bytes
  static Uint8List _hexToBytes(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (int i = 0; i < result.length; i++) {
      result[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return result;
  }
}
