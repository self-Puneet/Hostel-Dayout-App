import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';

class WardenProfileState extends ChangeNotifier {
  // Loading and error state management
  bool _isLoading = false;
  bool _isErrored = false;
  String _errorMessage = '';

  // Getters for loading and error states
  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  String get errorMessage => _errorMessage;

  // Access to the login session
  final session = Get.find<LoginSession>();
  LoginSession get loginSession => session;

  WardenProfileState();

  // Methods to update loading state
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Methods to update error state
  void setError(bool hasError, String message) {
    _isErrored = hasError;
    _errorMessage = message;
    notifyListeners();
  }
}
