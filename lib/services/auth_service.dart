import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/services/parent_service.dart';
import 'package:hostel_mgmt/services/warden_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';

class AuthService {
  static const String apiUrl = "https://hostel.vanscafe.shop/api/student/login";

  static Future<Either<String, LoginSession>> loginStudent({
    required String enrollmentNo,
    required String password,
  }) async {
    print("Attempting student login for $enrollmentNo");
    try {
      final payload = {"enrollment_no": enrollmentNo, "password": password};

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      print("📡 Status: ${response.statusCode}");

      if (response.statusCode != 200) {
        return left("Error: ${response.body}");
      }

      final data = jsonDecode(response.body);

      if ((data['token'] ?? '').toString().isEmpty) {
        return left(data['message']?.toString() ?? "Login failed");
      }

      final session = LoginSession(
        token: data['token'],
        username: data['name'],
        email: data['email'],
        identityId: data['enrollment_no'],
        role: TimelineActor.student,
        imageURL: data['imageURL'],
      );

      await session.saveToPrefs();
      return right(session);
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static const String apiBaseWarden = "https://hostel.vanscafe.shop/api/warden";

  static Future<Either<String, LoginSession>> loginWarden({
    required String empId,
    required String password,
    required TimelineActor actor,
  }) async {
    try {
      final payload = {
        "emp_id": empId,
        "wardenType": actor == TimelineActor.assistentWarden
            ? "warden"
            : "senior_warden",
        "password": password,
      };

      final response = await http.post(
        Uri.parse("$apiBaseWarden/login/warden"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        return left("Error: ${response.body}");
      }

      final data = jsonDecode(response.body);

      if ((data['token'] ?? '').toString().isEmpty) {
        return left(data['message']?.toString() ?? "Login failed");
      }

      final diSession = Get.find<LoginSession>();
      diSession.token = data['token'];
      diSession.role = actor;
      diSession.identityId = empId;
      diSession.username = '';
      diSession.email = '';
      diSession.imageURL = null;
      diSession.hostels = data['hostel_id'];

      // Fetch profile to enrich session
      final profileResult = await WardenService.getWardenProfile(
        token: diSession.token,
      );
      profileResult.fold(
        (error) {
          print('$error');
        },
        (warden) {
          diSession.imageURL = warden.profilePicUrl;
          diSession.identityId = warden.empId;
          diSession.username = warden.name;
          diSession.email = warden.email;
          diSession.hostelIds = warden.hostels;
        },
      );

      await diSession.saveToPrefs();
      return right(diSession);
    } catch (e) {
      return left("Exception: $e");
    }
  }

  static Future<Either<String, LoginSession>> loginParent({
    required String phoneNo,
    required String enrollmentNo,
  }) async {
    try {
      final payload = {
        "phone_no": phoneNo,
        "student_enrollment_no": enrollmentNo,
      };

      final response = await http.post(
        Uri.parse("https://hostel.vanscafe.shop/api/parent/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        return left("Error: ${response.body}");
      }

      final data = jsonDecode(response.body);

      if ((data['token'] ?? '').toString().isEmpty) {
        return left(data['message']?.toString() ?? "Login failed");
      }

      final diSession = Get.find<LoginSession>();
      diSession.token = data['token'];
      diSession.role = TimelineActor.parent;

      // Fetch and enrich parent profile
      final profileResult = await ParentService.getParentProfile(
        token: diSession.token,
      );

      return await profileResult.fold(
        (profileError) async => left(profileError),
        (parent) async {
          diSession.identityId = parent.phoneNo;
          diSession.username = parent.name;
          diSession.email = parent.email ?? '';
          diSession.phone = parent.phoneNo;
          diSession.primaryId = parent.parentId;
          diSession.imageURL = null;

          await diSession.saveToPrefs();
          return right(diSession);
        },
      );
    } catch (e) {
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
      final payload = {'oldPassword': oldPassword, 'newPassword': newPassword};

      final response = await http.put(
        Uri.parse("https://hostel.vanscafe.shop/api/admin/reset-password"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      print("📡 Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }
}
