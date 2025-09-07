import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:hostel_mgmt/services/warden_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';

class AuthService {
  static const String apiUrl = "http://20.192.25.27:4141/api/student/login";

  static Future<Either<String, LoginSession>> loginStudent({
    required String enrollmentNo,
    required String password,
  }) async {
    try {
      print(enrollmentNo);
      print(password);
      final payload = {"enrollment_no": enrollmentNo, "password": password};
      final encrypted = CryptoUtil.encryptPayload(payload);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"encrypted": encrypted}),
      );

      print("📡 Status: ${response.statusCode}");

      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "loginStudent",
      );
      if (decrypted == null) {
        return left("Unknown error");
      }
      if (decrypted["error"] != null) {
        return left(decrypted["error"].toString());
      }
      // If token is missing, treat as error
      if ((decrypted['token'] ?? '').toString().isEmpty) {
        return left(decrypted['message']?.toString() ?? "Login failed");
      }
      // Build LoginSession from response
      final session = LoginSession(
        token: decrypted['token'],
        username: decrypted['name'],
        email: decrypted['email'],
        identityId: decrypted['enrollment_no'],
        role: TimelineActor.student,
        imageURL: decrypted['imageURL'],
      );
      await session.saveToPrefs();
      return right(session);
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static const String apiBaseWarden = "http://20.192.25.27:4141/api/warden";

  static Future<Either<String, LoginSession>> loginWarden({
    required String empId,
    required String password,
    required TimelineActor actor,
  }) async {
    try {
      final payload = {
        "emp_id": empId,
        "wardenType": actor == TimelineActor.assistentWarden
            ? "senior_warden"
            : "warden",
        "password": password,
      };
      final encrypted = CryptoUtil.encryptPayload(payload);
      final response = await http.post(
        Uri.parse("$apiBaseWarden/login/warden"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"encrypted": encrypted}),
      );
      print("📡 Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "loginWarden",
      );
      if (decrypted == null) {
        return left("Unknown error");
      }
      if (decrypted["error"] != null) {
        return left(decrypted["error"].toString());
      }
      if ((decrypted['token'] ?? '').toString().isEmpty) {
        return left(decrypted['message']?.toString() ?? "Login failed");
      }

      // using get get thelogin session instance of the dependency injection
      final diSession = Get.find<LoginSession>();
      WardenService.getWardenProfile(token: decrypted['token']).then((result) {
        result.fold(
          (error) => print("Failed to fetch warden profile: $error"),
          (warden) {
            print(warden);
            diSession.token = decrypted['token'];

            diSession.role = actor;
            // diSession.imageURL = warden.profilePicUrl;
            diSession.identityId = warden.empId;
            diSession.username = warden.name;
            diSession.email = warden.email;
          },
        );
      });
      await diSession.saveToPrefs();
      return right(diSession);
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static Future<void> logoutStudent() async {
    await LoginSession.clearPrefs();
    
  }

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

  static Future<Either<String, bool>> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    try {
      final encryptedPayload = CryptoUtil.encryptPayload({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      final response = await http.put(
        Uri.parse("http://20.192.25.27:4141/api/admin/reset-password"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"encrypted": encryptedPayload}),
      );
      print("📡 Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "resetPassword",
      );
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      // If success, return true
      return right(true);
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }
}
