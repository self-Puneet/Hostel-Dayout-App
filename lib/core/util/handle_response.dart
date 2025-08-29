import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:http/http.dart' as http;

// Utility for HTTP status code success check
bool isHttpSuccess(int statusCode) => statusCode >= 200 && statusCode <= 206;

// Centralized HTTP response handler
Map<String, dynamic>? handleEncryptedResponse({
  required http.Response response,
  String? context,
}) {
  // print("📡 Status: ${response.statusCode}");
  final encryptedBody = response.body.trim().replaceAll('"', '');

  if (isHttpSuccess(response.statusCode)) {
    try {
      final decrypted = CryptoUtil.decryptPayload(encryptedBody);
      return decrypted;
    } catch (e) {
      // print(
      //   "❌ Error decrypting success response${context != null ? ' ($context)' : ''}: $e",
      // );
      // print("Raw response: ${response.body}");
    }
  } else {
    try {
      final decryptedError = CryptoUtil.decryptPayload(encryptedBody);
      // print(
      //   "❌ Server Error (decrypted)${context != null ? ' ($context)' : ''}: $decryptedError",
      // );
      return {"error": decryptedError};
    } catch (e) {
      // print(
      // "❌ Error decrypting error response${context != null ? ' ($context)' : ''}: $e",
      // );
      // print("Raw error response: ${response.body}");
      return {"error": response.body};
    }
  }
  return null;
}
