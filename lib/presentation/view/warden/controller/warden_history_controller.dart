// lib/presentation/view/warden/controller/warden_history_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_history_state.dart';
import 'package:hostel_mgmt/services/warden_service.dart';

class WardenHistoryPageController {
  final WardenHistoryState state;
  WardenHistoryPageController(this.state);

  void loadHostelsFromSession() {
    final session = Get.find<LoginSession>();
    final hostels = session.hostels ?? [];
    state.setHostelList(hostels);
  }

  Future<void> fetchRequestsFromApi({
    String? hostelId,
    DateTime? monthYear,
  }) async {
    state.setIsLoading(true);
    state.setError(false, '');
    try {
      final session = Get.find<LoginSession>();
      final resolvedHostelId = hostelId ??
          state.selectedHostelId ??
          ((session.hostels?.isNotEmpty ?? false)
              ? session.hostels!.first.hostelId
              : null);

      if (resolvedHostelId == null) {
        state.setError(true, 'No hostel selected for fetching history.');
        return;
      }

      final date = monthYear ?? state.selectedMonthYear;
      final yearMonth =
          '${date.year}-${date.month.toString().padLeft(2, '0')}';

      final result = await WardenService.getRequestsForMonth(
        hostelId: resolvedHostelId,
        yearMonth: yearMonth,
      );

      result.fold(
        (err) => state.setError(true, err),
        (list) => state.setRequests(list),
      );
    } catch (e) {
      state.setError(true, 'Failed to load history: $e');
    } finally {
      state.setIsLoading(false);
    }
  }

  Future<void> pickMonthYear(BuildContext context) async {
    // Built-in Material date picker; user picks any day, only month/year are used downstream.
    final now = DateTime.now();
    final initial = state.selectedMonthYear;
    final first = DateTime(now.year - 5, 1);
    final last = DateTime(now.year + 5, 12);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      initialEntryMode: DatePickerEntryMode.calendar,
      helpText: 'Select month and year',
    );

    if (picked != null) {
      final normalized = DateTime(picked.year, picked.month);
      state.setMonthYear(normalized);
      state.clearForHostelOrMonthChange();
      await fetchRequestsFromApi(monthYear: normalized);
    }
  }
}
