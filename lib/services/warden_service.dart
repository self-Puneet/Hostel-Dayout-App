// import 'package:dartz/dartz.dart';
// import 'package:get/get.dart';
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
// import 'package:hostel_mgmt/core/util/crypto_utils.dart';
// import 'package:hostel_mgmt/models/warden_model.dart';
// import 'package:hostel_mgmt/models/request_model.dart';
// import 'package:http/http.dart' as http;

// class WardenService {
//   static const url = "http://172.16.40.17:4141/api";

//   static Future<Either<String, RequestApiResponse>>
//   getAllRequestsForWarden() async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;

//     try {
//       final response = await http.get(
//         Uri.parse("$url/warden/allRequest"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "getAllRequestsForWarden",
//       );
//       print("Decrypted Response: $decrypted");
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         final apiResponse = RequestApiResponse.fromJson(decrypted);
//         return right(apiResponse);
//       } catch (e) {
//         return left("Failed to parse requests: $e");
//       }
//     } catch (e) {
//       return left("Exception: $e");
//     }
//   }

//   static Future<Either<String, WardenModel>> getWardenProfile({
//     required String token,
//   }) async {
//     try {
//       final response_profile = await http.get(
//         Uri.parse("$url/warden/profile"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );
//       final decrypted_profile = CryptoUtil.handleEncryptedResponse(
//         response: response_profile,
//         context: "wardenProfile",
//       );
//       if (decrypted_profile == null || decrypted_profile["error"] != null) {
//         return left(
//           decrypted_profile != null
//               ? decrypted_profile["error"].toString()
//               : "Unknown error",
//         );
//       }
//       print("dsfsdfsdfsfsdf");
//       print(decrypted_profile);
//       final warden = WardenModel.fromJson(decrypted_profile['profile']);
//       return right(warden);
//     } catch (e) {
//       return left("Exception: $e");
//     }
//   }
// }


import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/warden_model.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:http/http.dart' as http;

class WardenService {
  static const url = "http://172.16.40.17:4141/api";

  static Future<Either<String, RequestApiResponse>> getAllRequestsForWarden() async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final response = await http.get(
        Uri.parse("$url/warden/allRequest"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📡 getAllRequestsForWarden - Response: $data");
        try {
          final apiResponse = RequestApiResponse.fromJson(data);
          return right(apiResponse);
        } catch (e) {
          return left("Failed to parse requests: $e");
        }
      } else {
        return left("Error: ${response.body}");
      }
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
}
