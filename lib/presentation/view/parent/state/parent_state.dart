// parent_state.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/request_model.dart';

class ParentState extends ChangeNotifier {
  bool isLoading = false;
  bool isErrored = false;
  String errorMessage = '';

  bool isActioning = false; // NEW

  RequestApiResponse? _all;
  List<RequestModel> activeRequests = [];
  bool get hasData => _all != null;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setActioning(bool value) { // NEW
    isActioning = value;
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

  void setRequests(RequestApiResponse resp) {
    _all = resp;
    activeRequests = resp.requests
        .where((r) => (r.active == true) || (r.status.name == 'requested'))
        .toList();
    notifyListeners();
  }

  // Helper to update one request in-place after API call
  void upsertRequest(RequestModel updated) { // NEW
    // Update in active list
    final idx = activeRequests.indexWhere((r) => r.requestId == updated.requestId);
    if (idx != -1) {
      activeRequests[idx] = updated;
    }
    // Also keep _all in sync if needed
    final allIdx = _all?.requests.indexWhere((r) => r.requestId == updated.requestId) ?? -1;
    if (allIdx != -1) {
      _all!.requests[allIdx] = updated;
    }
    notifyListeners();
  }
}
