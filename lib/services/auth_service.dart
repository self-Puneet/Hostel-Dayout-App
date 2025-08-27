import 'dart:convert';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StudentAuthService {
  static const String apiUrl = "http://20.192.25.27:4141/api/student/login";
  static String get cryptoSecret => dotenv.env['CRYPTO_SECRET'] ?? '';
  static Uint8List get cryptoIv {
    final ivString = dotenv.env['CRYPTO_IV'] ?? '';
    final ivList = ivString
        .split(',')
        .map((e) => int.parse(e, radix: 16))
        .toList();
    return Uint8List.fromList(ivList);
  }

  static Future<Map<String, dynamic>?> loginStudent({
    required String enrollmentNo,
    required String password,
  }) async {
    try {
      final payload = {"enrollment_no": enrollmentNo, "password": password};

      final encrypted = CryptoUtil.encryptPayload(
        payload,
        cryptoSecret,
        cryptoIv,
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"encrypted": encrypted}),
      );

      print("📡 Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          final encryptedResponse = response.body.trim().replaceAll('"', '');
          final decrypted = CryptoUtil.decryptPayload(
            encryptedResponse,
            cryptoSecret,
            cryptoIv,
          );
          return decrypted;
        } catch (e) {
          print("❌ Error decrypting: $e");
          print("Raw response: ${response.body}");
        }
      } else {
        try {
          print("❌ Error: ${response.body}");
          final encryptedResponse = response.body.trim().replaceAll('"', '');
          final decrypted = CryptoUtil.decryptPayload(
            encryptedResponse,
            cryptoSecret,
            cryptoIv,
          );
          return decrypted;
        } catch (e) {
          print("❌ Error decrypting: $e");
          print("Raw response: ${response.body}");
        }
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
    return null;
  }

  /// Student Logout - clears the saved session
  static Future<void> logoutStudent() async {
    await LoginSession.clearPrefs();
  }

  /// Load existing student session
  static Future<LoginSession?> getSavedStudentSession() async {
    final session = await LoginSession.loadFromPrefs();
    if (session != null && Get.isRegistered<LoginSession>()) {
      final diSession = Get.find<LoginSession>();
      diSession.token = session.token;
      diSession.username = session.username;
      diSession.email = session.email;
      diSession.identityId = session.identityId;
      diSession.role = session.role;
    }
    return session;
  }
}
