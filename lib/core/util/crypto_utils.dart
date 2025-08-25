import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

class CryptoUtils {
  static late encrypt.Key _key;
  static late encrypt.IV _iv;

  /// Call this once, maybe at app startup
  static void init(String secret, String ivHex) {
    // derive 32-byte key from secret (sha256)
    final hash = sha256.convert(utf8.encode(secret)).bytes;
    _key = encrypt.Key(Uint8List.fromList(hash.sublist(0, 32)));

    // IV must be 16 bytes from hex string
    _iv = encrypt.IV.fromBase16(ivHex);
  }

  /// Encrypt data (any Dart object → JSON → AES → base64)
  static String encryptData(dynamic data) {
    final plainText = jsonEncode(data);
    final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt base64 string → JSON → Dart object
  static dynamic decryptData(String encryptedBase64) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedBase64, iv: _iv);
    return jsonDecode(decrypted);
  }
}


void main() {
  // Values must match backend .env
  const secret = "your-secret-from-.env"; 
  const ivHex = "your-iv-in-hex"; // must be 32 hex chars (16 bytes)

  CryptoUtils.init(secret, ivHex);

  final data = {"userId": 123, "role": "student"};

  // Encrypt before sending
  final encrypted = CryptoUtils.encryptData(data);
  print("Encrypted: $encrypted");

  // Decrypt after receiving
  final decrypted = CryptoUtils.decryptData(encrypted);
  print("Decrypted: $decrypted");
}
