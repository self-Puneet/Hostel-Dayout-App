// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
// import 'package:hostel_mgmt/models/branch_model.dart';
// import 'package:hostel_mgmt/models/student_profile.dart';
// import '../models/hostels_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:hostel_mgmt/core/util/crypto_utils.dart';
// import 'package:dartz/dartz.dart';

// class ProfileService {
//   // static String token =
//   //     "fQS5LZW7LiTEZmhx6vzqiyr7OooQ3fRKcUKuyvzOVp6Xk1pj2qT2uGWYj8qdnhXyc/FE7y9agzIaZKBb5M5jzwK7s5skrDKIKwh4b74ZCORWVJZosE228q/ANFKIqzLSU2Oqq0wv8C26vMGoT35Q775Uc6sIaaytCFOI1dvon9CQArUki8KmljzsYOKPxg1gW9lD0hkprPwyiOVGn2vGzhCgyd4KF6tC4TBzcJ9/c0DaQSv1sfdZNUC9Lti/zErn+EU7WscojPC7lqKYRJ3uKO6XiyyFLUFJUsx4f2Nu+8PvjxQ/YsaiywpRFeqCGrYM";
//   static const url = "http://20.192.25.27:4141/api";

//   static Future<Either<String, StudentApiResponse>> getStudentProfile() async {
//     // final token = await LoginSession.getValidToken();

//     // token.fold((ifLeft) => null, (ifRight) {
//     //   if (ifRight.isEmpty) {
//     //     return left('Invalid or missing session. Please login again.');
//     //   }
//     // });

//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     print(token);

//     try {
//       final response = await http.get(
//         Uri.parse("$url/student/student-profile"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//       print("📡 getStudentProfile - Status: ${response.statusCode}");
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "getStudentProfile",
//       );
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         final apiResponse = StudentApiResponse.fromJson(decrypted);
//         return right(apiResponse);
//       } catch (e) {
//         return left("Failed to parse student profile response: $e");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }

//

//   static Future<Either<String, HostelResponse>> getAllHostelInfo() async {
//     // final token = await LoginSession.getValidToken();

//     // token.fold((ifLeft) => null, (ifRight) {
//     //   if (ifRight.isEmpty) {
//     //     return left('Invalid or missing session. Please login again.');
//     //   }
//     // });
//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     try {
//       final response = await http.get(
//         Uri.parse("$url/student/all-hostel-info"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//       print("📡 getAllHostelInfo - Status: ${response.statusCode}");
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "getAllHostelInfo",
//       );
//       print(decrypted);
//       if (decrypted == null || decrypted["error"] != null) {
//         // Handle both string and map error formats
//         String errorMsg;
//         if (decrypted == null) {
//           errorMsg = "Unknown error";
//         } else if (decrypted["error"] is String) {
//           errorMsg = decrypted["error"];
//         } else if (decrypted["error"] is Map &&
//             decrypted["error"]["error"] != null) {
//           errorMsg = decrypted["error"]["error"].toString();
//         } else {
//           errorMsg = "Unknown error";
//         }
//         return left(errorMsg);
//       }
//       try {
//         final hostelResponse = HostelResponse.fromJson(decrypted);
//         return right(hostelResponse);
//       } catch (e) {
//         return left("Failed to parse hostel response: $e");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }

//   static Future<Either<String, BranchResponse>> getAllBranches() async {
//     // final token = await LoginSession.getValidToken();

//     // token.fold((ifLeft) => null, (ifRight) {
//     //   if (ifRight.isEmpty) {
//     //     return left('Invalid or missing session. Please login again.');
//     //   }
//     // });
//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     try {
//       final response = await http.get(
//         Uri.parse("$url/student/all-branches"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//       print("📡 getAllBranches - Status: ${response.statusCode}");
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "getAllBranches",
//       );
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         final branchResponse = BranchResponse.fromJson(decrypted);
//         return right(branchResponse);
//       } catch (e) {
//         return left("Failed to parse branch response: $e");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }

//   static Future<Either<String, StudentProfileModel>> updateProfile({
//     required Map<String, dynamic> profileData,
//     File? profilePic,
//   }) async {
//     // final token = await LoginSession.getValidToken();

//     // token.fold((ifLeft) => null, (ifRight) {
//     //   if (ifRight.isEmpty) {
//     //     return left('Invalid or missing session. Please login again.');
//     //   }
//     // });
//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     try {
//       final encryptedBody = CryptoUtil.encryptPayload(profileData);
//       final uri = Uri.parse("$url/student/profile");
//       final request = http.MultipartRequest("PUT", uri);
//       request.headers["Authorization"] = "Bearer $token";
//       request.fields["encrypted"] = encryptedBody;
//       if (profilePic != null) {
//         request.files.add(
//           await http.MultipartFile.fromPath("profile_pic", profilePic.path),
//         );
//       }
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//       print("📡 updateProfile - Status: ${response.statusCode}");
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "updateProfile",
//       );
//       print(decrypted);
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         final profile = StudentProfileModel.fromJson(decrypted["student"]);
//         print(profile.name);
//         return right(profile);
//       } catch (e) {
//         return left("Failed to parse updated profile: $e");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }
// }

// lib/services/profile_service.dart

// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:dartz/dartz.dart';
// import 'package:hostel_mgmt/models/hostels_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
// import 'package:hostel_mgmt/core/util/crypto_utils.dart';
// import 'package:hostel_mgmt/models/student_profile.dart';

// class ProfileService {
//   static const url = "http://20.192.25.27:4141/api";

//   static Future<Either<String, StudentApiResponse>> getStudentProfile() async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     try {
//       final response = await http.get(
//         Uri.parse("$url/student/student-profile"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "getStudentProfile",
//       );
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         final apiResponse = StudentApiResponse.fromJson(decrypted);
//         return right(apiResponse);
//       } catch (e) {
//         return left("Failed to parse student profile response: $e");
//       }
//     } catch (e) {
//       return left("Exception: $e");
//     }
//   }

//   // Focused method to update only the profile picture.
//   static Future<Either<String, StudentProfileModel>> updateProfilePic1({
//     required Map<String, dynamic> profileData,
//     required File profilePic,
//   }) async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     try {
//       final encryptedBody = CryptoUtil.encryptPayload(profileData);
//       final uri = Uri.parse("$url/student/profile");
//       final request = http.MultipartRequest("PUT", uri);
//       request.headers["Authorization"] = "Bearer $token";
//       request.fields["encrypted"] = encryptedBody;
//       request.files.add(
//         await http.MultipartFile.fromPath("profile_pic", profilePic.path),
//       );

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "updateProfilePic",
//       );
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         final profile = StudentProfileModel.fromJson(decrypted["student"]);
//         return right(profile);
//       } catch (e) {
//         return left("Failed to parse updated profile: $e");
//       }
//     } catch (e) {
//       return left("Exception: $e");
//     }
//   }

//   static Future<Either<String, StudentProfileModel>> updateProfilePicOnly({
//     required File profilePic,
//   }) async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;
//     try {
//       final uri = Uri.parse("$url/student/profile"); // use the same route

//       final request = http.MultipartRequest("PUT", uri);
//       request.headers["Authorization"] = "Bearer $token";

//       // Only add the image file, no encrypted payload
//       request.files.add(
//         await http.MultipartFile.fromPath("profile_pic", profilePic.path),
//       );

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "updateProfilePicOnly",
//       );
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         final profile = StudentProfileModel.fromJson(decrypted["student"]);
//         return right(profile);
//       } catch (e) {
//         return left("Failed to parse updated profile: $e");
//       }
//     } catch (e) {
//       return left("Exception: $e");
//     }
//   }

//   static Future<Either<String, HostelSingleResponse>> getHostelInfo() async {
//     final session = Get.find<LoginSession>();
//     final token = session.token;

//     try {
//       final response = await http.get(
//         Uri.parse("$url/student/hostel-info"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//       print("📡 getHostelInfo - Status: ${response.statusCode}");
//       final decrypted = CryptoUtil.handleEncryptedResponse(
//         response: response,
//         context: "getHostelInfo",
//       );
//       if (decrypted == null || decrypted["error"] != null) {
//         return left(
//           decrypted != null ? decrypted["error"].toString() : "Unknown error",
//         );
//       }
//       try {
//         print("📡 getHostelInfo - Decrypted: $decrypted");
//         final hostelResponse = HostelSingleResponse.fromJson(decrypted);
//         return right(hostelResponse);
//       } catch (e) {
//         return left("Failed to parse hostel info response: $e");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return left("Exception: $e");
//     }
//   }
// }

import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/models/hostels_model.dart';
import 'package:http/http.dart' as http;
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class ProfileService {
  static const url = "http://172.16.40.17:4141/api";

  static Future<Either<String, StudentApiResponse>> getStudentProfile() async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final response = await http.get(
        Uri.parse("$url/student/student-profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final apiResponse = StudentApiResponse.fromJson(data);
        return right(apiResponse);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      return left("Exception: $e");
    }
  }

  // Update profile with extra fields + image
  static Future<Either<String, StudentProfileModel>> updateProfilePic1({
    required Map<String, dynamic> profileData,
    required File profilePic,
  }) async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final uri = Uri.parse("$url/student/profile");
      final request = http.MultipartRequest("PUT", uri);
      request.headers["Authorization"] = "Bearer $token";

      // Add profile data as normal fields
      profileData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath("profile_pic", profilePic.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profile = StudentProfileModel.fromJson(data["student"]);
        return right(profile);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      return left("Exception: $e");
    }
  }

  // Update only profile picture
  static Future<Either<String, StudentProfileModel>> updateProfilePicOnly({
    required File profilePic,
  }) async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final uri = Uri.parse("$url/student/profile");
      final request = http.MultipartRequest("PUT", uri);
      request.headers["Authorization"] = "Bearer $token";

      request.files.add(
        await http.MultipartFile.fromPath("profile_pic", profilePic.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profile = StudentProfileModel.fromJson(data["student"]);
        return right(profile);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      return left("Exception: $e");
    }
  }

  static Future<Either<String, HostelSingleResponse>> getHostelInfo() async {
    final session = Get.find<LoginSession>();
    final token = session.token;

    try {
      final response = await http.get(
        Uri.parse("$url/student/hostel-info"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📡 getHostelInfo - Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📡 getHostelInfo - Response: $data");
        final hostelResponse = HostelSingleResponse.fromJson(data);
        return right(hostelResponse);
      } else {
        return left("Error: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  /// Fetch parent's child (student) profile from `/parent/student`
  static Future<Either<String, List<StudentProfileModel>>>
  getParentStudentProfile({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse("$url/parent/student"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        return left("Error: ${response.statusCode} - ${response.body}");
      }

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;
      print("he" * 90);
      print(decoded);
      if (decoded == null) {
        return left(
          decoded != null
              ? decoded["error"].toString()
              : "Unknown error while fetching child profile",
        );
      }

      // Expected shape: { message, student: { student: {...}, parentsInfo: [...] } }
      // final api = StudentApiResponse.fromJson(decoded);
      // decode = [{child1},{child2},{child3}]
      print("right below");
      final result = (decoded as List)
          .map((e) => StudentProfileModel.fromJson(e))
          .toList();
      print("result");
      return right(result);
    } catch (e) {
      return left("Exception: $e");
    }
  }
}
