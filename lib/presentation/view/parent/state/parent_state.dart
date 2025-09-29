// parent_state.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/models/request_model.dart';

class ParentState extends ChangeNotifier {
  bool isLoading = false;
  bool isErrored = false;
  String errorMessage = '';

  bool isActioning = false; // NEWx 

  RequestApiResponse? _all;
  List<RequestModel> activeRequests = [];
  bool get hasData => _all != null;

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void setActioning(bool value) {
    // NEW
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
  void upsertRequest(RequestModel updated) {
    // NEW
    // Update in active list
    final idx = activeRequests.indexWhere(
      (r) => r.requestId == updated.requestId,
    );
    if (idx != -1) {
      activeRequests[idx] = updated;
    }
    // Also keep _all in sync if needed
    final allIdx =
        _all?.requests.indexWhere((r) => r.requestId == updated.requestId) ??
        -1;
    if (allIdx != -1) {
      _all!.requests[allIdx] = updated;
    }
    notifyListeners();
  }

  // dropdown related states

  // dropdown related states
  String selectedStatus = 'All';
  List<String> statusOptions = ['All', 'Approved', 'Rejected', 'Cancelled'];

  void setSelectedStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  List<RequestModel> historyRequests = [];

  RequestModel? get filteredRequests {
    List<RequestModel> filtered;
    if (selectedStatus == 'All') {
      filtered = historyRequests;
    } else {
      filtered = historyRequests
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
      (curr, next) => curr.lastUpdatedAt.isBefore(next.lastUpdatedAt) ? curr : next,
    );
  }

  // set history requests
  void setHistoryRequests(List<RequestModel> historyRequests) {
    this.historyRequests = historyRequests;
    notifyListeners();
  }

  void resetForRefresh() {
    // Clear error/flags and reset filters
    isErrored = false;
    errorMessage = '';
    isActioning = false;
    selectedStatus = 'All';
    // Optionally keep data to avoid UI flicker during refresh
    notifyListeners();
  }
}
