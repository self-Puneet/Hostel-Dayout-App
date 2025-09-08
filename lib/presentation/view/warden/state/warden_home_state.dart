// warden_home_state.dart

import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/request_model.dart';

// Add isSelected to the wrapper.
class onScreenRequest {
  final RequestModel request;
  bool isActioning;
  bool isSelected; // NEW

  onScreenRequest({
    required this.request,
    this.isActioning = false,
    this.isSelected = false, // NEW
  });

  onScreenRequest copyWith({
    RequestModel? request,
    bool? isActioning,
    bool? isSelected, // NEW
  }) {
    return onScreenRequest(
      request: request ?? this.request,
      isActioning: isActioning ?? this.isActioning,
      isSelected: isSelected ?? this.isSelected, // NEW
    );
  }
}

class WardenHomeState extends ChangeNotifier {
  bool _isLoading = false;
  bool _isErrored = false;
  bool _isActioning = false;
  String _errorMessage = '';

  // Keep a derived global flag via getter rather than a mutable _isSelected.
  final Set<String> _selectedIds = {}; // NEW

  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  bool get isActioning => _isActioning;
  String get errorMessage => _errorMessage;
  bool get hasSelection => _selectedIds.isNotEmpty; // NEW

  RequestApiResponse? _allRequests;
  bool get hasData => _allRequests != null;
  List<onScreenRequest> currentOnScreenRequests = [];
  List<RequestModel> selectedRequests = []; // optional mirror list if needed

  final TextEditingController filterController = TextEditingController();

  WardenHomeState() {
    filterController.addListener(_filterRequests);
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(bool hasError, String message) {
    _isErrored = hasError;
    _errorMessage = message;
    notifyListeners();
  }

  void setIsActioning(bool value) {
    _isActioning = value;
    notifyListeners();
  }

  void setRequests(RequestApiResponse response) {
    _allRequests = response;
    _filterRequests();
    notifyListeners();
  }

  // Helper: check if selected by id
  bool isSelectedById(String id) => _selectedIds.contains(id); // NEW

  // Toggle selection by id
  void toggleSelectedById(String id) {
    // NEW
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    // Update wrapper flags in place for immediate visual feedback
    for (var i = 0; i < currentOnScreenRequests.length; i++) {
      final req = currentOnScreenRequests[i];
      final requestId =
          req.request.requestId; // ensure consistency with RequestModel
      if (requestId == id) {
        currentOnScreenRequests[i] = req.copyWith(
          isSelected: _selectedIds.contains(id),
        );
        break;
      }
    }
    // Optionally maintain selectedRequests mirror
    selectedRequests = currentOnScreenRequests
        .where((w) => _selectedIds.contains(w.request.requestId))
        .map((w) => w.request)
        .toList();
    notifyListeners();
  }

  // Clear all selection (after bulk action)
  void clearSelection() {
    // NEW
    _selectedIds.clear();
    selectedRequests.clear();
    for (var i = 0; i < currentOnScreenRequests.length; i++) {
      currentOnScreenRequests[i] = currentOnScreenRequests[i].copyWith(
        isSelected: false,
      );
    }
    notifyListeners();
  }

  void setIsActioningbyId(String id, bool value) {
    final index = currentOnScreenRequests.indexWhere(
      (req) => req.request.requestId == id, // align with RequestModel.requestId
    );
    if (index != -1) {
      currentOnScreenRequests[index] = currentOnScreenRequests[index].copyWith(
        isActioning: value,
      );
      notifyListeners();
    }
  }

  void _filterRequests() {
    final query = filterController.text.trim().toLowerCase();

    // If data not loaded, clear and notify
    if (_allRequests == null) {
      currentOnScreenRequests = [];
      notifyListeners();
      return;
    }

    final all = _allRequests!.requests;

    // Build the base wrapped list with projected selection
    final wrapped = all.map((req) {
      return onScreenRequest(
        request: req,
        isSelected: _selectedIds.contains(req.requestId),
      );
    }).toList();

    if (query.isEmpty) {
      currentOnScreenRequests = wrapped;
      notifyListeners();
      return;
    }

    String _safeName(onScreenRequest w) {
      final n = w.request.studentEnrollmentNumber;
      return n.toLowerCase();
    }

    currentOnScreenRequests = wrapped.where((w) {
      final nameLower = _safeName(w);
      return nameLower.contains(query);
    }).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }
}
