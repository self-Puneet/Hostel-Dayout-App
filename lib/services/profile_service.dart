import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/config/constants.dart';
import 'package:hostel_mgmt/models/hostels_model.dart';
import 'package:http/http.dart' as http;
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class ProfileService {
  static const url = baseUrl;

  static Future<Either<String, StudentApiResponse>> getStudentProfile() async {
    final session = Get.find<LoginSession>();
    final token = session.token;
    print(session.token);

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

  static Future<Either<String, List<HostelModel>>> getAllHostelInfo() async {
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

      print("📡 getHostelInfo - Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📡 getHostelInfo - Response: $data");
        final hostelResponse = (data['hostels'] as List<dynamic>)
            .map((e) => HostelModel.fromJson(e))
            .toList();
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
