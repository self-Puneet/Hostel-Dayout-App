import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class HomeState extends ChangeNotifier {
  bool isLoading;
  List<RequestModel> activeRequests;
  StudentProfileModel? profile;

  HomeState({
    this.isLoading = false,
    this.activeRequests = const [],
    this.profile,
    this.requests = const [],
  });

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setRequests(List<RequestModel> reqs) {
    activeRequests = reqs;
    notifyListeners();
  }

  void setProfile(StudentProfileModel profileModel) {
    profile = profileModel;
    notifyListeners();
  }

  // dropdown related states
  String selectedStatus = 'All';
  List<String> statusOptions = ['All', 'Approved', 'Rejected', 'Cancelled'];

  void setSelectedStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  List<RequestModel> requests;

  RequestModel? get filteredRequests {
    List<RequestModel> filtered;
    if (selectedStatus == 'All') {
      filtered = requests;
    } else {
      filtered = requests
          .where(
            (req) =>
                req.status.minimalDisplayName.toLowerCase() ==
                selectedStatus.toLowerCase(),
          )
          .toList();
    }
    if (filtered.isEmpty) return null;
    // Return the most recent request
    return filtered.reduce(
      (curr, next) => curr.appliedAt.isBefore(next.appliedAt) ? curr : next,
    );
  }

  // set history requests
  void setHistoryRequests(List<RequestModel> historyRequests) {
    requests = historyRequests;
    notifyListeners();
  }
}
