import 'package:flutter/material.dart';
import '../state/request_form_state.dart';

class RequestFormController {
  final RequestFormState state;
  final BuildContext context;

  RequestFormController({required this.state, required this.context});

  bool validate() {
    if (state.reason.trim().isEmpty) {
      _showSnackBar('Reason cannot be empty');
      return false;
    }
    if (state.fromDateTime == null || state.toDateTime == null) {
      _showSnackBar('Please select both From and To date/time');
      return false;
    }
    if (!state.fromDateTime!.isBefore(state.toDateTime!)) {
      _showSnackBar('From time must be before To time');
      return false;
    }
    if (state.outingRule.isRestricted) {
      _showSnackBar('Outing is restricted today');
      return false;
    }
    if (!state.outingRule.isWithinAllowedTime(state.fromDateTime!) ||
        !state.outingRule.isWithinAllowedTime(state.toDateTime!)) {
      _showSnackBar('Selected time is outside allowed outing window');
      return false;
    }
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> submit() async {
    if (!validate()) return;
    state.setSubmitting(true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate network
    state.setSubmitting(false);
    _showSnackBar('Request submitted successfully!');
  }
}
