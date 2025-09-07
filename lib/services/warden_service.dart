import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:hostel_mgmt/models/warden_model.dart';
import 'package:http/http.dart' as http;

class WardenService {
  static const url = "http://20.192.25.27:4141/api";

  static Future<Either<String, WardenModel>> getWardenProfile({
    required String token,
  }) async {
    try {
      final response_profile = await http.get(
        Uri.parse("$url/warden/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      final decrypted_profile = CryptoUtil.handleEncryptedResponse(
        response: response_profile,
        context: "wardenProfile",
      );
      if (decrypted_profile == null || decrypted_profile["error"] != null) {
        return left(
          decrypted_profile != null
              ? decrypted_profile["error"].toString()
              : "Unknown error",
        );
      }
      print("dsfsdfsdfsfsdf");
      print(decrypted_profile);
      final warden = WardenModel.fromJson(decrypted_profile['profile']);
      return right(warden);
    } catch (e) {
      return left("Exception: $e");
    }
  }
}     
