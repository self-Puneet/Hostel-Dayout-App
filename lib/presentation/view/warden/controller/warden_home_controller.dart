// lib/controllers/warden_statistics_controller.dart
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/warden_statistics.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/services/warden_service.dart';

class WardenStatisticsController {
  final WardenStatisticsState state;

  WardenStatisticsController(this.state);

  // Initialize hostels from session and auto-fetch if possible
  Future<void> initFromSession() async {
    final session = Get.find<LoginSession>();
    final hostels = session.hostels ?? [];
    // print(hostels.length);
    // print("aaaaaaaaaaaaaaaaaaaaaah");
    hostels.map((hostel) {
      print('${hostel.hostelId} ${hostel.hostelName}');
    });
    state.setHostelList(hostels);
    if (state.selectedHostelId != null) {
      await _fetchFor(state.selectedHostelId!, session.token);
    }
  }

  // Dropdown selection handler (called by UI)
  Future<void> selectHostel(String id, String name) async {
    final session = Get.find<LoginSession>();
    state.setSelectedHostelId(id);
    state.resetForHostelChange();
    await _fetchFor(id, session.token);
  }

  // Pull-to-refresh
  Future<void> refresh() async {
    final session = Get.find<LoginSession>();
    final id = state.selectedHostelId;
    if (id == null) return;
    await _fetchFor(id, session.token);
  }

  // Centralized fetch with Either handling
  Future<void> _fetchFor(String hostelCode, String token) async {
    state.setLoading(true);
    state.setError(null);
    final Either<String, WardenStatistics> either =
        await WardenService.fetchStatistics(
          hostelCode: hostelCode,
          token: token,
        );
    either.fold(
      (err) {
        state.setStats(null);
        state.setError(err);
      },
      (stats) {
        state.setStats(stats);
        state.setError(null);
      },
    );
    state.setLoading(false);
  }

  // Card taps (future navigation/side-effects)
  void onCardTap(String cardId) {
    // e.g., Get.toNamed('/$cardId', arguments: ...);
  }
}
