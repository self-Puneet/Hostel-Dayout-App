import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/request_model.dart';

class HomeState extends ChangeNotifier {
  bool isLoading;
  List<RequestModel> requests;

  HomeState({this.isLoading = false, this.requests = const []});

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setRequests(List<RequestModel> reqs) {
    requests = reqs;
    notifyListeners();
  }
}
