import 'dart:convert';
import 'package:dartz/dartz.dart';
// import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:http/http.dart' as http;

class ParentService {
  static Future<Either<String, ParentModel>> getParentProfile({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("http://20.192.25.27:4141/api/parent/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      print(
        "📡 parentProfile - Status: ${response.statusCode} - ${response.body}",
      );

      // final decrypted = CryptoUtil.handleEncryptedResponse(
      //   response: response,
      //   context: "parentProfile",
      // );
      final decrypted = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : null;
      if (decrypted == null || decrypted["error"] != null) {
        return left(
          decrypted != null
              ? decrypted["error"].toString()
              : "Unknown error while fetching profile",
        );
      }
      // if (decrypted['profile'] == null) {
      //   return left("Profile data missing in response");
      // }
      final parent = ParentModel.fromJson(decrypted);
      return right(parent);
    } catch (e) {
      return left("Exception: $e");
    }
  }
}
