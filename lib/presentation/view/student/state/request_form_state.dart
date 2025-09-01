import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/outing_rule_model.dart';

class RequestFormState extends ChangeNotifier {
  String reason = '';
  DateTime? fromDateTime;
  DateTime? toDateTime;
  bool isSubmitting = false;
  bool isLoadingRules = true;
  OutingRule? loadedOutingRule;

  bool isFromDateTimeValid = true;
  bool isToDateTimeValid = true;
  bool canSubmit = false;
  bool error = false; // <-- global error flag
  String errorReason = '';

  RequestFormState();

  void setReason(String value) {
    reason = value;
    // _silentValidate();
    notifyListeners();
  }

  void setFromDateTime(DateTime? value) {
    fromDateTime = value;
    // _silentValidate();
    notifyListeners();
  }

  void setToDateTime(DateTime? value) {
    toDateTime = value;
    // _silentValidate();
    notifyListeners();
  }

  void setSubmitting(bool value) {
    isSubmitting = value;
    if (value) {
      _fullValidate(); // show errors on submit
    }
    notifyListeners();
  }

  void setOutingRule(OutingRule rule) {
    loadedOutingRule = rule;
    if (rule.isRestricted) {
      // error = true;
      canSubmit = false;
      // errorReason = 'Outing is restricted today.';
    }
    isLoadingRules = false;
    // _silentValidate();
    notifyListeners();
  }

  // ================== Validation Helpers ==================

  bool _validateReason({bool silent = false}) {
    print("Validating reason: $reason");
    if (reason.trim().isEmpty) {
      if (!silent) _setError('Reason cannot be empty.');
      return false;
    }
    return true;
  }

  bool _validateFromDateTime({bool silent = false}) {
    final now = DateTime.now();
    if (fromDateTime == null) {
      if (!silent) _setError('Please select From date/time.');
      return false;
    }
    if (!fromDateTime!.isAfter(now)) {
      if (!silent) _setError('From time must be in the future.');
      return false;
    }
    if (!loadedOutingRule!.isWithinAllowedTime(fromDateTime!)) {
      if (!silent)
        _setError('Selected From time is outside allowed outing window.');
      return false;
    }
    return true;
  }

  bool _validateToDateTime({bool silent = false}) {
    final now = DateTime.now();
    if (toDateTime == null) {
      if (!silent) _setError('Please select To date/time.');
      return false;
    }
    if (!toDateTime!.isAfter(now)) {
      if (!silent) _setError('To time must be in the future.');
      return false;
    }
    if (!loadedOutingRule!.isWithinAllowedTime(toDateTime!)) {
      if (!silent)
        _setError('Selected To time is outside allowed outing window.');
      return false;
    }
    return true;
  }

  bool _validateOrder({bool silent = false}) {
    if (fromDateTime != null &&
        toDateTime != null &&
        !fromDateTime!.isBefore(toDateTime!)) {
      if (!silent) _setError('From time must be before To time.');
      return false;
    }
    return true;
  }

  // bool _validateOutingRule({bool silent = false}) {
  //   if (loadedOutingRule == null) return true;

  //   if (loadedOutingRule!.isRestricted) {
  //     if (!silent) _setError('Outing is restricted today.');
  //     return false;
  //   }

  //   if (!loadedOutingRule!.isUnrestricted &&
  //       fromDateTime != null &&
  //       toDateTime != null) {
  //     if (!loadedOutingRule!.isWithinAllowedTime(fromDateTime!) ||
  //         !loadedOutingRule!.isWithinAllowedTime(toDateTime!)) {
  //       if (!silent)
  //         _setError('Selected time is outside allowed outing window.');
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  // ================== Full Validation (on submit) ==================
  void _fullValidate() {
    error = false; // reset
    errorReason = '';

    // isReason = _validateReason();
    isFromDateTimeValid = _validateFromDateTime();
    isToDateTimeValid = _validateToDateTime();

    bool reasonValid = _validateReason();
    bool orderValid = _validateOrder();
    // bool ruleValid = _validateOutingRule();

    canSubmit =
        isFromDateTimeValid && isToDateTimeValid && reasonValid && orderValid;
    // ruleValid;

    // if any invalid → error = true
    if (!canSubmit) {
      error = true;
      isSubmitting = false; // stop submitting if errors
    }
  }

  // ================== Error Setter ==================
  void _setError(String message) {
    error = true;
    errorReason = message;
  }
}
