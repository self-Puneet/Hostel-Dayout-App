// import 'package:flutter/material.dart';
// import 'package:hostel_mgmt/core/enums/request_type.dart';
// import 'package:hostel_mgmt/models/outing_rule_model.dart';

// class RequestFormState extends ChangeNotifier {
//   String reason = '';
//   DateTime? fromDateTime;
//   DateTime? toDateTime;
//   bool isSubmitting = false;
//   bool isLoadingRules = true;
//   OutingRule? loadedOutingRule;
//   final RequestType requestType = RequestType.dayout;

//   bool isFromDateTimeValid = true;
//   bool isToDateTimeValid = true;
//   bool canSubmit = false;
//   bool error = false; // <-- global error flag
//   String errorReason = '';

//   RequestFormState();

//   void setReason(String value) {
//     reason = value;
//     // _silentValidate();
//     notifyListeners();
//   }

//   void setFromDateTime(DateTime? value) {
//     fromDateTime = value;
//     // _silentValidate();
//     notifyListeners();
//   }

//   void setToDateTime(DateTime? value) {
//     toDateTime = value;
//     // _silentValidate();
//     notifyListeners();
//   }

//   void setSubmitting(bool value) {
//     isSubmitting = value;
//     if (value) {
//       _fullValidate(); // show errors on submit
//     }
//     notifyListeners();
//   }

//   void setOutingRule(OutingRule rule) {
//     loadedOutingRule = rule;
//     if (rule.isRestricted) {
//       // error = true;
//       canSubmit = false;
//       // errorReason = 'Outing is restricted today.';
//     }
//     isLoadingRules = false;
//     // _silentValidate();
//     notifyListeners();
//   }

//   // ================== Validation Helpers ==================

//   bool _validateReason({bool silent = false}) {
//     print("Validating reason: $reason");
//     if (reason.trim().isEmpty) {
//       if (!silent) _setError('Reason cannot be empty.');
//       return false;
//     }
//     return true;
//   }

//   bool _validateFromDateTime({bool silent = false}) {
//     final now = DateTime.now();
//     if (fromDateTime == null) {
//       if (!silent) _setError('Please select From date/time.');
//       return false;
//     }
//     if (!fromDateTime!.isAfter(now)) {
//       if (!silent) _setError('From time must be in the future.');
//       return false;
//     }
//     if (!loadedOutingRule!.isWithinAllowedTime(fromDateTime!)) {
//       if (!silent)
//         _setError('Selected From time is outside allowed outing window.');
//       return false;
//     }
//     return true;
//   }

//   bool _validateToDateTime({bool silent = false}) {
//     final now = DateTime.now();
//     if (toDateTime == null) {
//       if (!silent) _setError('Please select To date/time.');
//       return false;
//     }
//     if (!toDateTime!.isAfter(now)) {
//       if (!silent) _setError('To time must be in the future.');
//       return false;
//     }
//     if (!loadedOutingRule!.isWithinAllowedTime(toDateTime!)) {
//       if (!silent)
//         _setError('Selected To time is outside allowed outing window.');
//       return false;
//     }
//     return true;
//   }

//   bool _validateOrder({bool silent = false}) {
//     if (fromDateTime != null &&
//         toDateTime != null &&
//         !fromDateTime!.isBefore(toDateTime!)) {
//       if (!silent) _setError('From time must be before To time.');
//       return false;
//     }
//     return true;
//   }

//   // bool _validateOutingRule({bool silent = false}) {
//   //   if (loadedOutingRule == null) return true;

//   //   if (loadedOutingRule!.isRestricted) {
//   //     if (!silent) _setError('Outing is restricted today.');
//   //     return false;
//   //   }

//   //   if (!loadedOutingRule!.isUnrestricted &&
//   //       fromDateTime != null &&
//   //       toDateTime != null) {
//   //     if (!loadedOutingRule!.isWithinAllowedTime(fromDateTime!) ||
//   //         !loadedOutingRule!.isWithinAllowedTime(toDateTime!)) {
//   //       if (!silent)
//   //         _setError('Selected time is outside allowed outing window.');
//   //       return false;
//   //     }
//   //   }
//   //   return true;
//   // }

//   // ================== Full Validation (on submit) ==================
//   void _fullValidate() {
//     error = false; // reset
//     errorReason = '';

//     // isReason = _validateReason();
//     isFromDateTimeValid = _validateFromDateTime();
//     isToDateTimeValid = _validateToDateTime();

//     bool reasonValid = _validateReason();
//     bool orderValid = _validateOrder();
//     // bool ruleValid = _validateOutingRule();

//     canSubmit =
//         isFromDateTimeValid && isToDateTimeValid && reasonValid && orderValid;
//     // ruleValid;

//     // if any invalid → error = true
//     if (!canSubmit) {
//       error = true;
//       isSubmitting = false; // stop submitting if errors
//     }
//   }

//   // ================== Error Setter ==================
//   void _setError(String message) {
//     error = true;
//     errorReason = message;
//   }
// }
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/models/outing_rule_model.dart';


class RequestFormState extends ChangeNotifier {
  // Request type (affects rule enforcement)
  RequestType selectedType = RequestType.dayout;

  // Inputs
  String reason = '';
  DateTime? fromDate;
  TimeOfDay? fromTime;
  DateTime? toDate;
  TimeOfDay? toTime;

  // Async/rule
  bool isSubmitting = false;
  bool isLoadingRules = true;
  OutingRule? loadedOutingRule;

  // UX flags
  bool reasonTouched = false;
  bool fromDateTouched = false;
  bool fromTimeTouched = false;
  bool toDateTouched = false;
  bool toTimeTouched = false;
  bool submittedOnce = false;

  // Errors
  String? reasonError;
  String? fromDateError;
  String? fromTimeError;
  String? toDateError;
  String? toTimeError;
  String? generalError;

  // Derived: show errors only after interaction or first submit
  String? get uiReasonError => (reasonTouched || submittedOnce) ? reasonError : null;
  String? get uiFromDateError => (fromDateTouched || submittedOnce) ? fromDateError : null;
  String? get uiFromTimeError => (fromTimeTouched || submittedOnce) ? fromTimeError : null;
  String? get uiToDateError => (toDateTouched || submittedOnce) ? toDateError : null;
  String? get uiToTimeError => (toTimeTouched || submittedOnce) ? toTimeError : null;

  // Combine
  DateTime? get fromDateTime => (fromDate != null && fromTime != null)
      ? DateTime(fromDate!.year, fromDate!.month, fromDate!.day, fromTime!.hour, fromTime!.minute)
      : null;

  DateTime? get toDateTime => (toDate != null && toTime != null)
      ? DateTime(toDate!.year, toDate!.month, toDate!.day, toTime!.hour, toTime!.minute)
      : null;

  bool get isRuleLoaded => !isLoadingRules && loadedOutingRule != null;
  bool get isRestricted => loadedOutingRule?.isRestricted == true;

  bool get canSubmit {
    final fieldsOk = reason.trim().isNotEmpty &&
        fromDateTime != null &&
        toDateTime != null &&
        reasonError == null &&
        fromDateError == null &&
        fromTimeError == null &&
        toDateError == null &&
        toTimeError == null;
    if (!fieldsOk || isSubmitting) return false;
    if (selectedType == RequestType.leave) return true;
    if (!isRuleLoaded || isRestricted) return false;
    return true;
  }

  // Mutators
  void setRequestType(RequestType v) {
    selectedType = v;
    _validateAll(silent: true);
    notifyListeners();
  }

  void setReason(String v) {
    reason = v;
    reasonTouched = true;
    _validateReason(silent: true);
    notifyListeners();
  }

  void setFromDate(DateTime? v) {
    fromDate = v;
    fromDateTouched = true;
    _validateFromDate(silent: true);
    _validateOrder(silent: true);
    notifyListeners();
  }

  void setFromTime(TimeOfDay? v) {
    fromTime = v;
    fromTimeTouched = true;
    _validateFromTime(silent: true);
    _validateOrder(silent: true);
    notifyListeners();
  }

  void setToDate(DateTime? v) {
    toDate = v;
    toDateTouched = true;
    _validateToDate(silent: true);
    _validateOrder(silent: true);
    notifyListeners();
  }

  void setToTime(TimeOfDay? v) {
    toTime = v;
    toTimeTouched = true;
    _validateToTime(silent: true);
    _validateOrder(silent: true);
    notifyListeners();
  }

  void setOutingRule(OutingRule rule) {
    loadedOutingRule = rule;
    isLoadingRules = false;
    _validateAll(silent: true);
    notifyListeners();
  }

  void setSubmitting(bool v) {
    isSubmitting = v;
    notifyListeners();
  }

  // Submit-time validate
  void validateAndMarkSubmitted() {
    submittedOnce = true;
    generalError = null;
    _validateAll(silent: false);
    notifyListeners();
  }

  // Validation
  void _validateAll({bool silent = false}) {
    _validateReason(silent: silent);
    _validateFromDate(silent: silent);
    _validateFromTime(silent: silent);
    _validateToDate(silent: silent);
    _validateToTime(silent: silent);
    _validateOrder(silent: silent);
  }

  bool _validateReason({bool silent = false}) {
    if (reason.trim().isEmpty) {
      reasonError = 'Enter a reason';
      if (!silent) generalError ??= reasonError;
      return false;
    }
    reasonError = null;
    return true;
  }

  // Dates: presence only
  bool _validateFromDate({bool silent = false}) {
    if (fromDate == null) {
      fromDateError = 'Select date';
      if (!silent) generalError ??= fromDateError;
      return false;
    }
    fromDateError = null;
    return true;
  }

  bool _validateToDate({bool silent = false}) {
    if (toDate == null) {
      toDateError = 'Select date';
      if (!silent) generalError ??= toDateError;
      return false;
    }
    toDateError = null;
    return true;
  }

  // Times: presence + future + rule window (Dayout only)
  bool _validateFromTime({bool silent = false}) {
    if (fromTime == null) {
      fromTimeError = 'Select time';
      if (!silent) generalError ??= fromTimeError;
      return false;
    }
    final dt = fromDateTime;
    if (dt != null) {
      if (!dt.isAfter(DateTime.now())) {
        fromTimeError = 'Must be in the future';
        if (!silent) generalError ??= fromTimeError;
        return false;
      }
      if (_shouldApplyOutingRule() && !_isWithinAllowed(dt)) {
        fromTimeError = 'Outside allowed hours';
        if (!silent) generalError ??= fromTimeError;
        return false;
      }
    }
    fromTimeError = null;
    return true;
  }

  bool _validateToTime({bool silent = false}) {
    if (toTime == null) {
      toTimeError = 'Select time';
      if (!silent) generalError ??= toTimeError;
      return false;
    }
    final dt = toDateTime;
    if (dt != null) {
      if (!dt.isAfter(DateTime.now())) {
        toTimeError = 'Must be in the future';
        if (!silent) generalError ??= toTimeError;
        return false;
      }
      if (_shouldApplyOutingRule() && !_isWithinAllowed(dt)) {
        toTimeError = 'Outside allowed hours';
        if (!silent) generalError ??= toTimeError;
        return false;
      }
    }
    toTimeError = null;
    return true;
  }

  // Cross-field order error is attached to To time
  bool _validateOrder({bool silent = false}) {
    final f = fromDateTime;
    final t = toDateTime;
    if (f != null && t != null && !f.isBefore(t)) {
      toTimeError = 'End must be after start';
      if (!silent) generalError ??= toTimeError;
      return false;
    }
    return true;
  }

  // Helpers
  bool _shouldApplyOutingRule() {
    return selectedType == RequestType.dayout &&
        loadedOutingRule != null &&
        !loadedOutingRule!.isUnrestricted;
  }

  bool _isWithinAllowed(DateTime dt) {
    return loadedOutingRule!.isWithinAllowedTime(dt);
  }
}
