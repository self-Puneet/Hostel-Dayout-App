// lib/presentation/view/warden/state/warden_history_state.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class OnScreenHistoryItem {
  final RequestModel request;
  final StudentProfileModel student;

  OnScreenHistoryItem({required this.request, required this.student});
}

class WardenHistoryState extends ChangeNotifier {
  bool _isLoading = false;
  bool _isErrored = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  String get errorMessage => _errorMessage;

  // Hostels
  List<HostelInfo> hostels = [];
  String? selectedHostelId;
  String? selectedHostelName;
  bool hostelsInitialized = false;

  // Month/Year (defaults to current month)
  DateTime _selectedMonthYear = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  DateTime get selectedMonthYear => _selectedMonthYear;

  // Data
  List<RequestModel> _all = [];
  List<RequestModel> get all => _all;
  bool get hasData => _all.isNotEmpty;

  List<OnScreenHistoryItem> currentOnScreen = [];

  // UI filtering
  final TextEditingController filterController = TextEditingController();
  RequestType? _typeFilter;
  RequestType? get typeFilter => _typeFilter;

  WardenHistoryState() {
    filterController.addListener(_applyFilters);
  }

  // Hostels
  void setHostelList(List<HostelInfo> hostels_) {
    hostels = hostels_;
    if (selectedHostelId == null && hostels_.isNotEmpty) {
      selectedHostelId = hostels.first.hostelId;
      selectedHostelName = hostels.first.hostelName;
    }
    hostelsInitialized = true;
    notifyListeners();
  }

  void setSelectedHostelId(String id) {
  final selected = hostels.firstWhere(
    (hostel) => hostel.hostelId == id,
    orElse: () => HostelInfo(hostelId: id, hostelName: 'Unknown'),
  );
  selectedHostelId = selected.hostelId;
  selectedHostelName = selected.hostelName;
  notifyListeners();
}


  // Month/Year
  void setMonthYear(DateTime value) {
    _selectedMonthYear = DateTime(value.year, value.month);
    notifyListeners();
  }

  // Loading/Error
  void setIsLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void setError(bool has, String msg) {
    _isErrored = has;
    _errorMessage = msg;
    notifyListeners();
  }

  // Data
  void setRequests(List<RequestModel> items) {
    _all = items;
    _applyFilters();
  }

  void setTypeFilter(RequestType? value) {
    _typeFilter = value;
    _applyFilters();
  }

  void _applyFilters() {
    final q = filterController.text.trim().toLowerCase();

    Iterable<OnScreenHistoryItem> onScreenRequests = currentOnScreen;

    if (_typeFilter != null) {
      onScreenRequests = onScreenRequests.where(
        (e) => e.request.requestType == _typeFilter,
      );
    }

    if (q.isNotEmpty) {
      onScreenRequests = onScreenRequests.where(
        (e) => (e.student.name).toLowerCase().contains(q),
      );
    }

    currentOnScreen = onScreenRequests
        .map((e) => OnScreenHistoryItem(request: e.request, student: e.student))
        .toList();

    notifyListeners();
  }

  void clearForHostelOrMonthChange() {
    _isErrored = false;
    _errorMessage = '';
    _all = [];
    currentOnScreen = [];
    filterController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }
}
