import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'package:http/http.dart' as http;

void method({
  requestId = "68b5bce9b232664dd3f02112",
  url = "http://20.192.25.27:4141/api",
  token =
      "fQS5LZW7LiTEZmhx6vzqiyr7OooQ3fRKcUKuyvzOVp6Xk1pj2qT2uGWYj8qdnhXyoG1SNKOra0WszBfK28yqpeeJSBC5c18rMcCNrAPwroTOuM60ZVa/vnJkBCfyj4EEmOwpWJ3fhLxuT9q0TZUlw6Zm4ZDXdyW5SZjpa3FqzLSv1RqyGVnMRZHTsLCRt/6ZY9m6lCd9EQv+N9BCQqSHQkfoCUafroaKenw9vhwhjQv7DFBi+XXI7N+1MmExg81E7GRqRegY4TtQvjw3S/NFS+qcmnLkzrio/COcgMiq609s8xpvmBtrylHcfAdYa1K+",
}) async {
  final response = await http.get(
    Uri.parse("$url/student/requests/$requestId"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );
  print("📡 Status of get request by id: ${response.statusCode}");
  final decrypted = CryptoUtil.handleEncryptedResponse(
    response: response,
    context: "getRequestById",
  );
  print(decrypted);
}

void main() {
  method();
}
