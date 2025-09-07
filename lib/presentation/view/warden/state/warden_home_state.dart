import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/request_model.dart';

class onScreenRequest {
  final RequestModel request;
  bool isActioning;

  onScreenRequest({required this.request, this.isActioning = false});
  
  // copyWith method to create a modified copy
  onScreenRequest copyWith({RequestModel? request, bool? isActioning}) {
    return onScreenRequest(
      request: request ?? this.request,
      isActioning: isActioning ?? this.isActioning,
    );
  }
}

class WardenHomeState extends ChangeNotifier {
  // Loading and error state
  bool _isLoading = false;
  bool _isErrored = false;
  bool _isActioning = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  bool get isActioning => _isActioning;
  String get errorMessage => _errorMessage;

  // Request data
  RequestApiResponse? _allRequests;
  List<onScreenRequest> currentOnScreenRequests = [];

  // Search controller
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

  void setIsActioningbyId(String id, bool value) {
    final index = currentOnScreenRequests.indexWhere((req) => req.request.id == id);
    if (index != -1) {
      currentOnScreenRequests[index] = currentOnScreenRequests[index].copyWith(isActioning: value);
      notifyListeners();
    }
  }

  void _filterRequests() {
    final query = filterController.text.trim().toLowerCase();
    if (_allRequests == null) {
      currentOnScreenRequests = [];
      notifyListeners();
    } else if (query.isEmpty) {
      // _requests is of type RequestApiResponse and onScreenRequest is a wrapper class
      currentOnScreenRequests = _allRequests!.requests.map((req) {
        return onScreenRequest(request: req);
      }).toList();
      notifyListeners();
    } else {
      currentOnScreenRequests = _allRequests!.requests.map((req) {
        return onScreenRequest(request: req);
      }).where(
        (req) => req.request.studentAction!.studentProfileModel.name
            .toLowerCase()
            .contains(query),
      ).toList();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }
}
