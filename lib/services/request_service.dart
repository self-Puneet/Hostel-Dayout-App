import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class RequestService {
  static const url = "http://20.192.25.27:4141/api";

  static Future<Either<String, RequestApiResponse>> getAllRequests() async {
    final token = await LoginSession.getValidToken();

    token.fold((ifLeft) => null, (ifRight) {
      if (ifRight.isEmpty) {
        return left('Invalid or missing session. Please login again.');
      }
    });
    try {
      print(token);
      final response = await http.get(
        Uri.parse("$url/student/requests"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer ${"fQS5LZW7LiTEZmhx6vzqiyr7OooQ3fRKcUKuyvzOVp6Xk1pj2qT2uGWYj8qdnhXyc/FE7y9agzIaZKBb5M5jzwK7s5skrDKIKwh4b74ZCORWVJZosE228q/ANFKIqzLSU2Oqq0wv8C26vMGoT35Q775Uc6sIaaytCFOI1dvon9CQArUki8KmljzsYOKPxg1gW9lD0hkprPwyiOVGn2vGzhCgyd4KF6tC4TBzcJ9/c0DaQSv1sfdZNUC9Lti/zErn+EU7WscojPC7lqKYRJ3uKO6XiyyFLUFJUsx4f2Nu+8PvjxQ/YsaiywpRFeqCGrYM"}",
        },
      );
      print("📡 Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "getAllRequests",
      );
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        final apiResponse = RequestApiResponse.fromJson(decrypted);
        return right(apiResponse);
      } catch (e) {
        return left("Failed to parse requests: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static Future<Either<String, RequestModel>> getRequestById({
    required String requestId,
  }) async {
    final token = await LoginSession.getValidToken();

    token.fold((ifLeft) => null, (ifRight) {
      if (ifRight.isEmpty) {
        return left('Invalid or missing session. Please login again.');
      }
    });
    try {
      final response = await http.get(
        Uri.parse("$url/student/requests/$requestId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("📡 Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "getRequestById",
      );
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        final request = RequestModel.fromJson(decrypted["request"] ?? {});
        return right(request);
      } catch (e) {
        return left("Failed to parse request: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static Future<Either<String, RequestModel>> createRequest({
    required Map<String, dynamic> requestData,
  }) async {
    final token = await LoginSession.getValidToken();

    token.fold((ifLeft) => null, (ifRight) {
      if (ifRight.isEmpty) {
        return left('Invalid or missing session. Please login again.');
      }
    });

    try {
      final encryptedBody = CryptoUtil.encryptPayload(requestData);
      final response = await http.post(
        Uri.parse("$url/student/create-request"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"encrypted": encryptedBody}),
      );
      print("📡 Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "createRequest",
      );
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        final request = RequestModel.fromJson(decrypted["request"] ?? {});
        return right(request);
      } catch (e) {
        return left("Failed to parse created request: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }
}
