// import 'package:flutter/material.dart';
// import 'package:hostel_mgmt/models/outing_rule_model.dart';
// import 'package:hostel_mgmt/services/profile_service.dart';
// import '../state/request_form_state.dart';
// // import '../../../services/request_service.dart';

// class RequestFormController {
//   final RequestFormState state;
//   final BuildContext context;

//   RequestFormController({required this.state, required this.context});

//   Future<void> fetchOutingRule() async {
//     state.isLoadingRules = true;
//     // Fetch hostel info using ProfileService
//     final result = await ProfileService.getHostelInfo();
//     result.fold(
//       (error) {
//         state.setOutingRule(OutingRule.restricted());
//         state.isLoadingRules = false;
//       },
//       (hostelResponse) {
//         final rule = hostelResponse.hostel.toOutingRule();
//         state.setOutingRule(rule);
//         state.isLoadingRules = false;
//       },
//     );
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }

//   Future<void> submit() async {
//     // if (!validate()) return;
//     state.setSubmitting(true);
//     if (state.error == true) return;
//     await Future.delayed(const Duration(seconds: 2)); // Simulate network
//     state.setSubmitting(false);
//     _showSnackBar('Request submitted successfully!');
//     // go.rout
//   }
// }

// controllers/request_form_controller.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
// import 'package:intl/intl.dart';
import '../state/request_form_state.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import 'package:hostel_mgmt/models/outing_rule_model.dart';
import 'package:hostel_mgmt/services/request_service.dart';

class RequestFormController {
  final RequestFormState state;
  final BuildContext context;

  RequestFormController({required this.state, required this.context});

  Future<void> fetchOutingRule() async {
    state.isLoadingRules = true;
    final result = await ProfileService.getHostelInfo();
    result.fold(
      (error) => state.setOutingRule(OutingRule.restricted()),
      (hostelResponse) =>
          state.setOutingRule(hostelResponse.hostel.toOutingRule()),
    );
  }

  Future<void> submit() async {
    state.validateAndMarkSubmitted();
    if (!state.canSubmit) {
      _showSnackBar('Please fix the errors');
      return;
    }

    final from = state.fromDateTime!;
    final to = state.toDateTime!;
    final payload = <String, dynamic>{
      'request_type': _mapRequestType(state.selectedType),
      'applied_from': from.toUtc().toIso8601String().split('.').first+'Z',
      'applied_to': to.toUtc().toIso8601String().split('.').first+'Z',
      'reason': state.reason.trim(),
    };

    state.setSubmitting(true);
    try {
      final result = await RequestService.createRequest(requestData: payload);
      result.fold((err) => _showSnackBar(err.toString()), (_) {
        _showSnackBar('Request submitted successfully!');
      });
    } catch (_) {
      _showSnackBar('Something went wrong');
    } finally {
      state.setSubmitting(false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _mapRequestType(RequestType t) {
    return t == RequestType.dayout ? 'outing' : 'outing';
  }

  // 2025-06-12T10:00:00Z
  // String _toZulu(DateTime dt) {
  //   return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dt.toUtc());
  // }
}
