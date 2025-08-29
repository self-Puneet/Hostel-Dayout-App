import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/outing_rule_model.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import '../state/request_form_state.dart';
// import '../../../services/request_service.dart';

class RequestFormController {
  final RequestFormState state;
  final BuildContext context;

  RequestFormController({required this.state, required this.context});

  Future<void> fetchOutingRule() async {
    state.isLoadingRules = true;
    // Fetch hostel info using ProfileService
    final result = await ProfileService.getHostelInfo();
    result.fold(
      (error) {
        state.setOutingRule(OutingRule.restricted());
        state.isLoadingRules = false;
      },
      (hostelResponse) {
        final rule = hostelResponse.hostel.toOutingRule();
        state.setOutingRule(rule);
        state.isLoadingRules = false;
      },
    );
    state.notifyListeners();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> submit() async {
    // if (!validate()) return;
    state.setSubmitting(true);
    if (state.error == true) return;
    await Future.delayed(const Duration(seconds: 2)); // Simulate network
    state.setSubmitting(false);
    _showSnackBar('Request submitted successfully!');
    // go.rout
  }
}
