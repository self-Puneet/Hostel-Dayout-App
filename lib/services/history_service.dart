// lib/services/student_history_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';

class StudentHistoryService {
  static const String _baseUrl = baseUrl;

  // GET /api/student/inactive-requests
  static Future<Either<String, RequestApiResponse>>
  getInactiveRequests() async {
    final session = Get.find<LoginSession>();
    final token = session.token;
    try {
      final resp = await http
          .get(
            Uri.parse('$_baseUrl/request/inactive-requests'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 8));

      if (resp.statusCode != 200) {
        return left('Error: ${resp.statusCode} - ${resp.body}');
      }

      final Map<String, dynamic>? decoded = resp.body.isNotEmpty
          ? jsonDecode(resp.body) as Map<String, dynamic>
          : null;

      if (decoded == null) {
        return left('Empty response');
      }
      print(decoded);
      print("-" * 90);

      // Normalize message/messages
      if (decoded['message'] == null && decoded['messages'] != null) {
        decoded['message'] = decoded['messages'];
      }

      // Normalize requests list shape
      if (decoded['requests'] is! List) {
        decoded['requests'] = <dynamic>[];
      }

      final parsed = RequestApiResponse.fromJson(decoded);
      return right(parsed);
    } on TimeoutException {
      return left('Request timed out');
    } catch (e) {
      return left('Exception: $e');
    }
  }
}
