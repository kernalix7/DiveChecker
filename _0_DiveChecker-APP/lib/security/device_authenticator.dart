/// ECDSA Device Authentication for DiveChecker
/// 
/// This module handles challenge-response authentication with
/// DiveChecker hardware using ECDSA P-256 signatures.
/// 
/// Flow:
/// 1. App generates random 32-byte nonce
/// 2. App sends: `A[nonce_hex]\n`
/// 3. MCU signs SHA256(nonce) with private key
/// 4. MCU responds: `AUTH_OK:[signature_hex]\n`
/// 5. App verifies signature with public key
library;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';

import 'ecdsa_utils.dart' as ecdsa;

/// ECDSA Device Authenticator
class DeviceAuthenticator {
  
  /// Generate a random 32-byte nonce as hex string
  static String generateNonce() {
    final random = Random.secure();
    final nonce = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      nonce[i] = random.nextInt(256);
    }
    return ecdsa.bytesToHex(nonce);
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
      final nonceBytes = ecdsa.hexToBytes(nonce);
      if (nonceBytes.length != 32) {
        if (kDebugMode) debugPrint('Invalid nonce length: ${nonceBytes.length}');
        return false;
      }
      
      // Hash the nonce with SHA-256 (same as MCU)
      final sha256 = SHA256Digest();
      final hash = sha256.process(nonceBytes);
      
      // Parse the DER-encoded signature (with length validation)
      final signature = ecdsa.hexToBytes(signatureHex);
      final ecSig = ecdsa.parseDerSignature(signature);
      if (ecSig == null) {
        if (kDebugMode) debugPrint('Failed to parse signature');
        return false;
      }
      
      // Load public key
      final ecPublicKey = ecdsa.loadEcPublicKey(publicKey);
      if (ecPublicKey == null) {
        if (kDebugMode) debugPrint('Failed to load public key');
        return false;
      }
      
      // Verify signature (use NullDigest since hash is already computed)
      final verifier = ECDSASigner(null);
      verifier.init(false, PublicKeyParameter<ECPublicKey>(ecPublicKey));
      
      return verifier.verifySignature(hash, ecSig);
    } catch (e) {
      if (kDebugMode) debugPrint('Signature verification error: $e');
      return false;
    }
  }
}
