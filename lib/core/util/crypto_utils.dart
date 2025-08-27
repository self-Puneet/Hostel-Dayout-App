import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

class CryptoUtil {
  static Uint8List deriveKey(String secret) {
    // SHA256(secret) → base64 → take first 32 chars → utf8 bytes
    final sha256Bytes = sha256.convert(utf8.encode(secret)).bytes;
    final sha256B64 = base64.encode(sha256Bytes);
    final key32 = sha256B64.substring(0, 32);
    return Uint8List.fromList(utf8.encode(key32));
  }

  static String encryptPayload(
      Map<String, dynamic> payload, String secret, Uint8List iv) {
    final key = deriveKey(secret);

    final cipher = CBCBlockCipher(AESFastEngine())
      ..init(
        true,
        ParametersWithIV(KeyParameter(key), iv),
      );

    final input = utf8.encode(jsonEncode(payload));
    final padded = _pad(Uint8List.fromList(input), cipher.blockSize);

    final output = Uint8List(padded.length);
    for (int offset = 0; offset < padded.length;) {
      offset += cipher.processBlock(padded, offset, output, offset);
    }

    return base64.encode(output);
  }

  static Map<String, dynamic> decryptPayload(
      String encryptedB64, String secret, Uint8List iv) {
    final key = deriveKey(secret);
    final cipher = CBCBlockCipher(AESFastEngine())
      ..init(
        false,
        ParametersWithIV(KeyParameter(key), iv),
      );

    final encryptedBytes = base64.decode(encryptedB64);
    final decryptedPadded = Uint8List(encryptedBytes.length);

    for (int offset = 0; offset < encryptedBytes.length;) {
      offset += cipher.processBlock(
          encryptedBytes, offset, decryptedPadded, offset);
    }

    final unpadded = _unpad(decryptedPadded);
    return jsonDecode(utf8.decode(unpadded));
  }

  /// PKCS7 Padding
  static Uint8List _pad(Uint8List data, int blockSize) {
    final padLen = blockSize - (data.length % blockSize);
    return Uint8List.fromList(data + List<int>.filled(padLen, padLen));
  }

  static Uint8List _unpad(Uint8List data) {
    final padLen = data.last;
    return data.sublist(0, data.length - padLen);
  }
}
