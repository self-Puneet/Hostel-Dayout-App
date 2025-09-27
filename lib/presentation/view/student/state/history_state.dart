// lib/presentation/view/student/state/history_state.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/services/history_service.dart';
import 'package:intl/intl.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';

class HistoryState extends ChangeNotifier {
  bool isLoading = false;
  bool isErrored = false;
  String errorMessage = '';

  // Tabs
  List<String> filterOptions = const ["All", "Cancelled", "Accepted", "Rejected"];
  String selectedFilter = 'All';

  // Data
  final RequestService _service = RequestService();
  List<RequestModel> allRequests = [];

  // UI state: month expansion map
  Map<String, bool> isMonthExpanded = {};

  Future<void> load() async {
    updateLoadingState(true);
    try {
      allRequests = await _service.fetchDemoRequests();
      _initMonthExpansion(allRequests);
      updateErrorState(false, '');
    } catch (e) {
      updateErrorState(true, e.toString());
    } finally {
      updateLoadingState(false);
    }
  }

  // Grouping helpers
  String monthKey(DateTime d) => DateFormat('MMMM yyyy').format(d);
  DateTime parseMonthKey(String key) => DateFormat('MMMM yyyy').parse(key);

  Map<String, List<RequestModel>> groupByMonth(List<RequestModel> items) {
    final map = <String, List<RequestModel>>{};
    for (final r in items) {
      final key = monthKey(r.appliedFrom);
      map.putIfAbsent(key, () => []).add(r);
    }
    // Sort each month's items by date desc
    for (final list in map.values) {
      list.sort((a, b) => b.appliedFrom.compareTo(a.appliedFrom));
    }
    return map;
  }

  List<String> sortedMonthKeys(Iterable<String> keys) {
    final list = keys.toList();
    list.sort((a, b) => parseMonthKey(b).compareTo(parseMonthKey(a)));
    return list;
  }

  Map<String, List<RequestModel>> groupedForFilter(String filter) {
    final list = _filteredList(filter);
    return groupByMonth(list);
  }

  List<RequestModel> _filteredList(String filter) {
    switch (filter) {
      case 'Cancelled':
        return allRequests.where((r) =>
          r.status == RequestStatus.cancelled ||
          r.status == RequestStatus.cancelledStudent).toList();
      case 'Accepted':
        return allRequests.where((r) => r.status == RequestStatus.approved).toList();
      case 'Rejected':
        return allRequests.where((r) =>
          r.status == RequestStatus.rejected ||
          r.status == RequestStatus.parentDenied).toList();
      case 'All':
      default:
        return allRequests;
    }
  }

  void _initMonthExpansion(List<RequestModel> list) {
    final keys = list.map((r) => monthKey(r.appliedFrom)).toSet();
    isMonthExpanded = { for (final k in keys) k: false }; // All folded initially
    notifyListeners();
  }

  void setMonthExpanded(String key, bool expanded) {
    isMonthExpanded[key] = expanded;
    notifyListeners();
  }

  // Boilerplate updates
  void updateLoadingState(bool value) { isLoading = value; notifyListeners(); }
  void updateErrorState(bool errored, String message) { isErrored = errored; errorMessage = message; notifyListeners(); }
  void updateFilterOptions(List<String> options) {
    filterOptions = options;
    if (!options.contains(selectedFilter)) {
      selectedFilter = options.isNotEmpty ? options.first : '';
    }
    notifyListeners();
  }
  void updateSelectedFilter(String filter) { selectedFilter = filter; notifyListeners(); }
  
}
