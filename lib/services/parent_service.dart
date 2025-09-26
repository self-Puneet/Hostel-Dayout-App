// import 'dart:async';
// import 'dart:convert';
// import 'package:dartz/dartz.dart';
// import 'package:get/get.dart';
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
// // import 'package:hostel_mgmt/core/util/crypto_utils.dart';
// import 'package:hostel_mgmt/models/parent_model.dart';
// import 'package:hostel_mgmt/models/request_model.dart';
// import 'package:http/http.dart' as http;

// class ParentService {
//   static String url = "http://172.16.40.17:4141/api";

//   // static Future<Either<String, ParentModel>> getParentProfile({
//   //   required String token,
//   // }) async {
//   //   try {
//   //     final response = await http.get(
//   //       Uri.parse("http://172.16.40.17:4141/api/parent/profile"),
//   //       headers: {
//   //         "Authorization": "Bearer $token",
//   //         "Content-Type": "application/json",
//   //       },
//   //     );
//   //     print(
//   //       "📡 parentProfile - Status: ${response.statusCode} - ${response.body}",
//   //     );

//   //     final decrypted = response.body.isNotEmpty
//   //         ? jsonDecode(response.body) as Map<String, dynamic>
//   //         : null;
//   //     if (decrypted == null || decrypted["error"] != null) {
//   //       return left(
//   //         decrypted != null
//   //             ? decrypted["error"].toString()
//   //             : "Unknown error while fetching profile",
//   //       );
//   //     }
//   //     // if (decrypted['profile'] == null) {
//   //     //   return left("Profile data missing in response");
//   //     // }
//   //     final parent = ParentModel.fromJson(decrypted);
//   //     return right(parent);
//   //   } catch (e) {
//   //     return left("Exception: $e");
//   //   }
//   // }
//   static Future<Either<String, ParentModel>> getParentProfile({
//     required String token,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://172.16.40.17:4141/api/parent/profile"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );
//       final decrypted = response.body.isNotEmpty
//           ? jsonDecode(response.body) as Map<String, dynamic>
//           : null;

//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null
//               ? decrypted["error"].toString()
//               : "Unknown error while fetching profile",
//         );
//       }

//       // Use the nested profile payload if present
//       final profileJson = decrypted["profile"] ?? decrypted;
//       final parent = ParentModel.fromJson(profileJson as Map<String, dynamic>);
//       return right(parent);
//     } catch (e) {
//       return left("Exception: $e");
//     }
//   }

//   // static Future<Either<String, RequestApiResponse>>
//   // getAllRequestsForParent() async {
//   //   final session = Get.find<LoginSession>();
//   //   final token = session.token;
//   //   try {
//   //     final resp = await http.get(
//   //       Uri.parse("$url/parent/allRequests"),
//   //       headers: {
//   //         "Content-Type": "application/json",
//   //         "Authorization": "Bearer $token",
//   //       },
//   //     );
//   //     // final decrypted = CryptoUtil.handleEncryptedResponse(
//   //     //   response: resp,
//   //     //   context: "getAllRequestsForParent",
//   //     // );
//   //     final decodedBody = jsonDecode(resp.body) as Map<String, dynamic>;
//   //     print(decodedBody);
//   //     if (decodedBody.containsKey('error') && decodedBody['error'] != null) {
//   //       return left(decodedBody['error'].toString());
//   //     }
//   //     try {
//   //       final api = RequestApiResponse.fromJson(decodedBody);
//   //       return right(api);
//   //     } catch (e) {
//   //       return left("Failed to parse parent requests: $e");
//   //     }
//   //   } catch (e) {
//   //     return left("Exception: $e");
//   //   }
//   // }

//   static const String _base = 'http://172.16.40.17:6969';

//   static Future<Either<String, RequestApiResponse>> getAllRequests() async {
//     try {
//       // 1) Resolve parent_id (replace stub in ParentService with real source)
//       // final parentId = await ParentService.getCurrentParentId();
//       final session = Get.find<LoginSession>();
//       final parentId = session.primaryId;

//       print(parentId);
//       // 2) Build URL with query params
//       final uri = Uri.parse(
//         '$_base/get-parent-requests',
//       ).replace(queryParameters: {'parent_id': parentId});

//       // 3) GET + basic timeout
//       final resp = await http
//           .get(uri, headers: {'Accept': 'application/json'})
//           .timeout(const Duration(seconds: 8));

//       if (resp.statusCode != 200) {
//         return left('HTTP ${resp.statusCode}: ${resp.body}');
//       }

//       // 4) Decode and normalize top-level keys to fit RequestApiResponse
//       final dynamic decoded = jsonDecode(resp.body);
//       if (decoded is! Map<String, dynamic>) {
//         return left('Invalid response shape');
//       }
//       final map = Map<String, dynamic>.from(decoded);

//       // Backend currently returns "messages", model expects "message"
//       if (map['message'] == null && map['messages'] != null) {
//         map['message'] = map['messages'];
//       }
//       if (map['requests'] is! List) {
//         map['requests'] = <dynamic>[];
//       }

//       final parsed = RequestApiResponse.fromJson(map);
//       return right(parsed);
//     } on TimeoutException {
//       return left('Request timed out');
//     } catch (e) {
//       return left(e.toString());
//     }
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:http/http.dart' as http;

class ParentService {
  static const String url = "http://172.16.40.17:4141/api";

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

  static const String _base = 'http://172.16.40.17:6969';

  /// Fetch all parent requests from custom service
  static Future<Either<String, RequestApiResponse>> getAllRequests() async {
    try {
      final session = Get.find<LoginSession>();
      final parentId = session.primaryId;

      if (parentId == null || parentId.isEmpty) {
        return left("Parent ID missing in session");
      }

      print("📡 Fetching parent requests for ID: $parentId");

      final uri = Uri.parse('$_base/get-parent-requests')
          .replace(queryParameters: {'parent_id': parentId});

      final resp = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 8));

      if (resp.statusCode != 200) {
        return left('HTTP ${resp.statusCode}: ${resp.body}');
      }

      final dynamic decoded = jsonDecode(resp.body);
      if (decoded is! Map<String, dynamic>) {
        return left('Invalid response shape');
      }

      final map = Map<String, dynamic>.from(decoded);

      // Normalize: backend returns `messages`, model expects `message`
      if (map['message'] == null && map['messages'] != null) {
        map['message'] = map['messages'];
      }

      if (map['requests'] is! List) {
        map['requests'] = <dynamic>[];
      }

      final parsed = RequestApiResponse.fromJson(map);
      return right(parsed);
    } on TimeoutException {
      return left('Request timed out');
    } catch (e) {
      return left("Exception: $e");
    }
  }
}
