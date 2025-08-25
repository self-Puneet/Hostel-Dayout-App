import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSession {
  final String token;
  final String username;
  final String? email;
  final String? identityId;
  final DateTime? expiry;
  final String? phone;
  final String? fcmToken;

  LoginSession({
    required this.token,
    required this.username,
    this.email,
    this.identityId,
    this.expiry,
    this.phone,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        "token": token,
        "username": username,
        "email": email,
        "identityId": identityId,
        "expiry": expiry?.toIso8601String(),
        "phone": phone,
        "fcm_token": fcmToken,
      };

  factory LoginSession.fromJson(Map<String, dynamic> json) => LoginSession(
        token: json["token"],
        username: json["username"],
        email: json["email"],
        identityId: json["identityId"],
        expiry: json["expiry"] != null ? DateTime.tryParse(json["expiry"]) : null,
        phone: json["phone"],
        fcmToken: json["fcm_token"],
      );

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("login_session", jsonEncode(toJson()));
  }

  static Future<LoginSession?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("login_session");
    if (data == null) return null;
    try {
      return LoginSession.fromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("login_session");
  }

  bool get isValid {
    if (expiry == null) return true;
    return DateTime.now().isBefore(expiry!);
  }
}
