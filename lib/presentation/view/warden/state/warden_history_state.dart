// lib/presentation/view/warden/state/warden_history_state.dart

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

// ================= Enums for Warden History Tabs =================a

enum WardenHistoryTab { all, cancelled, denied, approved }

extension WardenHistoryTabX on WardenHistoryTab {
  static WardenHistoryTab fromIndex(int i) => WardenHistoryTab.values[i];

  String get label {
    switch (this) {
      case WardenHistoryTab.all:
        return 'All';
      case WardenHistoryTab.cancelled:
        return 'Cancelled';
      case WardenHistoryTab.denied:
        return 'Denied';
      case WardenHistoryTab.approved:
        return 'Approved';
    }
  }
}

// ================= Model for on-screen requests =================

class OnScreenRequest {
  final RequestModel request;
  final StudentProfileModel student;

  OnScreenRequest({required this.request, required this.student});

  factory OnScreenRequest.fromRequest(
    (RequestModel, StudentProfileModel) tuple,
  ) {
    final (request, student) = tuple;
    return OnScreenRequest(request: request, student: student);
  }
}

// ========================== STATE CLASS ==========================

class WardenHistoryState extends ChangeNotifier {
  bool _isLoading = false;
  bool _isErrored = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  String get errorMessage => _errorMessage;

  // Hostel information
  List<HostelInfo> hostels = [];
  String? selectedHostelId;
  String? selectedHostelName;
  bool hostelsInitialized = false;

  // Active tab
  WardenHistoryTab _currentTab = WardenHistoryTab.all;
  WardenHistoryTab get currentTab => _currentTab;

  // Request data
  List<(RequestModel, StudentProfileModel)> _allRequests = [];
  List<(RequestModel, StudentProfileModel)> get allRequests => _allRequests;
  List<OnScreenRequest> currentOnScreenRequests = [];

  bool get hasData => _allRequests.isNotEmpty;

  final TextEditingController filterController = TextEditingController();

  // New: Month-Year tracking for history filtering
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;

  WardenHistoryState() {
    filterController.addListener(_filterRequests);
  }

  // ===================== Tab Management =====================

  void setCurrentTab(WardenHistoryTab tab) {
    _currentTab = tab;
    _filterRequests();
    notifyListeners();
  }

  // ===================== Hostel Management =====================

  // void setHostelList(List<HostelInfo> hostelList) {
  //   selectedHostelId ??= hostelList.first.hostelId;
  //   selectedHostelName ??= hostelList.first.hostelName;
  //   hostels = hostelList;
  //   hostelsInitialized = true;
  //   notifyListeners();
  // }

  void setHostelList(List<HostelInfo> list) {
    // Store the list used by the UI
    hostels = List<HostelInfo>.from(list);

    // Keep selection valid relative to current list
    final hasMatch = hostels.any((h) => h.hostelId == selectedHostelId);
    if (!hasMatch) {
      if (hostels.isNotEmpty) {
        selectedHostelId = hostels.first.hostelId;
        selectedHostelName = hostels.first.hostelName;
      } else {
        selectedHostelId = null;
        selectedHostelName = null;
      }
    }

    hostelsInitialized = true;
    notifyListeners();
  }

  void setSelectedHostelId(String id, String name) {
    selectedHostelId = id;
    selectedHostelName = name;
    notifyListeners();
  }

  void resetForHostelChange() {
    _isErrored = false;
    _errorMessage = '';
    _allRequests = [];
    currentOnScreenRequests = [];
    filterController.clear();
    notifyListeners();
  }

  // ===================== Month-Year Management =====================

  void setMonthYear(int month, int year) {
    if (_selectedMonth != month || _selectedYear != year) {
      _selectedMonth = month;
      _selectedYear = year;
      _allRequests.clear();
      currentOnScreenRequests.clear();
      notifyListeners();
    }
  }

  // ===================== Basic State Setters =====================

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(bool hasError, String message) {
    _isErrored = hasError;
    _errorMessage = message;
    notifyListeners();
  }

  void setRequests(List<(RequestModel, StudentProfileModel)> requests) {
    _allRequests = requests;
    _filterRequests();
  }

  // ===================== Filtering =====================

  void _filterRequests() {
    final query = filterController.text.trim().toLowerCase();

    if (_allRequests.isEmpty) {
      currentOnScreenRequests = [];
      notifyListeners();
      return;
    }

    final actor = Get.find<LoginSession>().role;
    final allowed = allowedStatusesForTab(actor, _currentTab);

    Iterable<(RequestModel, StudentProfileModel)> base = _allRequests.where(
      (r) => allowed.contains(r.$1.status),
    );

    if (query.isNotEmpty) {
      base = base.where((r) => (r.$2.name).toLowerCase().contains(query));
    }

    currentOnScreenRequests = base
        .map((pair) => OnScreenRequest(request: pair.$1, student: pair.$2))
        .toList();

    notifyListeners();
  }

  Set<RequestStatus> allowedStatusesForTab(
    TimelineActor actor,
    WardenHistoryTab tab,
  ) {
    switch (tab) {
      case WardenHistoryTab.all:
        return RequestStatus.values.toSet(); // Shows all requests
      case WardenHistoryTab.cancelled:
        return {RequestStatus.cancelledStudent};
      case WardenHistoryTab.denied:
        return {
          RequestStatus.parentDenied,
          RequestStatus.cancelled,
          RequestStatus.rejected,
        };
      case WardenHistoryTab.approved:
        return {RequestStatus.approved};
    }
  }

  // ===================== Utilities =====================

  void clearState() {
    _isLoading = false;
    _isErrored = false;
    _errorMessage = '';
    _allRequests = [];
    currentOnScreenRequests = [];
    filterController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  void notifyListenerMethod() {
    notifyListeners();
  }

  List<OnScreenRequest> buildListForTab(
    TimelineActor actor,
    WardenHistoryTab tab,
  ) {
    final query = filterController.text.trim().toLowerCase();

    if (_allRequests.isEmpty) return [];

    final allowed = allowedStatusesForTab(actor, tab);
    Iterable<(RequestModel, StudentProfileModel)> base = _allRequests.where(
      (r) => allowed.contains(r.$1.status),
    );

    if (query.isNotEmpty) {
      base = base.where(
        (r) =>
            (r.$2.name.toLowerCase().contains(query)) ||
            (r.$2.enrollmentNo.toLowerCase().contains(query)),
      );
    }

    return base
        .map((pair) => OnScreenRequest(request: pair.$1, student: pair.$2))
        .toList();
  }
}
