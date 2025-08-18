// ...existing code...
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<String> login(String wardenId, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<String> login(String wardenId, String password) async {
    final response = await client.post(
      Uri.parse('20.244.50.12/auth/login'),
      body: {'wardenId': wardenId, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Login failed');
    }
    // Mocking a successful login response for demonstration purposes
    // return Future.value('mocked_token');
  }
}
