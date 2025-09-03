import 'dart:io';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/branch_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import '../models/hostels_model.dart';
import 'package:http/http.dart' as http;
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:dartz/dartz.dart';

class ProfileService {
  // static String token =
  //     "fQS5LZW7LiTEZmhx6vzqiyr7OooQ3fRKcUKuyvzOVp6Xk1pj2qT2uGWYj8qdnhXyc/FE7y9agzIaZKBb5M5jzwK7s5skrDKIKwh4b74ZCORWVJZosE228q/ANFKIqzLSU2Oqq0wv8C26vMGoT35Q775Uc6sIaaytCFOI1dvon9CQArUki8KmljzsYOKPxg1gW9lD0hkprPwyiOVGn2vGzhCgyd4KF6tC4TBzcJ9/c0DaQSv1sfdZNUC9Lti/zErn+EU7WscojPC7lqKYRJ3uKO6XiyyFLUFJUsx4f2Nu+8PvjxQ/YsaiywpRFeqCGrYM";
  static const url = "http://20.192.25.27:4141/api";

  static Future<Either<String, StudentApiResponse>> getStudentProfile() async {
    // final token = await LoginSession.getValidToken();

    // token.fold((ifLeft) => null, (ifRight) {
    //   if (ifRight.isEmpty) {
    //     return left('Invalid or missing session. Please login again.');
    //   }
    // });

    final session = Get.find<LoginSession>();
    final token = session.token;
    print(token);

    try {
      final response = await http.get(
        Uri.parse("$url/student/student-profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("📡 getStudentProfile - Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "getStudentProfile",
      );
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        final apiResponse = StudentApiResponse.fromJson(decrypted);
        return right(apiResponse);
      } catch (e) {
        return left("Failed to parse student profile response: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static Future<Either<String, HostelSingleResponse>> getHostelInfo() async {
    // var token = await LoginSession.getValidToken();

    // token.fold((ifLeft) => null, (ifRight) {
    //   if (ifRight.isEmpty) {
    //     return left('Invalid or missing session. Please login again.');
    //   }
    // });
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
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "getHostelInfo",
      );
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        final hostelResponse = HostelSingleResponse.fromJson(decrypted);
        return right(hostelResponse);
      } catch (e) {
        return left("Failed to parse hostel info response: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static Future<Either<String, HostelResponse>> getAllHostelInfo() async {
    // final token = await LoginSession.getValidToken();

    // token.fold((ifLeft) => null, (ifRight) {
    //   if (ifRight.isEmpty) {
    //     return left('Invalid or missing session. Please login again.');
    //   }
    // });
    final session = Get.find<LoginSession>();
    final token = session.token;
    try {
      final response = await http.get(
        Uri.parse("$url/student/all-hostel-info"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("📡 getAllHostelInfo - Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "getAllHostelInfo",
      );
      print(decrypted);
      if (decrypted == null || decrypted["error"] != null) {
        // Handle both string and map error formats
        String errorMsg;
        if (decrypted == null) {
          errorMsg = "Unknown error";
        } else if (decrypted["error"] is String) {
          errorMsg = decrypted["error"];
        } else if (decrypted["error"] is Map &&
            decrypted["error"]["error"] != null) {
          errorMsg = decrypted["error"]["error"].toString();
        } else {
          errorMsg = "Unknown error";
        }
        return left(errorMsg);
      }
      try {
        final hostelResponse = HostelResponse.fromJson(decrypted);
        return right(hostelResponse);
      } catch (e) {
        return left("Failed to parse hostel response: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static Future<Either<String, BranchResponse>> getAllBranches() async {
    // final token = await LoginSession.getValidToken();

    // token.fold((ifLeft) => null, (ifRight) {
    //   if (ifRight.isEmpty) {
    //     return left('Invalid or missing session. Please login again.');
    //   }
    // });
    final session = Get.find<LoginSession>();
    final token = session.token;
    try {
      final response = await http.get(
        Uri.parse("$url/student/all-branches"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("📡 getAllBranches - Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "getAllBranches",
      );
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        final branchResponse = BranchResponse.fromJson(decrypted);
        return right(branchResponse);
      } catch (e) {
        return left("Failed to parse branch response: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static Future<Either<String, StudentProfileModel>> updateProfile({
    required Map<String, dynamic> profileData,
    File? profilePic,
  }) async {
    // final token = await LoginSession.getValidToken();

    // token.fold((ifLeft) => null, (ifRight) {
    //   if (ifRight.isEmpty) {
    //     return left('Invalid or missing session. Please login again.');
    //   }
    // });
    final session = Get.find<LoginSession>();
    final token = session.token;
    try {
      final encryptedBody = CryptoUtil.encryptPayload(profileData);
      final uri = Uri.parse("$url/student/profile");
      final request = http.MultipartRequest("PUT", uri);
      request.headers["Authorization"] = "Bearer $token";
      request.fields["encrypted"] = encryptedBody;
      if (profilePic != null) {
        request.files.add(
          await http.MultipartFile.fromPath("profile_pic", profilePic.path),
        );
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("📡 updateProfile - Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "updateProfile",
      );
      print(decrypted);
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        final profile = StudentProfileModel.fromJson(decrypted["student"]);
        print(profile.name);
        return right(profile);
      } catch (e) {
        return left("Failed to parse updated profile: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }
}
