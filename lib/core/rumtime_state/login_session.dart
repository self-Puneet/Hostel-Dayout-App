import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSession {
  String token;
  String username;
  String? email;
  String? primaryId;
  String? hostel_id;
  String? hostel;
  String? identityId;
  DateTime? expiry;
  String? phone;
  String? fcmToken;
  TimelineActor role;
  String? imageURL;

  LoginSession({
    required this.token,
    required this.username,
    this.email,
    this.identityId,
    this.primaryId,
    this.expiry,
    this.phone,
    this.fcmToken,
    required this.role,
    this.hostel_id,
    this.hostel,
    this.imageURL,
  });

  Map<String, dynamic> toJson() => {
    "token": token,
    "username": username,
    "email": email,
    "identityId": identityId,
    "expiry": expiry?.toIso8601String(),
    "phone": phone,
    "fcm_token": fcmToken,
    "role": TimelineActorX.toShortString(role),
    "hostel_id": hostel_id,
    "hostel": hostel,
    "imageURL": imageURL,
    "primaryId": primaryId,
  };

  factory LoginSession.fromJson(Map<String, dynamic> json) => LoginSession(
    token: json["token"],
    username: json["username"],
    email: json["email"],
    identityId: json["identityId"],
    expiry: json["expiry"] != null ? DateTime.tryParse(json["expiry"]) : null,
    phone: json["phone"],
    fcmToken: json["fcm_token"],
    role: TimelineActorX.fromString(json["role"]),
    hostel_id: json["hostel_id"],
    hostel: json["hostel"],
    imageURL: json["imageURL"],
    primaryId: json["primaryId"],
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

  static Future<Either<String, String>> getValidToken() async {
    try {
      final session = await LoginSession.loadFromPrefs();

      if (session == null) {
        return left('Session not found. Please login again.');
      }

      if (session.token.isEmpty) {
        return left('Invalid session token. Please login again.');
      }

      return right(session.token);
    } catch (e) {
      return left('Error loading session: $e');
    }
  }
}
