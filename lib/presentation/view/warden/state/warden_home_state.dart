// lib/state/warden_statistics_state.dart
import 'package:flutter/foundation.dart';
import 'package:hostel_mgmt/models/warden_statistics.dart';

class WardenStatisticsState extends ChangeNotifier {
  // Network/UI
  bool _isLoading = false;
  String? _error;
  WardenStatistics? _stats;

  // Hostel selection
  List<String> _hostelIds = [];
  String? _selectedHostelId;
  bool _hostelsInitialized = false;

  // Getters for UI
  bool get isLoading => _isLoading;
  String? get error => _error;
  WardenStatistics? get stats => _stats;

  List<String> get hostelIds => _hostelIds;
  String? get selectedHostelId => _selectedHostelId;
  bool get hostelsInitialized => _hostelsInitialized;

  // Setters used ONLY by controller
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _error = message;
    notifyListeners();
  }

  void setStats(WardenStatistics? s) {
    _stats = s;
    notifyListeners();
  }

  void setHostelList(List<String> ids) {
    _hostelIds = ids;
    if (_selectedHostelId == null && ids.isNotEmpty) {
      _selectedHostelId = ids.first;
    }
    // hostelIds.add("value");
    _hostelsInitialized = true;
    notifyListeners();
  }

  void setSelectedHostelId(String id) {
    _selectedHostelId = id;
    notifyListeners();
  }

  void resetForHostelChange() {
    _error = null;
    _stats = null;
    _isLoading = false;
    notifyListeners();
  }
}
