import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/config/constants.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/models/warden_statistics.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import 'package:hostel_mgmt/models/warden_model.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:http/http.dart' as http;

class WardenService {
  static const url = baseUrl;

  // request_service.dart (or wherever WardenService lives)
  static Future<Either<String, List<(RequestModel, StudentProfileModel)>>>
  getAllRequestsForWarden(String hostelId) async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final response = await http.get(
        Uri.parse("$url/warden/allRequest/$hostelId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        return left("Error: ${response.body}");
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);
      final list = (data['requests'] as List?) ?? const [];

      final results = <(RequestModel, StudentProfileModel)>[];

      for (final raw in list) {
        final item = raw as Map<String, dynamic>;
        final req = RequestModel.fromJson(item);
        print(req.reason);
        // Try multiple keys for student info; fallback to top-level if present.
        final studentJson = item['student_info'] as Map<String, dynamic>;
        print(studentJson);
        print("()" * 90);
        final student = StudentProfileModel.fromJson(studentJson);
        print("aaah");
        results.add((req, student));
      }

      print(results.length);

      return right(results);
    } catch (e) {
      return left("Exception: $e");
    }
  }

  static Future<Either<String, List<(RequestModel, StudentProfileModel)>>>
  getAllActiveRequestsForWarden(String hostelId) async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final response = await http.get(
        Uri.parse("$url/warden/allActiveRequests/$hostelId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        return left("Error: ${response.body}");
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final hehe = [];
      data["requests"].map((e) {
        hehe.add(e['request_id']);
      }).toString();
      print("duplicate${hehe.length}");
      print("duplicate-nahi${hehe.toSet().length}");

      final list = (data['requests'] as List?) ?? const [];
      print(list.length);
      final results = <(RequestModel, StudentProfileModel)>[];

      for (final raw in list) {
        final item = raw as Map<String, dynamic>;
        final req = RequestModel.fromJson(item);

        // Student info — assuming same structure as /allRequest
        final studentJson = item['student_Info'] as Map<String, dynamic>;
        final student = StudentProfileModel.fromJson(studentJson);

        final parentJson = item['parent_Info'] as List<dynamic>? ?? [];
        final parentList = parentJson
            .map((p) => ParentModel.fromJson(p as Map<String, dynamic>))
            .toList();

        final updatedStudent = student.copyWith(parents: parentList);
        results.add((req, updatedStudent));
      }
      for (int i = 0; i < results.length; i++) {
        // print("8" * 89);
        // print(results[i].$1.status);
      }

      print("Fetched active requests: ${results.length}");
      return right(results);
    } catch (e) {
      return left("Exception: $e");
    }
  }

  static Future<Either<String, WardenModel>> getWardenProfile({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$url/warden/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📡 getWardenProfile - Response: $data");
        final warden = WardenModel.fromJson(data['profile']);
        return right(warden);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      return left("Exception: $e");
    }
  }

  static Future<Either<String, WardenStatistics>> fetchStatistics({
    required String hostelCode,
    required String token,
    http.Client? client,
  }) async {
    final c = client ?? http.Client();
    try {
      final res = await c.get(
        Uri.parse('$baseUrl/warden/statistics/$hostelCode'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(res.body) as Map<String, dynamic>;
        print(data);
        final stats = WardenStatistics.fromJson(data);
        return right(stats);
      } else {
        return left('Error ${res.statusCode}: ${res.body}');
      }
    } catch (e) {
      return left('Exception: $e');
    } finally {
      if (client == null) c.close();
    }
  }

  static Future<Either<String, List<RequestModel>>>
  getRequestsForMonth({
    required String hostelId,
    required String yearMonth, // "yyyy-MM"
  }) async {
    final session = Get.find<LoginSession>();
    final token = session.token;
    print(yearMonth);

    try {
      final base = url; // assumes same global base as other services
      final path = "$base/warden/requests/$hostelId/2025-09";
      final response = await http.get(
        Uri.parse(path),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      print("pppppppppppppppppppppppppp");

      print(jsonDecode(response.body));
      if (response.statusCode != 200) {
        return left("Error: ${response.body}");
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (data['requests'] as List?) ?? const [];
      final List<RequestModel> results;
      results = [];
      for (final raw in list) {
        final item = raw as Map<String, dynamic>;
        final req = RequestModel.fromJson(item);
        print("hehe");
        // fix it

        print(data['requests'][0]["created_by"]);

        // final studentJson = item['student_Info'] as Map<String, dynamic>;
        // final student = StudentProfileModel.fromJson(studentJson);
        // print("hehe");
        // final parentJson = item['parent_Info'] as List<dynamic>? ?? [];
        // final parentList = parentJson
        //     .map((p) => ParentModel.fromJson(p as Map<String, dynamic>))
        //     .toList();
        // print("hehe");
        // final updatedStudent = student.copyWith(parents: parentList);
        results.add(req);
      }

      return right(results);
    } catch (e) {
      return left("Exception: $e");
    }
  }
}
