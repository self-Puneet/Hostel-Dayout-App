import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class onScreenRequest {
  final RequestModel request;
  final StudentProfileModel student;
  bool isActioning;
  bool isSelected;

  onScreenRequest({
    required this.student,
    required this.request,
    this.isActioning = false,
    this.isSelected = false,
  });

  onScreenRequest copyWith({
    RequestModel? request,
    bool? isActioning,
    bool? isSelected,
  }) {
    return onScreenRequest(
      student: student,
      request: request ?? this.request,
      isActioning: isActioning ?? this.isActioning,
      isSelected: isSelected ?? this.isSelected,
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

  bool get isLoading => _isLoading;
  bool get isErrored => _isErrored;
  bool get isActioning => _isActioning;
  String get errorMessage => _errorMessage;
  bool get hasSelection => _selectedIds.isNotEmpty;

  List<(RequestModel, StudentProfileModel)> _allRequests = [];

  bool get hasData => _allRequests.isNotEmpty;

  List<onScreenRequest> currentOnScreenRequests = [];
  List<RequestModel> selectedRequests = [];

  final TextEditingController filterController = TextEditingController();

  WardenHomeState() {
    filterController.addListener(_filterRequests);
  }

  // NEW: initialize hostel list and default selection.
  void setHostelList(List<String> ids) {
    hostelIds = ids;
    if (selectedHostelId == null && ids.isNotEmpty) {
      selectedHostelId = ids.first;
    }
    // hostelIds.add("value");
    hostelsInitialized = true;
    notifyListeners();
  }

  // NEW: select hostel id (does not auto-fetch, caller decides).
  void setSelectedHostelId(String id) {
    selectedHostelId = id;
    notifyListeners();
  }

  // NEW: clear transient state but keep hostel selection/list.
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

    Iterable<(RequestModel, StudentProfileModel)> base = _allRequests.where(
      (r) => belongsToActorQueue(r.$1.status, actor),
    );

    if (query.isNotEmpty) {
      base = base.where((r) => r.$2.name.toLowerCase().contains(query));
    }

    currentOnScreenRequests = base.map((req) {
      return onScreenRequest(
        request: req.$1,
        student: req.$2,
        isSelected: _selectedIds.contains(req.$1.requestId),
      );
    }).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

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
    // Note: keep hostelIds and selectedHostelId intact only if you want,
    // or reset them here if needed.
    notifyListeners();
  }
}
