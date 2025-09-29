// import 'dart:convert';
// import 'package:dartz/dartz.dart';
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
// import 'package:hostel_mgmt/core/util/crypto_utils.dart';
// import 'package:hostel_mgmt/models/request_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'package:get/get.dart';

// class RequestService {
//   static const url1 = "http://20.192.25.27:4141/api";
//   static const url = "http://172.16.40.17:4141/api";

//   static Future<Either<String, RequestApiResponse>> getAllRequests() async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     try {
//       print(token);
//       final response = await http.get(
//         Uri.parse("$url/student/requests"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//       print("📡 Status: ${response.statusCode}");
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "getAllRequests",
//       );
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         print(decrypted['requests'].map((e) => e['request_status']).toList());
//         final apiResponse = RequestApiResponse.fromJson(decrypted);
//         return right(apiResponse);
//       } catch (e) {
//         return left("Failed to parse requests: $e");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }

//   static Future<Either<String, RequestDetailApiResponse>> getRequestById({
//     required String requestId,
//   }) async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     print(requestId);
//     print(token);
//     // requestId = "68aef2e9fab1a5ff077eebed";
//     try {
//       final response = await http.get(
//         Uri.parse("$url/student/requests/$requestId"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//       print("📡 Status of get request by id: ${response.statusCode}");
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "getRequestById",
//       );
//       // print(decrypted!.keys);
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         // await writeToFile("content.txt", decrypted.toString());
//         // final mapping = decrypted.keys.map((key) {
//         //   print("$key -> ${decrypted[key]}");
//         // }).toList();

//         // print(mapping);

//         final request = RequestDetailApiResponse.fromJson(decrypted);
//         return right(request);
//       } catch (e) {
//         return left("Failed to parse request: $e");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }

//   static Future<Either<String, RequestModel>> createRequest({
//     required Map<String, dynamic> requestData,
//   }) async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;

//     try {
//       final encryptedBody = CryptoUtil.encryptPayload(requestData);
//       final response = await http.post(
//         Uri.parse("$url/student/create-request"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"encrypted": encryptedBody}),
//       );
//       print("📡 Request Creation Status: ${response.statusCode}");
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "createRequest",
//       );
//       print(decrypted);
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       final request = RequestModel.fromJson(decrypted["request"] ?? {});
//       return right(request);
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }

//   static Future<Either<String, RequestModel>> updateRequestStatus({
//     required String requestId,
//     required String status,
//     required String remark,
//   }) async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;

//     try {
//       // Build and encrypt payload
//       final Map<String, dynamic> requestData = {
//         "requestId": requestId,
//         "status": status,
//         "remark": remark,
//       };
//       final encryptedBody = CryptoUtil.encryptPayload(requestData);

//       // Send PUT request
//       final response = await http.put(
//         Uri.parse("$url/request/update-status"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"encrypted": encryptedBody}),
//       );
//       print("📡 Update Status: ${response.statusCode}");

//       // Decrypt and basic error handling
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "updateRequestStatus",
//       );

//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }

//       // Parse updated request (support both {request: {...}} or top-level {...})
//       try {
//         final dynamic payload = decrypted["request"] ?? decrypted;
//         final updated = RequestModel.fromJson(payload as Map<String, dynamic>);
//         return right(updated);
//       } catch (e) {
//         return left("Failed to parse updated request: $e");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class RequestService {
  static const url = "http://172.16.40.17:4141/api";
  static const url1 = "http://20.192.25.27:4141/api";

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

      print("📡 Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final apiResponse = RequestApiResponse.fromJson(data);
        return right(apiResponse);
      } else {
        return left("Error: ${response.body}");
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

    try {
      final response = await http.get(
        Uri.parse("$url/request/request/$requestId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📡 Status of get request by id: ${response.statusCode}");
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data.keys);
        final request = RequestDetailApiResponse.fromJson(data);
        return right(request);
      } else {
        return left("Error: ${response.body}");
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
      final response = await http.post(
        Uri.parse("$url/student/create-request"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestData),
      );

      print("📡 Request Creation Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final request = RequestModel.fromJson(data["request"] ?? {});
        return right(request);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static Future<Either<String, RequestModel>> updateRequestStatus({
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

      print("📡 Update Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updated = RequestModel.fromJson(data["request"] ?? data);
        return right(updated);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  // Core fetch by single backend key
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
    print(body);
    // Adjust parsing if your API wraps data differently.
    final list = (body['requests'] as List<dynamic>? ?? [])
        .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return list;
  }

  // Public: fetch all requests for a given UI filter option ("All", "Approved", "Rejected", "Cancelled")
  // When multiple backend keys are needed, fetch them concurrently and merge.

  // static List<String> _filterToBackendKeys(String filter) {
  //   switch (filter.toLowerCase()) {
  //     case 'Approved':
  //       return ['accepted_by_warden'];
  //     case 'Rejected':
  //       return ['rejected_by_parent', 'rejected_by_warden'];
  //     case 'Cancelled':
  //       return ['cancelled_by_student', 'cancelled_assitent_warden'];
  //     case 'all':
  //     default:
  //       return ['All'];
  //   }
  // }
  // static Future<List<RequestModel>> getRequestsForFilter(String filter) async {
  //   final keys = _filterToBackendKeys(filter);
  //   if (keys.length == 1) {
  //     return _fetchByKey(keys.first);
  //   }

  //   // Fetch multiple groups in parallel and merge (Rejected/Cancelled cases).
  //   final results = await Future.wait(keys.map(_fetchByKey));
  //   return results.expand((x) => x).toList();
  // }

  static Future<List<RequestModel>> getRequestsByStatusKey(String key) {
    return _fetchByKey(key);
  }
}
