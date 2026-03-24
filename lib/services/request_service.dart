import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/config/constants.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class RequestService {
  static const url = baseUrl;

  static Future<Either<String, RequestApiResponse>> getAllRequests() async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final response = await http.get(
        Uri.parse("$url/student/requests"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("📡 Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // debugPrint(data['requests']);
        final apiResponse = RequestApiResponse.fromJson(data);
        return right(apiResponse);
      } else {
        return left("Error: ${response.body}");
      }
    } on SocketException {
      debugPrint("❌ No internet connection");
      return left("No internet connection. Please check your network.");
    } catch (e) {
      debugPrint("❌ Exception: $e");
      return left("Server issue. Please try again later.");
    }
  }

  static Future<Either<String, RequestDetailApiResponse>> getRequestById({
    required String requestId,
  }) async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final response = await http.get(
        Uri.parse("$url/request/request/$requestId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("📡 Status of get request by id: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("🔍 RequestService.getRequestById response data: $data");

        if (data == null) {
          debugPrint("❌ Response data is null");
          return left("Invalid response from server");
        }

        if (data['request'] == null) {
          debugPrint("❌ Request object is null in response");
          return left("Request data not found");
        }

        final request = RequestDetailApiResponse.fromJson(data);
        return right(request);
      } else {
        return left("Error: ${jsonDecode(response.body)["error"]}");
      }
    } on SocketException {
      debugPrint("❌ No internet connection");
      return left("No internet connection. Please check your network.");
    } catch (e, stackTrace) {
      debugPrint("❌ Exception in getRequestById: $e");
      debugPrint("📍 Stack trace: $stackTrace");
      return left("Server issue. Please try again later.");
    }
  }

  static Future<Either<String, RequestModel>> createRequest({
    required Map<String, dynamic> requestData,
  }) async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final response = await http.post(
        Uri.parse("$url/student/create-request"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestData),
      );

      debugPrint("📡 Request Creation Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final request = RequestModel.fromJson(data["request"] ?? {});
        return right(request);
      } else {
        return left("Error: ${response.body}");
      }
    } on SocketException {
      debugPrint("❌ No internet connection");
      return left("No internet connection. Please check your network.");
    } catch (e) {
      debugPrint("❌ Exception: $e");
      return left("Server issue. Please try again later.");
    }
  }

  static Future<Either<String, RequestStatus>> updateRequestStatus({
    required String requestId,
    required String status,
    required String remark,
  }) async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final Map<String, dynamic> requestData = {
        "requestId": requestId,
        "status": status,
        "remark": remark,
      };

      final response = await http.put(
        Uri.parse("$url/request/update-status"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestData),
      );

      debugPrint("📡 Update Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        return right(
          RequestStatusX.apiStringToStatus(
            jsonDecode(response.body)['request_status'],
          ),
        );
      } else {
        return left("Error: ${jsonDecode(response.body)['error']}");
      }
    } on SocketException {
      debugPrint("❌ No internet connection");
      return left("No internet connection. Please check your network.");
    } catch (e) {
      debugPrint("❌ Exception: $e");
      return left("Server issue. Please try again later.");
    }
  }

  static Future<List<RequestModel>> _fetchByKey(String key) async {
    final session = Get.find<LoginSession>();
    final token =
        session.token; // adapt to your session field (e.g., accessToken)
    final uri = Uri.parse('$url/request/requests/$key');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 200) {
      throw HttpException(
        'Request fetch failed (${response.statusCode}): $key',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint(body['requests'][0].keys.toList());
    // Adjust parsing if your API wraps data differently.
    final list = (body['requests'] as List<dynamic>? ?? [])
        .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return list;
  }

  static Future<List<RequestModel>> getRequestsByStatusKey(String key) {
    return _fetchByKey(key);
  }
}
