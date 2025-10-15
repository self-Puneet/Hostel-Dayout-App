// lib/state/warden_statistics_state.dart
import 'package:flutter/foundation.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/warden_statistics.dart';

class WardenStatisticsState extends ChangeNotifier {
  // Network/UI
  bool _isLoading = false;
  String? _error;
  WardenStatistics? _stats;

  // Hostel selection
  List<HostelInfo> _hostels = [];
  String? _selectedHostelId;
  String? _selectedHostelName;
  bool _hostelsInitialized = false;

  // Getters for UI
  bool get isLoading => _isLoading;
  String? get error => _error;
  WardenStatistics? get stats => _stats;

  List<HostelInfo> get hostels => _hostels;
  String? get selectedHostelId => _selectedHostelId;
  String? get selectedHostelName => _selectedHostelName;
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

  // void setHostelList(List<HostelInfo> hostels) {
  //   if (_selectedHostelId == null && hostels.isNotEmpty) {
  //     _selectedHostelId = hostels.first.hostelId;
  //     _selectedHostelName = hostels.first.hostelName;
  //   }
  //   print(hostels.length);
  //   hostels.add(HostelInfo(hostelId: "sdf", hostelName: "sdfsdfsdf"));
  //   print(hostels.length);
  //   _hostelsInitialized = true;
  //   notifyListeners();
  // }
  void setHostelList(List<HostelInfo> hostels) {
    _hostels = List<HostelInfo>.from(
      hostels,
    ); // Assign incoming list to private
    if (_selectedHostelId == null && _hostels.isNotEmpty) {
      _selectedHostelId = _hostels.first.hostelId;
      _selectedHostelName = _hostels.first.hostelName;
    }
    // optional: remove this test data now
    // _hostels.add(HostelInfo(hostelId: "sdf", hostelName: "sdfsdfsdf"));
    print(_hostels.length); // Now prints the correct count
    _hostelsInitialized = true;
    notifyListeners();
  }

  void setSelectedHostelId(String id) {
    String name = '';
    hostels.map((hostel) {
      if (hostel.hostelId == id) {
        name = hostel.hostelName;
      }
    });
    _selectedHostelId = id;
    _selectedHostelName = name;
    notifyListeners();
  }

  void resetForHostelChange() {
    _error = null;
    _stats = null;
    _isLoading = false;
    notifyListeners();
  }
}
