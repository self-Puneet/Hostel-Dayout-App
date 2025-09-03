import 'package:flutter/foundation.dart';
import 'package:hostel_mgmt/models/request_model.dart';

class RequestState extends ChangeNotifier {
  bool isLoading = false;
  RequestModel? request;
  bool isErrored = false;
  String errorMessage = '';

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setRequest(RequestModel req) {
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
}
