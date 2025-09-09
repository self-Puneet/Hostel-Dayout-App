import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:hostel_mgmt/services/parent_service.dart';
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
    print("Attempting student login for $enrollmentNo");
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
            ? "warden"
            : "senior_warden",
        "password": password,
      };
      final encrypted = CryptoUtil.encryptPayload(payload);
      final response = await http.post(
        Uri.parse("$apiBaseWarden/login/warden"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"encrypted": encrypted}),
      );
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "loginWarden",
      );
      if (decrypted == null) return left("Unknown error");
      if (decrypted["error"] != null)
        return left(decrypted["error"]['error'].toString());
      if ((decrypted['token'] ?? '').toString().isEmpty) {
        return left(decrypted['message']?.toString() ?? "Login failed");
      }

      final diSession = Get.find<LoginSession>();

      // Synchronously set critical fields BEFORE awaiting anything
      diSession.token = decrypted['token'];
      diSession.role = actor; // ensure role is correct immediately
      diSession.identityId = empId; // provisional until profile fills
      diSession.username = ''; // optional provisional
      diSession.email = ''; // optional provisional
      diSession.imageURL = null;

      // Await the profile fetch so we return a fully populated session
      final profileResult = await WardenService.getWardenProfile(
        token: diSession.token,
      );
      profileResult.fold(
        (error) {
          // Keep provisional fields; optionally log
        },
        (warden) {
          diSession.imageURL = warden.profilePicUrl;
          diSession.identityId = warden.empId;
          diSession.username = warden.name;
          diSession.email = warden.email;
        },
      );

      await diSession.saveToPrefs();
      return right(diSession);
    } catch (e) {
      return left("Exception: $e");
    }
  }

  // static Future<Either<String, LoginSession>> loginParent({
  //   required String phoneNo,
  //   required String enrollmentNo,
  // }) async {
  //   try {
  //     final payload = {
  //       "phone_no": phoneNo,
  //       "student_enrollment_no": enrollmentNo,
  //     };
  //     print(payload);
  //     print("pleaseeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
  //     final encrypted = CryptoUtil.encryptPayload(payload);
  //     final response = await http.post(
  //       Uri.parse("http://20.192.25.27:4141/api/parent/login"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"encrypted": encrypted}),
  //     );
  //     print(
  //       "📡 Parent Login Status: ${response.statusCode} - ${response.body}",
  //     );
  //     // final decrypted = CryptoUtil.handleEncryptedResponse(
  //     //   response: response,
  //     //   context: "loginParent",
  //     // );
  //     final decrypted = response.body.isNotEmpty
  //         ? jsonDecode(response.body) as Map<String, dynamic>
  //         : null;
  //     print(decrypted);
  //     if (decrypted == null) {
  //       return left("Unknown error during login");
  //     }
  //     if (decrypted["error"] != null) {
  //       return left(decrypted["error"].toString());
  //     }
  //     if ((decrypted['token'] ?? '').toString().isEmpty) {
  //       return left(decrypted['message']?.toString() ?? "Login failed");
  //     }
  //     final diSession = Get.find<LoginSession>();
  //     final token = decrypted['token'];
  //     // diSession.token = token;
  //     // Fetch parent profile
  //     final profileResult = await ParentService.getParentProfile(token: token);
  //     return profileResult.fold((profileError) => left(profileError), (parent) {
  //       diSession.token = token;
  //       diSession.role = TimelineActor.parent;
  //       diSession.identityId = parent.phoneNo;
  //       diSession.username = parent.name;
  //       diSession.email = parent.email ?? '';
  //       diSession.phone = parent.phoneNo;
  //       diSession.primaryId = parent.parentId;
  //       diSession.imageURL = null; // if your backend has no profilePic
  //       return right(diSession);
  //     });
  //   } catch (e) {
  //     return left("Exception: $e");
  //   }
  // }

  static Future<Either<String, LoginSession>> loginParent({
    required String phoneNo,
    required String enrollmentNo,
  }) async {
    try {
      final payload = {
        "phone_no": phoneNo,
        "student_enrollment_no": enrollmentNo,
      };
      final encrypted = CryptoUtil.encryptPayload(payload);
      final response = await http.post(
        Uri.parse("http://20.192.25.27:4141/api/parent/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"encrypted": encrypted}),
      );
      final decrypted = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : null;
      if (decrypted == null) {
        return left("Unknown error during login");
      }
      if (decrypted["error"] != null) {
        return left(decrypted["error"].toString());
      }
      if ((decrypted['token'] ?? '').toString().isEmpty) {
        return left(decrypted['message']?.toString() ?? "Login failed");
      }

      final diSession = Get.find<LoginSession>();
      final token = decrypted['token'];

      // 1) Set critical fields synchronously so DI contains valid session immediately
      diSession.token = token;
      diSession.role = TimelineActor.parent;

      // 2) Fetch and apply profile (await so data is ready before persisting)
      final profileResult = await ParentService.getParentProfile(token: token);
      final parentOrError = await profileResult
          .fold<Future<Either<String, LoginSession>>>(
            (profileError) async => left(profileError),
            (parent) async {
              diSession.identityId = parent.phoneNo;
              diSession.username = parent.name;
              diSession.email = parent.email ?? '';
              diSession.phone = parent.phoneNo;
              diSession.primaryId =
                  parent.parentId; // used later by getAllRequests()
              diSession.imageURL = null;
              // 3) Persist to prefs BEFORE returning
              await diSession.saveToPrefs();
              return right(diSession);
            },
          );
      return parentOrError;
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
