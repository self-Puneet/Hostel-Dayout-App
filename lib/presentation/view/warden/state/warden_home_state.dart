import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/request_model.dart';

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
  List<dynamic> currentOnScreenRequests = [];

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
  }

  void _filterRequests() {
    final query = filterController.text.trim().toLowerCase();
    if (_allRequests == null) {
      currentOnScreenRequests = [];
    } else if (query.isEmpty) {
      currentOnScreenRequests = List.from(_allRequests!.requests);
    } else {
      currentOnScreenRequests = _allRequests!.requests
          .where(
            (req) => req.studentAction!.studentProfileModel.name
                .toLowerCase()
                .contains(query),
          )
          .toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }
}
