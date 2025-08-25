import 'dart:convert';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = "https://your-backend-url.com/api";
  static LoginSession? session;

  /// Login API
  static Future<LoginSession> login(
    String enroll,
    String password,
    TimelineActor actor,
  ) async {
    final payload = {"enroll": enroll, "password": password};

    // Encrypt before sending
    final encrypted = CryptoUtils.encryptData(payload);

    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"data": encrypted}),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      // Decrypt response
      final decrypted = CryptoUtils.decryptData(responseJson["data"]);

      // Build LoginSession
      final newSession = LoginSession(
        token: decrypted["token"] ?? "",
        username: decrypted["username"] ?? "",
        email: decrypted["email"],
        identityId: enroll,
      );

      // Save globally + persist
      session = newSession;
      await session!.saveToPrefs();

      return newSession;
    } else {
      throw Exception("Failed to login: ${response.body}");
    }
  }

  /// Logout - clears the saved session
  static Future<void> logout() async {
    session = null;
    await LoginSession.clearPrefs();
  }

  /// Load existing session
  static Future<LoginSession?> getSavedSession() async {
    session = await LoginSession.loadFromPrefs();
    return session;
  }
}
