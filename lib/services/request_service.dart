import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:get/get.dart';

// void printFullText(String text) {
//   final pattern = RegExp('.{1,800}'); // split into chunks of 800 chars
//   for (final match in pattern.allMatches(text)) {
//     print(match.group(0));
//   }
// }

// Future<void> writeToFile(String path, String text) async {
//   await File(path).writeAsString(text);
// }

class RequestService {
  static const url = "http://20.192.25.27:4141/api";

  static Future<Either<String, RequestApiResponse>> getAllRequests() async {
    final session = Get.find<LoginSession>();
    final token = session.token;
    try {
      print(token);
      final response = await http.get(
        Uri.parse("$url/student/requests"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
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

  static Future<Either<String, RequestDetailApiResponse>> getRequestById({
    required String requestId,
  }) async {
    final session = Get.find<LoginSession>();
    final token = session.token;
    print(requestId);
    print(token);
    // requestId = "68aef2e9fab1a5ff077eebed";
    try {
      final response = await http.get(
        Uri.parse("$url/student/requests/$requestId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("📡 Status of get request by id: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "getRequestById",
      );
      // print(decrypted!.keys);
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        // await writeToFile("content.txt", decrypted.toString());
        // final mapping = decrypted.keys.map((key) {
        //   print("$key -> ${decrypted[key]}");
        // }).toList();

        // print(mapping);

        final request = RequestDetailApiResponse.fromJson(decrypted);
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
    final session = Get.find<LoginSession>();
    final token = session.token;

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
      final request = RequestModel.fromJson(decrypted["request"] ?? {});
      return right(request);
      // try {
      // } catch (e) {
      //   return left("Failed to parse created request: $e");
      // }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }
}
