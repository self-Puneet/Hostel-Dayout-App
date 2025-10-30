// lib/presentation/view/warden/state/warden_action_state.dart

import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_layout_state.dart';

// Tab identifiers for the UI/state
enum WardenTab { pendingApproval, approved, pendingParent, requested }

extension WardenTabX on WardenTab {
  static WardenTab fromIndex(int i) => WardenTab.values[i];
  String label(TimelineActor actor) {
    switch (this) {
      case WardenTab.pendingApproval:
        return 'Pending Approval';
      case WardenTab.approved:
        return 'Approved';
      case WardenTab.pendingParent:
        return 'Pending Parent';
      case WardenTab.requested:
        return (actor == TimelineActor.seniorWarden)
            ? 'Requested'
            : 'Parent Approved';
    }
  }
}

// Request model shown to the warden
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

  factory OnScreenRequest.fromRequest(
    (RequestModel, StudentProfileModel) tuple,
  ) {
    final (request, student) = tuple;
    return OnScreenRequest(request: request, student: student);
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
  List<HostelInfo> hostels = [];
  String? selectedHostelId;
  String? selectedHostelName;
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

  // Search + type filters
  final TextEditingController filterController = TextEditingController();

  RequestType? _typeFilter;
  RequestType? get typeFilter => _typeFilter;

  // NEW: Selection transition callbacks
  VoidCallback? _onFirstSelected;
  VoidCallback? _onNoneSelected;

  final WardenLayoutState layoutState;

  // Constructor: attach search listener
  WardenActionState(this.layoutState) {
    filterController.addListener(_notifyForFilter);
  }

  void _notifyForFilter() {
    // Rebuild lists on search change
    notifyListeners();
  }

  // NEW: Register callbacks for selection transitions
  void setSelectionCallbacks({
    VoidCallback? onFirstSelected,
    VoidCallback? onNoneSelected,
  }) {
    _onFirstSelected = onFirstSelected;
    _onNoneSelected = onNoneSelected;
  }

  // ===========================================================================================

  // NEW: Bulk action callback
  Future<void> Function({required RequestAction action})? _onBulkAction;

  // NEW: Register bulk action callback
  void setBulkActionCallback(
    Future<void> Function({required RequestAction action})? callback,
  ) {
    _onBulkAction = callback;
  }

  // NEW: Trigger bulk action from anywhere (called from layout)
  Future<void> triggerBulkAction({required RequestAction action}) async {
    if (_onBulkAction != null) {
      print("ok right path !");
      await _onBulkAction!(action: action);
      layoutState.hideActionsOverlay();
    }
  }

  // ===========================================================================================

  void setCurrentTab(WardenTab tab) {
    _currentTab = tab;
    if (tab != WardenTab.pendingApproval) {
      clearSelection();
    }
    notifyListeners();
  }

  // Initialize hostel list and default selection
  void setHostelList(List<HostelInfo> hostel) {
    selectedHostelId ??= hostel.first.hostelId;
    selectedHostelName ??= hostel.first.hostelName;
    // hostel.add(HostelInfo(hostelId: "sdfsdf", hostelName: "sdfsdf"));
    hostelsInitialized = true;
    notifyListeners();
  }

  // Select hostel id (does not auto-fetch)
  void setSelectedHostelId(String id, String name) {
    selectedHostelId = id;
    selectedHostelName = name;
    notifyListeners();
  }

  // Clear transient state but keep hostel selection/list
  void resetForHostelChange() {
    _isErrored = false;
    _errorMessage = '';
    _allRequests = [];
    _selectedIds.clear();
    _typeFilter = null;
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
    notifyListeners();
  }

  // Replace updated request inside _allRequests and notify
  void updateRequestInAll(RequestModel updated) {
    final idx = _allRequests.indexWhere(
      (t) => t.$1.requestId == updated.requestId,
    );
    if (idx != -1) {
      final (_, stu) = _allRequests[idx];
      _allRequests[idx] = (updated, stu);
      notifyListeners();
    }
  }

  bool isSelectedById(String id) => _selectedIds.contains(id);

  void toggleSelectedById(String id) {
    if (_currentTab != WardenTab.pendingApproval) return;

    final hadSelection = _selectedIds.isNotEmpty;

    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }

    final hasSelectionNow = _selectedIds.isNotEmpty;

    // Trigger callbacks on transitions
    if (!hadSelection && hasSelectionNow) {
      // 0 → 1 transition (first selected)
      _onFirstSelected?.call();
    } else if (hadSelection && !hasSelectionNow) {
      // 1 → 0 transition (none selected)
      _onNoneSelected?.call();
    }

    notifyListeners();
  }

  void restrictSelectionToIds(Set<String> ids) {
    if (_currentTab != WardenTab.pendingApproval) return;

    final hadSelection = _selectedIds.isNotEmpty;
    _selectedIds.removeWhere((id) => !ids.contains(id));
    final hasSelectionNow = _selectedIds.isNotEmpty;

    // Check transition after restriction
    if (hadSelection && !hasSelectionNow) {
      _onNoneSelected?.call();
    }

    notifyListeners();
  }

  void clearSelection() {
    final hadSelection = _selectedIds.isNotEmpty;
    _selectedIds.clear();

    if (hadSelection) {
      _onNoneSelected?.call();
    }

    layoutState.hideActionsOverlay();

    notifyListeners();
  }

  void setIsActioningbyId(String id, bool value) {
    // Kept for interface compatibility; item-level spinners can be derived by mapping if needed.
    _isActioning = value;
    notifyListeners();
  }

  // Build filtered lists on demand (single source of truth: _allRequests)
  List<OnScreenRequest> buildListForStatuses(Set<RequestStatus> statuses) {
    final query = filterController.text.trim().toLowerCase();
    if (_allRequests.isEmpty) return [];

    Iterable<(RequestModel, StudentProfileModel)> base = _allRequests.where(
      (r) => statuses.contains(r.$1.status),
    );

    if (_typeFilter != null) {
      base = base.where((r) => r.$1.requestType == _typeFilter);
    }

    if (query.isNotEmpty) {
      base = base.where((r) => (r.$2.name).toLowerCase().contains(query));
    }

    return base.map((pair) {
      final req = pair.$1;
      final stu = pair.$2;
      final selected = _selectedIds.contains(req.requestId);
      // Selection only matters on Pending; harmless elsewhere.
      return OnScreenRequest(
        request: req,
        student: stu,
        isSelected: selected && _currentTab == WardenTab.pendingApproval,
      );
    }).toList();
  }

  List<OnScreenRequest> buildListForStatus(RequestStatus status) {
    return buildListForStatuses({status});
  }

  // Map tabs to statuses
  Set<RequestStatus> allowedForTab(TimelineActor actor, WardenTab tab) {
    switch (tab) {
      case WardenTab.pendingApproval:
        return actor == TimelineActor.assistentWarden
            ? {RequestStatus.requested}
            : {RequestStatus.parentApproved};
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

  void setTypeFilter(RequestType? value) {
    _typeFilter = value;
    notifyListeners();
  }

  // Full clear
  void clearState() {
    final hadSelection = _selectedIds.isNotEmpty;

    _isLoading = false;
    _isErrored = false;
    _isActioning = false;
    _errorMessage = '';
    _allRequests = [];
    _selectedIds.clear();
    _typeFilter = null;
    filterController.clear();

    if (hadSelection) {
      _onNoneSelected?.call();
    }

    notifyListeners();
  }
}
