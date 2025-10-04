import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/config/constants.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
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
      final list = (data['requests'] as List?) ?? const [];

      final results = <(RequestModel, StudentProfileModel)>[];

      for (final raw in list) {
        final item = (raw as Map).cast<String, dynamic>();
        final req = RequestModel.fromJson(item);

        // Try multiple keys for student info; fallback to top-level if present.
        final dynamic studentAny =
            item['student'] ??
            item['student_profile'] ??
            data['student'] ??
            (item['studentInfo'] is Map
                ? (item['studentInfo'] as Map)['student']
                : null) ??
            const <String, dynamic>{};

        final studentJson = studentAny is Map<String, dynamic>
            ? studentAny
            : <String, dynamic>{};

        final student = StudentProfileModel.fromJson(studentJson);
        results.add((req, student));
      }

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

        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhhhhhhhhhh");
        return right(warden);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      return left("Exception: $e");
    }
  }
}
