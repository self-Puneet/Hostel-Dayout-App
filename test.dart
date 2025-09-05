import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart';
// import 'package:hostel_mgmt/models/hostels_model.dart';
// import 'package:hostel_mgmt/models/branch_model.dart';
// import 'package:hostel_mgmt/models/student_profile.dart';
// import 'package:hostel_mgmt/models/request_model.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static final Map<String, String> env = {};

  static Future<void> load([String fileName = ".env"]) async {
    final lines = await File(fileName).readAsLines();
    for (var line in lines) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      env[parts[0].trim()] = parts.sublist(1).join('=').trim();
    }
  }
}

class CryptoUtil {
  static bool isHttpSuccess(int statusCode) =>
      statusCode >= 200 && statusCode <= 206;

  static Map<String, dynamic>? handleEncryptedResponse({
    required http.Response response,
    String? context,
  }) {
    final encryptedBody = response.body.trim().replaceAll('"', '');
    print(encryptedBody);
    if (isHttpSuccess(response.statusCode)) {
      try {
        final decrypted = CryptoUtil.decryptPayload(encryptedBody);
        print(decrypted);
        return decrypted;
      } catch (e) {
        // return {"error": "Failed to decrypt success response"};
      }
    } else {
      try {
        final decryptedError = CryptoUtil.decryptPayload(encryptedBody);
        return {"error": decryptedError};
      } catch (e) {
        return {"error": response.body};
      }
    }
    return null;
  }

  static Uint8List deriveKey() {
    final secret = cryptoSecret;
    // SHA256(secret) → base64 → take first 32 chars → utf8 bytes
    final sha256Bytes = sha256.convert(utf8.encode(secret)).bytes;
    final sha256B64 = base64.encode(sha256Bytes);
    final key32 = sha256B64.substring(0, 32);
    return Uint8List.fromList(utf8.encode(key32));
  }

  static String encryptPayload(Map<String, dynamic> payload) {
    final key = deriveKey();
    final cipher = CBCBlockCipher(AESFastEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), cryptoIv));
    final input = utf8.encode(jsonEncode(payload));
    final padded = _pad(Uint8List.fromList(input), cipher.blockSize);
    final output = Uint8List(padded.length);
    for (int offset = 0; offset < padded.length;) {
      offset += cipher.processBlock(padded, offset, output, offset);
    }
    return base64.encode(output);
  }

  static Map<String, dynamic> decryptPayload(String encryptedB64) {
    final key = deriveKey();
    final cipher = CBCBlockCipher(AESFastEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), cryptoIv));
    final encryptedBytes = base64.decode(encryptedB64);
    final decryptedPadded = Uint8List(encryptedBytes.length);
    for (int offset = 0; offset < encryptedBytes.length;) {
      offset += cipher.processBlock(
        encryptedBytes,
        offset,
        decryptedPadded,
        offset,
      );
    }
    final unpadded = _unpad(decryptedPadded);
    return jsonDecode(utf8.decode(unpadded));
  }

  static Uint8List _pad(Uint8List data, int blockSize) {
    final padLen = blockSize - (data.length % blockSize);
    return Uint8List.fromList(data + List<int>.filled(padLen, padLen));
  }

  static Uint8List _unpad(Uint8List data) {
    final padLen = data.last;
    return data.sublist(0, data.length - padLen);
  }

  // static Uint8List get cryptoIv {
  //   final ivString = dotenv.env['CRYPTO_IV'] ?? '';
  //   final ivList = ivString
  //       .split(',')
  //       .map((e) => int.parse(e, radix: 16))
  //       .toList();
  //   return Uint8List.fromList(ivList);
  // }

  // static String get cryptoSecret => dotenv.env['CRYPTO_SECRET'] ?? '';

  static Uint8List get cryptoIv {
    final ivString = Env.env['CRYPTO_IV'] ?? '';
    final ivList = ivString
        .split(',')
        .map((e) => int.parse(e, radix: 16))
        .toList();
    return Uint8List.fromList(ivList);
  }

  static String get cryptoSecret => Env.env['CRYPTO_SECRET'] ?? '';
}

// Utility for HTTP status code success check

// Centralized HTTP response handler

class Services {
  /// Reset password service method
  static Future<Either<String, bool>> resetPassword({
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    try {
      final encryptedPayload = CryptoUtil.encryptPayload({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      final response = await http.put(
        Uri.parse("$url/admin/reset-password"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"encrypted": encryptedPayload}),
      );
      print("📡 Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "resetPassword",
      );
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      // If success, return true
      return right(true);
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  static const url = "http://20.192.25.27:4141/api";

  static Future<Map<String, dynamic>> login(
    String enrollmentNo,
    String password,
  ) async {
    print(enrollmentNo);
    print(password);
    final payload = {"enrollment_no": enrollmentNo, "password": password};
    final encrypted = CryptoUtil.encryptPayload(payload);
    final response = await http.post(
      Uri.parse("$url/student/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"encrypted": encrypted}),
    );
    print("📡 Status: ${response.statusCode}");
    final decrypted = CryptoUtil.handleEncryptedResponse(
      response: response,
      context: "login",
    );
    if (decrypted == null) {
      return {"error": "Failed to decrypt response"};
    }
    return decrypted;
  }

  // static Future<Either<String, String>> getValidToken() async {
  // try {
  //   final session = await LoginSession.loadFromPrefs();

  //   if (session == null) {
  //     return left('Session not found. Please login again.');
  //   }

  //   if (session.token.isEmpty) {
  //     return left('Invalid session token. Please login again.');
  //   }

  //   return right(session.token);
  // } catch (e) {
  //   return left('Error loading session: $e');
  // }
  // }

  // a demo static function to return a static hard coded token for testing

  static String token =
      "fQS5LZW7LiTEZmhx6vzqiyr7OooQ3fRKcUKuyvzOVp6Xk1pj2qT2uGWYj8qdnhXyc/FE7y9agzIaZKBb5M5jzwK7s5skrDKIKwh4b74ZCORWVJZosE228q/ANFKIqzLSU2Oqq0wv8C26vMGoT35Q775Uc6sIaaytCFOI1dvon9CQArUki8KmljzsYOKPxg1gW9lD0hkprPwyiOVGn2vGzhCgyd4KF6tC4TBzcJ9/c0DaQSv1sfdZNUC9Lti/zErn+EU7WscojPC7lqKYRJ3uKO6XiyyFLUFJUsx4f2Nu+8PvjxQ/YsaiywpRFeqCGrYM";

  // static Future<Either<String, HostelResponse>> getAllHostelInfo() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$url/student/all-hostel-info"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //     print("📡 Status: ${response.statusCode}");
  //     final decrypted = CryptoUtil.handleEncryptedResponse(
  //       response: response,
  //       context: "getAllHostelInfo",
  //     );
  //     if (decrypted == null || decrypted["error"] != null) {
  //       return left(
  //         decrypted != null ? decrypted["error"].toString() : "Unknown error",
  //       );
  //     }
  //     try {
  //       final hostelResponse = HostelResponse.fromJson(decrypted);
  //       return right(hostelResponse);
  //     } catch (e) {
  //       return left("Failed to parse hostel response: $e");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     return left("Exception: $e");
  //   }
  // }

  // static Future<Either<String, BranchResponse>> getAllBranches() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$url/student/all-branches"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //     print("📡 Status: ${response.statusCode}");
  //     final decrypted = CryptoUtil.handleEncryptedResponse(
  //       response: response,
  //       context: "getAllBranches",
  //     );
  //     if (decrypted == null || decrypted["error"] != null) {
  //       return left(
  //         decrypted != null ? decrypted["error"].toString() : "Unknown error",
  //       );
  //     }
  //     try {
  //       final branchResponse = BranchResponse.fromJson(decrypted);
  //       return right(branchResponse);
  //     } catch (e) {
  //       return left("Failed to parse branch response: $e");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     return left("Exception: $e");
  //   }
  // }

  // static Future<Either<String, StudentApiResponse>> getStudentProfile() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$url/student/student-profile"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //     print("📡 Status: ${response.statusCode}");
  //     final decrypted = CryptoUtil.handleEncryptedResponse(
  //       response: response,
  //       context: "getStudentProfile",
  //     );
  //     if (decrypted == null || decrypted["error"] != null) {
  //       return left(
  //         decrypted != null ? decrypted["error"].toString() : "Unknown error",
  //       );
  //     }
  //     try {
  //       final apiResponse = StudentApiResponse.fromJson(decrypted);
  //       return right(apiResponse);
  //     } catch (e) {
  //       return left("Failed to parse student profile response: $e");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     return left("Exception: $e");
  //   }
  // }

  // static Future<Either<String, HostelSingleResponse>> getHostelInfo() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$url/student/hostel-info"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //     print("📡 Status: ${response.statusCode}");
  //     final decrypted = CryptoUtil.handleEncryptedResponse(
  //       response: response,
  //       context: "getHostelInfo",
  //     );
  //     if (decrypted == null || decrypted["error"] != null) {
  //       return left(
  //         decrypted != null ? decrypted["error"].toString() : "Unknown error",
  //       );
  //     }
  //     try {
  //       final hostelResponse = HostelSingleResponse.fromJson(decrypted);
  //       return right(hostelResponse);
  //     } catch (e) {
  //       return left("Failed to parse hostel info response: $e");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     return left("Exception: $e");
  //   }
  // }

  // static Future<Either<String, StudentProfileModel>> updateProfile({
  //   required Map<String, dynamic> profileData,
  //   File? profilePic,
  // }) async {
  //   try {
  //     final encryptedBody = CryptoUtil.encryptPayload(profileData);
  //     final uri = Uri.parse("$url/student/profile");
  //     final request = http.MultipartRequest("PUT", uri);
  //     request.headers["Authorization"] = "Bearer $token";
  //     request.fields["encrypted"] = encryptedBody;
  //     if (profilePic != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath("profile_pic", profilePic.path),
  //       );
  //     }
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     print("📡 Status: ${response.statusCode}");
  //     final decrypted = CryptoUtil.handleEncryptedResponse(
  //       response: response,
  //       context: "updateProfile",
  //     );
  //     print(deprecated);
  //     if (decrypted == null || decrypted["error"] != null) {
  //       return left(
  //         decrypted != null ? decrypted["error"].toString() : "Unknown error",
  //       );
  //     }
  //     try {
  //       final profile = StudentProfileModel.fromJson(decrypted["student"]);
  //       print(profile.name);
  //       return right(profile);
  //     } catch (e) {
  //       return left("Failed to parse updated profile: $e");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     return left("Exception: $e");
  //   }
  // }

  // static Future<Either<String, RequestApiResponse>> getAllRequests() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$url/student/requests"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //     print("📡 Status: ${response.statusCode}");
  //     final decrypted = CryptoUtil.handleEncryptedResponse(
  //       response: response,
  //       context: "getAllRequests",
  //     );
  //     print(decrypted);
  //     if (decrypted == null || decrypted["error"] != null) {
  //       return left(
  //         decrypted != null ? decrypted["error"].toString() : "Unknown error",
  //       );
  //     }
  //     try {
  //       final apiResponse = RequestApiResponse.fromJson(decrypted);
  //       // print(apiResponse);
  //       return right(apiResponse);
  //     } catch (e) {
  //       return left("Failed to parse requests: $e");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     return left("Exception: $e");
  //   }
  // }

  static Future<Either<String, dynamic>> getAllRequests({
    required String token_,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$url/student/requests"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token_",
        },
      );
      print("📡 Status: ${response.statusCode}");
      final decrypted = CryptoUtil.handleEncryptedResponse(
        response: response,
        context: "getAllRequests",
      );
      print(decrypted);
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null ? decrypted["error"].toString() : "Unknown error",
        );
      }
      try {
        // print(apiResponse);
        return right(decrypted);
      } catch (e) {
        return left("Failed to parse requests: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  // static Future<Either<String, RequestModel>> getRequestById({
  //   required String requestId,
  //   required String token_,
  // }) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$url/student/requests/$requestId"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token_",
  //       },
  //     );
  //     print("📡 Status: ${response.statusCode}");
  //     final decrypted = CryptoUtil.handleEncryptedResponse(
  //       response: response,
  //       context: "getRequestById",
  //     );
  //     if (decrypted == null || decrypted["error"] != null) {
  //       return left(
  //         decrypted != null ? decrypted["error"].toString() : "Unknown error",
  //       );
  //     }
  //     try {
  //       final request = RequestModel.fromJson(decrypted["request"] ?? {});
  //       return right(request);
  //     } catch (e) {
  //       return left("Failed to parse request: $e");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     return left("Exception: $e");
  //   }
  // }
  static Future<Either<String, dynamic>> getRequestById({
    required String requestId,
    required String token_,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$url/student/requests/$requestId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token_",
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
        return right(decrypted);
      } catch (e) {
        return left("Failed to parse request: $e");
      }
    } catch (e) {
      print("❌ Exception: $e");
      return left("Exception: $e");
    }
  }

  // static Future<Either<String, RequestModel>> createRequest({
  //   required Map<String, dynamic> requestData,
  // }) async {
  //   try {
  //     final encryptedBody = CryptoUtil.encryptPayload(requestData);
  //     final response = await http.post(
  //       Uri.parse("$url/student/create-request"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({"encrypted": encryptedBody}),
  //     );
  //     print("📡 Status: ${response.statusCode}");
  //     final decrypted = CryptoUtil.handleEncryptedResponse(
  //       response: response,
  //       context: "createRequest",
  //     );
  //     if (decrypted == null || decrypted["error"] != null) {
  //       return left(
  //         decrypted != null ? decrypted["error"].toString() : "Unknown error",
  //       );
  //     }
  //     try {
  //       final request = RequestModel.fromJson(decrypted["request"] ?? {});
  //       return right(request);
  //     } catch (e) {
  //       return left("Failed to parse created request: $e");
  //     }
  //   } catch (e) {
  //     print("❌ Exception: $e");
  //     return left("Exception: $e");
  //   }
  // }

  // create a reset password service method static
  //  const encryptedPayload = encryptData({
  //     oldPassword: "BigjoD3rCL",
  //     newPassword: "NewPassword123"
  //   });

  //   console.log("Encrypted Request:", encryptedPayload);
  //   // use token in header
  //   const res = await axios.put("http://20.192.25.27:4141/api/admin/reset-password", { encrypted: encryptedPayload }, {
  //     headers: {
  //       Authorization: `Bearer ${rawToken}`,
  //     },
  //   });
}

// Future<void> main() async {
//   await Env.load();

// final hehe = await Services.getAllHostelInfo();
// hehe.fold(
//   (error) => print("❌ Error: $error"),
//   (data) => data.hostels.forEach((hostel) {
//     print("✅ Success: ${hostel.hostelName}");
//   }),
// );

// final branches = await Services.getAllBranches();
// branches.fold(
//   (error) => print("❌ Error: $error"),
//   (data) => data.branches.forEach((branch) {
//     print("✅ Success: ${branch.name}");
//   }),
// );

// final studentProfile = await Services.getStudentProfile();
// studentProfile.fold(
//   (error) => print("❌ Error: $error"),
//   (data) => print("✅ Success: ${data.student.name}"),
// );

// final hostelInfo = await Services.getHostelInfo();
// hostelInfo.fold(
//   (error) => print("❌ Error: $error"),
//   (data) => print("✅ Success: ${data.hostel.hostelName}"),
// );

// final updateProfile = await Services.updateProfile(
//   profileData: {"name": "test", "email": "test@spsu.ac.in"},
//   profilePic: File("C:\\Users\\punee\\OneDrive\\Desktop\\download.jpeg"),
// );
// updateProfile.fold(
//   (error) => print("❌ Error: $error"),
//   (data) => print("✅ Success: ${data.name}"),
// );

// final requestData = {
//   "request_type": "outing",
//   "applied_from": "2025-06-12T10:00:00Z",
//   "applied_to": "2025-06-15T18:00:00Z",
//   "reason": "Family function",
// };
// print(await Services.createRequest(requestData: requestData));
// print(await Services.getRequestById(requestId: "68aef4b26ce427e7a490d781"));

//   final thing = await Services.login("22EC002584", "test1");
//   // print(thing);
//   final token = thing['token'];
//   print(
//     await Services.getAllRequests(
//       // requestId: "68b5bbf224cd43a5078b94c9",
//       token_: token,
//     ),
//   );
// }
void main() async {
  await Env.load();

  // Example usage of the login function
  // final empId = "W12345";
  // final password = "wardenPass";

  final loginResponse = await Services.login("22EC002584", "test1");
  print(loginResponse);

  final payload = {
    "emp_id": "W002",
    "wardenType": "warden",
    "password": "l5wq+D701/",
  };
  final encrypted = CryptoUtil.encryptPayload(payload);
  final response = await http.post(
    Uri.parse("http://20.192.25.27:4141/api/warden/login/warden"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"encrypted": encrypted}),
  );
  print("📡 Status: ${response.statusCode}");
  final decrypted = CryptoUtil.handleEncryptedResponse(
    response: response,
    context: "loginAssistentWarden",
  );
  print(decrypted);
}
