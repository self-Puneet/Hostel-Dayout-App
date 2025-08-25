import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? _prefs;

  /// Call this once at app startup (e.g., in main())
  static Future init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save a string
  static Future set(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get a string
  static String? get(String key) {
    return _prefs?.getString(key);
  }

  /// Remove a single key
  static Future remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all stored data
  static Future clear() async {
    await _prefs?.clear();
  }
}
