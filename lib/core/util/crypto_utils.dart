import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pointycastle/export.dart';
import 'package:http/http.dart' as http;

class CryptoUtil {
  static bool isHttpSuccess(int statusCode) =>
      statusCode >= 200 && statusCode <= 206;

  static Map<String, dynamic>? handleEncryptedResponse({
    required http.Response response,
    String? context,
  }) {
    final encryptedBody = response.body.trim().replaceAll('"', '');

    if (isHttpSuccess(response.statusCode)) {
      try {
        final decrypted = CryptoUtil.decryptPayload(encryptedBody);
        return decrypted;
      } catch (e) {
        // return {"error": "Failed to decrypt success response"};
      }
    } else {
      try {
        final decryptedError = CryptoUtil.decryptPayload(encryptedBody);
        return {"error": decryptedError};
      } catch (e) {
        return {"error": response.body};
      }
    }
    return null;
  }

  static Uint8List deriveKey() {
    final secret = cryptoSecret;
    // SHA256(secret) → base64 → take first 32 chars → utf8 bytes
    final sha256Bytes = sha256.convert(utf8.encode(secret)).bytes;
    final sha256B64 = base64.encode(sha256Bytes);
    final key32 = sha256B64.substring(0, 32);
    return Uint8List.fromList(utf8.encode(key32));
  }

  static String encryptPayload(Map<String, dynamic> payload) {
    final key = deriveKey();
    final cipher = CBCBlockCipher(AESFastEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), cryptoIv));
    final input = utf8.encode(jsonEncode(payload));
    final padded = _pad(Uint8List.fromList(input), cipher.blockSize);
    final output = Uint8List(padded.length);
    for (int offset = 0; offset < padded.length;) {
      offset += cipher.processBlock(padded, offset, output, offset);
    }
    return base64.encode(output);
  }

  static Map<String, dynamic> decryptPayload(String encryptedB64) {
    final key = deriveKey();
    final cipher = CBCBlockCipher(AESFastEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), cryptoIv));
    final encryptedBytes = base64.decode(encryptedB64);
    final decryptedPadded = Uint8List(encryptedBytes.length);
    for (int offset = 0; offset < encryptedBytes.length;) {
      offset += cipher.processBlock(
        encryptedBytes,
        offset,
        decryptedPadded,
        offset,
      );
    }
    final unpadded = _unpad(decryptedPadded);
    return jsonDecode(utf8.decode(unpadded));
  }

  static Uint8List _pad(Uint8List data, int blockSize) {
    final padLen = blockSize - (data.length % blockSize);
    return Uint8List.fromList(data + List<int>.filled(padLen, padLen));
  }

  static Uint8List _unpad(Uint8List data) {
    final padLen = data.last;
    return data.sublist(0, data.length - padLen);
  }

  static Uint8List get cryptoIv {
    final ivString = dotenv.env['CRYPTO_IV'] ?? '';
    final ivList = ivString
        .split(',')
        .map((e) => int.parse(e, radix: 16))
        .toList();
    return Uint8List.fromList(ivList);
  }

  static String get cryptoSecret => dotenv.env['CRYPTO_SECRET'] ?? '';

  // static Uint8List get cryptoIv {
  //   final ivString = Env.env['CRYPTO_IV'] ?? '';
  //   final ivList = ivString
  //       .split(',')
  //       .map((e) => int.parse(e, radix: 16))
  //       .toList();
  //   return Uint8List.fromList(ivList);
  // }

  // static String get cryptoSecret => Env.env['CRYPTO_SECRET'] ?? '';
}
