// lib/presentation/view/warden/state/warden_action_state.dart
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

// Tab identifiers for the UI/state
enum WardenTab { pendingApproval, approved, pendingParent, requested }

extension WardenTabX on WardenTab {
  static WardenTab fromIndex(int i) => WardenTab.values[i];
  String get label {
    switch (this) {
      case WardenTab.pendingApproval:
        return 'Pending Approval';
      case WardenTab.approved:
        return 'Approved';
      case WardenTab.pendingParent:
        return 'Pending Parent';
      case WardenTab.requested:
        return 'Requested';
    }
  }
}

class OnScreenRequest {
  final RequestModel request;
  final StudentProfileModel student;
  final bool isActioning;
  final bool isSelected;

  OnScreenRequest({
    required this.student,
    required this.request,
    this.isActioning = false,
    this.isSelected = false,
  });

  OnScreenRequest copyWith({
    RequestModel? request,
    bool? isActioning,
    bool? isSelected,
  }) {
    return OnScreenRequest(
      student: student,
      request: request ?? this.request,
      isActioning: isActioning ?? this.isActioning,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory OnScreenRequest.fromRequest((RequestModel, StudentProfileModel) tuple) {
    final (request, student) = tuple;
    return OnScreenRequest(
      request: request,
      student: student,
    );
  }
}

class WardenActionState extends ChangeNotifier {
  bool _isLoading = false;
  bool _isErrored = false;
  bool _isActioning = false;
  String _errorMessage = '';

  // Selection
  final Set<String> _selectedIds = {};

  // Hostels
  List<String> hostelIds = [];
  String? selectedHostelId;
  bool hostelsInitialized = false;

  // Tabs
  WardenTab _currentTab = WardenTab.pendingApproval;
WardenTab get currentTab => _currentTab;

  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  bool get isActioning => _isActioning;
  String get errorMessage => _errorMessage;

  // Selection is valid only on Pending Approval
  bool get hasSelection =>
      _currentTab == WardenTab.pendingApproval && _selectedIds.isNotEmpty;

  List<(RequestModel, StudentProfileModel)> _allRequests = [];
  List<(RequestModel, StudentProfileModel)> get allRequests => _allRequests;
  bool get hasData => _allRequests.isNotEmpty;

  List<OnScreenRequest> currentOnScreenRequests = [];
  List<RequestModel> selectedRequests = [];

  final TextEditingController filterController = TextEditingController();

  // FIX: constructor name corrected so the filter listener attaches
  WardenActionState() {
    filterController.addListener(_filterRequests);
  }

  void setCurrentTab(WardenTab tab) {
    _currentTab = tab;
    if (tab != WardenTab.pendingApproval) {
      clearSelection();
    }
    _filterRequests();
    notifyListeners();
  }

  // Initialize hostel list and default selection
  void setHostelList(List<String> ids) {
    hostelIds = ids;
    if (selectedHostelId == null && ids.isNotEmpty) {
      selectedHostelId = ids.first;
    }
    hostelsInitialized = true;
    notifyListeners();
  }

  // Select hostel id (does not auto-fetch)
  void setSelectedHostelId(String id) {
    selectedHostelId = id;
    notifyListeners();
  }

  // Clear transient state but keep hostel selection/list
  void resetForHostelChange() {
    _isErrored = false;
    _errorMessage = '';
    _allRequests = [];
    currentOnScreenRequests = [];
    _selectedIds.clear();
    selectedRequests.clear();
    filterController.clear();
    notifyListeners();
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

  void setRequests(List<(RequestModel, StudentProfileModel)> response) {
    _allRequests = response;
    _filterRequests();
  }

  bool isSelectedById(String id) => _selectedIds.contains(id);

  void toggleSelectedById(String id) {
    if (_currentTab != WardenTab.pendingApproval) return;
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    for (var i = 0; i < currentOnScreenRequests.length; i++) {
      final req = currentOnScreenRequests[i];
      final requestId = req.request.requestId;
      if (requestId == id) {
        currentOnScreenRequests[i] = req.copyWith(
          isSelected: _selectedIds.contains(id),
        );
        break;
      }
    }
    selectedRequests = currentOnScreenRequests
        .where((w) => _selectedIds.contains(w.request.requestId))
        .map((w) => w.request)
        .toList();
    notifyListeners();
  }

  void restrictSelectionToIds(Set<String> ids) {
    if (_currentTab != WardenTab.pendingApproval) return;
    _selectedIds.removeWhere((id) => !ids.contains(id));
    for (var i = 0; i < currentOnScreenRequests.length; i++) {
      final req = currentOnScreenRequests[i];
      final id = req.request.requestId;
      currentOnScreenRequests[i] = req.copyWith(
        isSelected: _selectedIds.contains(id),
      );
    }
    selectedRequests = currentOnScreenRequests
        .where((w) => _selectedIds.contains(w.request.requestId))
        .map((w) => w.request)
        .toList();
    notifyListeners();
  }

  void clearSelection() {
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
      (req) => req.request.requestId == id,
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

    if (_allRequests.isEmpty) {
      currentOnScreenRequests = [];
      notifyListeners();
      return;
    }

    final actor = Get.find<LoginSession>().role;

    // Statuses allowed for the active tab and actor
    final allowed = _allowedStatusesForTab(actor, _currentTab);

    Iterable<(RequestModel, StudentProfileModel)> base = _allRequests.where(
      (r) => allowed.contains(r.$1.status),
    );

    if (query.isNotEmpty) {
      base = base.where((r) => (r.$2.name).toLowerCase().contains(query));
    }

    currentOnScreenRequests = base.map((pair) {
      final req = pair.$1;
      final stu = pair.$2;
      return OnScreenRequest(
        request: req,
        student: stu,
        isSelected: _selectedIds.contains(req.requestId),
      );
    }).toList();

    notifyListeners();
  }

  // Map tabs to statuses; adjust per your RequestStatus enum
  Set<RequestStatus> _allowedStatusesForTab(
    TimelineActor actor,
    WardenTab tab,
  ) {
    switch (tab) {
      case WardenTab.pendingApproval:
        return actor == TimelineActor.assistentWarden
            ? {RequestStatus.requested, RequestStatus.cancelledStudent}
            : {RequestStatus.referred, RequestStatus.parentApproved};
      case WardenTab.approved:
        return {RequestStatus.approved};
      case WardenTab.pendingParent:
        return {RequestStatus.parentApproved};
      case WardenTab.requested:
        return {RequestStatus.requested};
    }
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  // Legacy helper retained for external callers if needed
  static bool belongsToActorQueue(RequestStatus s, TimelineActor actor) {
    switch (actor) {
      case TimelineActor.assistentWarden:
        return s == RequestStatus.requested ||
            s == RequestStatus.cancelledStudent;
      case TimelineActor.seniorWarden:
        return s == RequestStatus.referred || s == RequestStatus.parentApproved;
      default:
        return false;
    }
  }

  void notifyListenerMethod() {
    notifyListeners();
  }

  RequestType? _typeFilter;
  RequestType? get typeFilter => _typeFilter;
  void setTypeFilter(RequestType? value) {
    _typeFilter = value;
    _filterRequests();
  }

  // Full clear
  void clearState() {
    _isLoading = false;
    _isErrored = false;
    _isActioning = false;
    _errorMessage = '';
    _allRequests = [];
    currentOnScreenRequests = [];
    _selectedIds.clear();
    selectedRequests.clear();
    _typeFilter = null;
    filterController.clear();
    notifyListeners();
  }
}
