// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0.

/// Shared ECDSA utility functions for DiveChecker
///
/// Common DER signature parsing, public key loading, and byte conversion
/// used by both device authentication and firmware verification.
library;

import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';

/// ECDSA P-256 curve parameters (shared singleton)
final ECDomainParameters ecdsaP256Params = ECCurve_secp256r1();

/// Parse DER-encoded ECDSA signature to ECSignature
///
/// DER format: 30 <total_len> 02 <r_len> <r_bytes> 02 <s_len> <s_bytes>
/// Returns null if the signature is malformed.
ECSignature? parseDerSignature(Uint8List derSig) {
  try {
    // Minimum: 30 <len> 02 <1> <r> 02 <1> <s> = 8 bytes
    if (derSig.length < 8 || derSig[0] != 0x30) {
      return null;
    }

    // Validate total length field
    final totalLen = derSig[1];
    if (totalLen + 2 != derSig.length) {
      if (kDebugMode) {
        debugPrint('DER length mismatch: declared=$totalLen, actual=${derSig.length - 2}');
      }
      return null;
    }

    int pos = 2;

    // Parse r
    if (pos >= derSig.length || derSig[pos] != 0x02) return null;
    pos++;
    if (pos >= derSig.length) return null;
    final rLen = derSig[pos];
    pos++;
    if (pos + rLen > derSig.length) return null;
    final rBytes = derSig.sublist(pos, pos + rLen);
    pos += rLen;

    // Parse s
    if (pos >= derSig.length || derSig[pos] != 0x02) return null;
    pos++;
    if (pos >= derSig.length) return null;
    final sLen = derSig[pos];
    pos++;
    if (pos + sLen > derSig.length) return null;
    final sBytes = derSig.sublist(pos, pos + sLen);

    final r = bytesToBigInt(rBytes);
    final s = bytesToBigInt(sBytes);

    return ECSignature(r, s);
  } catch (e) {
    if (kDebugMode) debugPrint('DER parse error: $e');
    return null;
  }
}

/// Load EC public key from uncompressed format (04 || X || Y)
ECPublicKey? loadEcPublicKey(Uint8List publicKeyBytes) {
  if (publicKeyBytes.length != 65 || publicKeyBytes[0] != 0x04) {
    return null;
  }

  final x = bytesToBigInt(publicKeyBytes.sublist(1, 33));
  final y = bytesToBigInt(publicKeyBytes.sublist(33, 65));

  final Q = ecdsaP256Params.curve.createPoint(x, y);
  return ECPublicKey(Q, ecdsaP256Params);
}

/// Convert bytes to BigInt (big-endian unsigned)
BigInt bytesToBigInt(Uint8List bytes) {
  BigInt result = BigInt.zero;
  for (int i = 0; i < bytes.length; i++) {
    result = (result << 8) | BigInt.from(bytes[i]);
  }
  return result;
}

/// Convert bytes to hex string
String bytesToHex(Uint8List bytes) {
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

/// Convert hex string to bytes
/// Throws FormatException if hex string has odd length or invalid characters.
Uint8List hexToBytes(String hex) {
  if (hex.length % 2 != 0) {
    throw FormatException('Hex string must have even length, got ${hex.length}');
  }
  final result = Uint8List(hex.length ~/ 2);
  for (int i = 0; i < result.length; i++) {
    result[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return result;
}
