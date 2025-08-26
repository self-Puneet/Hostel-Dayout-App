// login_state.dart
import 'package:flutter/foundation.dart';

class LoginState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  // Simulate a login
  Future<void> signIn() async {
    _isLoading = true;
    notifyListeners();

    // TODO: replace with real auth call
    await Future.delayed(const Duration(seconds: 1));

    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}
