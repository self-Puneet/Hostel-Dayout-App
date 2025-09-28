// lib/presentation/view/student/state/request_state.dart
import 'package:flutter/foundation.dart';
import 'package:hostel_mgmt/models/request_model.dart';

class RequestState extends ChangeNotifier {
  bool isLoading = true;
  RequestDetailApiResponse? request;
  bool isErrored = false;
  String errorMessage = '';

  // Action flags
  bool isActioning = false;

  void setLoading(bool value) { isLoading = value; notifyListeners(); }

  void setRequest(RequestDetailApiResponse req) {
    request = req;
    notifyListeners();
  }

  void setError(String message) {
    isErrored = true;
    errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    isErrored = false;
    errorMessage = '';
    notifyListeners();
  }

  void setActioning(bool value) {
    isActioning = value;
    notifyListeners();
  }
}
