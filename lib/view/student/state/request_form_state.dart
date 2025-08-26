import 'package:flutter/material.dart';
import '../../../models/outing_rule_model.dart';

class RequestFormState extends ChangeNotifier {
  String reason = '';
  DateTime? fromDateTime;
  DateTime? toDateTime;
  bool isSubmitting = false;
  final OutingRule outingRule;

  RequestFormState({required this.outingRule});

  void setReason(String value) {
    reason = value;
    notifyListeners();
  }

  void setFromDateTime(DateTime? value) {
    fromDateTime = value;
    notifyListeners();
  }

  void setToDateTime(DateTime? value) {
    toDateTime = value;
    notifyListeners();
  }

  void setSubmitting(bool value) {
    isSubmitting = value;
    notifyListeners();
  }
}
