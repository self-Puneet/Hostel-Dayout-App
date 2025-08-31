import 'package:flutter/material.dart';
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class HomeState extends ChangeNotifier {
  bool isLoading;
  List<RequestModel> requests;
  StudentProfileModel? profile;

  HomeState({this.isLoading = false, this.requests = const [], this.profile});

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setRequests(List<RequestModel> reqs) {
    requests = reqs;
    notifyListeners();
  }

  void setProfile(StudentProfileModel profileModel) {
    profile = profileModel;
    notifyListeners();
  }
}
