import 'package:flutter/material.dart';

class ParentState extends ChangeNotifier {
  bool isLoading = false;
  bool isErrored = false;
  String errorMessage = '';

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setError(String error) {
    isErrored = true;
    errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    isErrored = false;
    errorMessage = '';
    notifyListeners();
  }
}
