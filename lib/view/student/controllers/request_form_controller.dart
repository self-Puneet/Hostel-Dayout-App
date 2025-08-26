import 'package:flutter/material.dart';
import '../state/request_form_state.dart';
import '../../../services/request_service.dart';

class RequestFormController {
  final RequestFormState state;
  final BuildContext context;

  RequestFormController({required this.state, required this.context});

  Future<void> fetchOutingRule() async {
    // Simulate fetching from service
    final rule = await RequestService().fetchOutingRule();
    state.setOutingRule(rule);
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
