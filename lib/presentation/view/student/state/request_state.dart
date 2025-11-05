// lib/presentation/view/student/state/request_state.dart
import 'package:flutter/foundation.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class RequestState extends ChangeNotifier {
  bool isLoading = true;
  RequestDetailApiResponse? request;
  bool isErrored = false;
  String errorMessage = '';

  // Student parent info
  bool isLoadingStudentParentInfo = false;
  StudentProfileModel? studentParentInfo;

  // Action flags
  bool isActioning = false;

  void setLoading(bool value) { isLoading = value; notifyListeners(); }

  void setLoadingStudentParentInfo(bool value) {
    isLoadingStudentParentInfo = value;
    notifyListeners();
  }

  

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
