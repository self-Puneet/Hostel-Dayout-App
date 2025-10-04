import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/config/constants.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:http/http.dart' as http;

class ParentService {
  static const String url = baseUrl;

  /// Fetch parent profile from `/parent/profile`
  static Future<Either<String, ParentModel>> getParentProfile({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$url/parent/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        return left("Error: ${response.statusCode} - ${response.body}");
      }

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : null;

      print(decoded);

      if (decoded == null || decoded["error"] != null) {
        return left(
          decoded != null
              ? decoded["error"].toString()
              : "Unknown error while fetching profile",
        );
      }

      // Some APIs return `{ profile: { ... } }`
      final profileJson = decoded["profile"] ?? decoded;
      final parent = ParentModel.fromJson(profileJson as Map<String, dynamic>);
      return right(parent);
    } catch (e) {
      return left("Exception: $e");
    }
  }

  /// Fetch all parent requests from backend
  static Future<Either<String, RequestApiResponse>> getAllRequests() async {
    final session = Get.find<LoginSession>();
    final token = session.token;
    try {
      final response = await http
          .get(
            Uri.parse("$url/parent/allRequests"),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return left("Error: ${response.statusCode} - ${response.body}");
      }
      print("heeeeeeee");
      print(response.body);
      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : null;
      // print(decoded);
      if (decoded == null || decoded["error"] != null) {
        return left(
          decoded != null
              ? decoded["error"].toString()
              : "Unknown error while fetching requests",
        );
      }

      // Normalize shape (backend sometimes sends `messages` instead of `message`)
      if (decoded["message"] == null && decoded["messages"] != null) {
        decoded["message"] = decoded["messages"];
      }

      if (decoded["requests"] is! List) {
        decoded["requests"] = <dynamic>[];
      }

      final parsed = RequestApiResponse.fromJson(decoded);
      return right(parsed);
    } on TimeoutException {
      return left("Request timed out");
    } catch (e) {
      return left("Exception: $e");
    }
  }
}
