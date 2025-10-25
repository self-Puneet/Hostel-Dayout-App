// presentation/view/warden/state/warden_layout_state.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';

class WardenLayoutState extends ChangeNotifier {
  // Loading & error (unchanged)
  bool _isLoading = false;
  bool _isErrored = false;
  String _errorMessage = '';
  bool _isActioning = false;

  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  String get errorMessage => _errorMessage;
  bool get isActioning => _isActioning;

  // Login session access (unchanged)
  final session = Get.find<LoginSession>();
  LoginSession get loginSession => session;

  // New: overlay visibility
  bool _showActionOverlay = false;
  bool get showActionOverlay => _showActionOverlay;

  WardenLayoutState();

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(bool hasError, String message) {
    _isErrored = hasError;
    _errorMessage = message;
    notifyListeners();
  }

  // Overlay API
  void showActionsOverlay() {
    if (_showActionOverlay) return;
    _showActionOverlay = true;
    notifyListeners();
  }

  void hideActionsOverlay() {
    if (!_showActionOverlay) return;
    _showActionOverlay = false;
    notifyListeners();
  }

  void toggleActionsOverlay() {
    _showActionOverlay = !_showActionOverlay;
    notifyListeners();
  }

  void clearState() {
    _isLoading = false;
    _isActioning = false;
    _isErrored = false;
    _errorMessage = '';
  
  
  }
}
