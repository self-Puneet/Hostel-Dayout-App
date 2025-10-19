import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
// import 'package:hostel_mgmt/models/hostels_model.dart';
import 'package:hostel_mgmt/models/warden_model.dart';
import 'package:hostel_mgmt/services/parent_service.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import 'package:hostel_mgmt/services/warden_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';

class AuthService {
  static const String apiUrl =
      "https://hostel-leave-3.onrender.com/api/student/login";

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
        return left("${jsonDecode(response.body)["error"]}");
      }

      final data = jsonDecode(response.body);

      if ((data['token'] ?? '').toString().isEmpty) {
        return left(data['message']?.toString() ?? "Login failed");
      }
      final profile = await ProfileService.getStudentProfile();
      profile.fold(
        (error) {
          return error;
        },
        (profileResponse) {
          profileResponse.student.hostelName;
          final session = LoginSession(
            token: data['token'],
            username: profileResponse.student.name,
            email: profileResponse.student.email,
            identityId: profileResponse.student.enrollmentNo,
            hostels: [
              HostelInfo(
                hostelId: profileResponse.student.hostelName,
                hostelName: profileResponse.student.hostelName,
              ),
            ],
            role: TimelineActor.student,
            imageURL: data['imageURL'],
          );

          session.saveToPrefs();
          return right(session);
        },
      );
      final session = LoginSession(
        token: data['token'],
        username: data['name'],
        email: data['email'],
        identityId: data['enrollment_no'],
        // hostels: data['hostel'],
        role: TimelineActor.student,
        imageURL: data['imageURL'],
      );
      session.saveToPrefs();
      return right(session);
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static const String apiBaseWarden =
      "https://hostel-leave-3.onrender.com/api/warden";

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
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        return left("${jsonDecode(response.body)["error"]}");
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
      // diSession.hostels = data['hostel_id'];

      // Fetch profile to enrich session
      final profileResult = await WardenService.getWardenProfile(
        token: diSession.token,
      );

      if (profileResult.isLeft()) {
        final error = profileResult.fold((l) => l, (r) => null);
        print(error);
      } else {
        WardenModel warden = profileResult.getOrElse(
          () => throw Exception('Missing warden'),
        );

        warden = warden.copyWith(hostels: []);

        // Fetch all hostels
        final hostelResult = await ProfileService.getAllHostelInfo();

        if (hostelResult.isRight()) {
          final hostelList = hostelResult.getOrElse(() => []);
          for (final hid in List.of(warden.hostelId)) {
            // <-- copy
            for (final h in hostelList) {
              if (h.hostelId == hid) {
                warden.hostels!.add(h.hostelName);
              }
            }
          }
        } else {
          print(hostelResult.fold((l) => l, (r) => null));
        }

        List<HostelInfo> finalHostels = [];
        for (int i = 0; i < warden.hostelId.length; i++) {
          finalHostels.add(
            HostelInfo.fromJson({
              "hostel_id": warden.hostelId[i],
              "hostel_name": warden.hostels![i],
            }),
          );
        }

        // Update diSession with enriched profile
        diSession.imageURL = warden.profilePicUrl;
        diSession.identityId = warden.empId;
        diSession.username = warden.name;
        diSession.email = warden.email;
        diSession.hostels = finalHostels;
        warden.hostels;
      }

      await diSession.saveToPrefs();
      print(diSession.hostels);
      return right(diSession);
    } catch (e) {
      print(e);
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
        Uri.parse("https://hostel-leave-3.onrender.com/api/parent/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        return left("${jsonDecode(response.body)["error"]}");
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
    await Get.find<LoginSession>().clearPrefs();
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
        Uri.parse(
          "https://hostel-leave-3.onrender.com/api/admin/reset-password",
        ),
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
        return left("${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }
}
