import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(String token, String wardenId, bool rememberMe);
  Future<Map<String, dynamic>?> getSession();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<void> saveSession(String token, String wardenId, bool rememberMe) async {
    await prefs.setString('token', token);
    await prefs.setString('wardenId', wardenId);
    await prefs.setBool('rememberMe', rememberMe);
  }

  @override
  Future<Map<String, dynamic>?> getSession() async {
    final token = prefs.getString('token');
    final wardenId = prefs.getString('wardenId');
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    if (token == null) return null;
    return {'token': token, 'wardenId': wardenId, 'rememberMe': rememberMe};
  }

  @override
  Future<void> clearSession() async {
    await prefs.clear();
  }
}
