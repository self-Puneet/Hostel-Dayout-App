import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HostelInfo {
  String hostelId;
  String hostelName;

  HostelInfo({required this.hostelId, required this.hostelName});

  // JSON serialization
  Map<String, dynamic> toJson() => {
    "hostel_id": hostelId,
    "hostel_name": hostelName,
  };

  factory HostelInfo.fromJson(Map<String, dynamic> json) =>
      HostelInfo(hostelId: json["hostel_id"], hostelName: json["hostel_name"]);
}

class LoginSession {
  String token;
  String username;
  String? email;
  String? primaryId;
  List<HostelInfo>? hostels;
  String? identityId;
  DateTime? expiry;
  String? phone;
  String? fcmToken;
  TimelineActor role;
  String? imageURL;
  String? roomNo;

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
    this.hostels,
    this.imageURL,
    this.roomNo,
  });

  // ✅ Proper JSON serialization
  Map<String, dynamic> toJson() => {
    "token": token,
    "username": username,
    "email": email,
    "identityId": identityId,
    "expiry": expiry?.toIso8601String(),
    "phone": phone,
    "fcm_token": fcmToken,
    "role": TimelineActorX.toShortString(role),
    "hostels": hostels?.map((h) => h.toJson()).toList(),
    "imageURL": imageURL,
    "primaryId": primaryId,
    "room_no": roomNo,
  };

  // ✅ Proper JSON deserialization
  factory LoginSession.fromJson(Map<String, dynamic> json) => LoginSession(
    token: json["token"] ?? '',
    username: json["username"] ?? '',
    email: json["email"],
    identityId: json["identityId"],
    expiry: json["expiry"] != null ? DateTime.tryParse(json["expiry"]) : null,
    phone: json["phone"],
    fcmToken: json["fcm_token"],
    role: TimelineActorX.fromString(json["role"]),
    hostels:
        (json["hostels"] as List?)
            ?.map((e) => HostelInfo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    imageURL: json["imageURL"],
    primaryId: json["primaryId"],
    roomNo: json["room_no"],
  );

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("login_session", jsonEncode(toJson()));
  }

  Future<LoginSession?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("login_session");
    if (data == null) return null;
    try {
      return LoginSession.fromJson(jsonDecode(data));
    } catch (_) {
      return null;
    }
  }

  Future<void> clearPrefs() async {
    token = "";
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("login_session");
  }

  bool get isValid {
    if (expiry == null) return true;
    return DateTime.now().isBefore(expiry!);
  }

  Future<Either<String, String>> getValidToken() async {
    try {
      final session = await loadFromPrefs();

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
    LoginSession copyWith({
    String? token,
    String? username,
    String? email,
    String? primaryId,
    List<HostelInfo>? hostels,
    String? identityId,
    DateTime? expiry,
    String? phone,
    String? fcmToken,
    TimelineActor? role,
    String? imageURL,
    String? roomNo,
  }) {
    return LoginSession(
      token: token ?? this.token,
      username: username ?? this.username,
      email: email ?? this.email,
      primaryId: primaryId ?? this.primaryId,
      hostels: hostels ?? this.hostels,
      identityId: identityId ?? this.identityId,
      expiry: expiry ?? this.expiry,
      phone: phone ?? this.phone,
      fcmToken: fcmToken ?? this.fcmToken,
      role: role ?? this.role,
      imageURL: imageURL ?? this.imageURL,
      roomNo: roomNo ?? this.roomNo,
    );
  }

}
