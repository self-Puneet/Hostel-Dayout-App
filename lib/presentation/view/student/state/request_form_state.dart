import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/models/restriction_window.dart';

class RequestFormState extends ChangeNotifier {
  // Request type
  RequestType _requestType = RequestType.dayout;
  RequestType get requestType => _requestType;

  // Dayout fields
  DateTime? dayoutDate;
  TimeOfDay? dayoutFromTime;
  TimeOfDay? dayoutToTime;

  // Leave fields
  DateTime? leaveFromDate;
  DateTime? leaveToDate;
  TimeOfDay? leaveFromTime;
  TimeOfDay? leaveToTime;

  // Touched flags
  bool touchedDayoutDate = false;
  bool touchedDayoutFromTime = false;
  bool touchedDayoutToTime = false;
  bool touchedLeaveFromDate = false;
  bool touchedLeaveToDate = false;
  bool touchedLeaveFromTime = false;
  bool touchedLeaveToTime = false;

  // Errors
  String? errorDayoutDate;
  String? errorDayoutFromTime;
  String? errorDayoutToTime;
  String? errorLeaveFromDate;
  String? errorLeaveToDate;
  String? errorLeaveFromTime;
  String? errorLeaveToTime;

  // Restriction (loaded once, static via controller)
  bool isLoadingRestriction = true;
  RestrictionWindow? restrictionWindow;

  // Reason (applies to both types)
  String reason = "";
  bool touchedReason = false;
  String? errorReason;

  void setReason(String v) {
    reason = v;
    touchedReason = true;
    _validate();
    notifyListeners();
  }

  // Submission
  bool isSubmitting = false;
  String? submitError;
  bool showSubmitAttempted = false;

  // Presence gate
  bool get hasRequiredFieldsFilled => isDayout
      ? dayoutDate != null && dayoutFromTime != null && dayoutToTime != null
      : leaveFromDate != null;

  // Button gate
  bool get isSubmittable =>
      hasRequiredFieldsFilled && isFormValid && !isSubmitting;

  // Per-mode snapshots
  DateTime? _cachedLeaveFromDate;
  DateTime? _cachedLeaveToDate;
  TimeOfDay? _cachedLeaveFromTime;
  TimeOfDay? _cachedLeaveToTime;
  bool _cachedTouchedLeaveFromDate = false;
  bool _cachedTouchedLeaveToDate = false;
  bool _cachedTouchedLeaveFromTime = false;
  bool _cachedTouchedLeaveToTime = false;

  // bool isProfileLoading = true;
  // StudentProfileModel? profile;

  // void setProfileLoading(bool v) {
  //   isProfileLoading = v;
  //   notifyListeners();
  // }

  // void setProfile(StudentProfileModel p) {
  //   profile = p;
  //   notifyListeners();
  // }

  // void setProfileError() {
  //   // optional: if tracking profile load errors
  //   isProfileLoading = false;
  //   notifyListeners();
  // }

  DateTime? _cachedDayoutDate;
  TimeOfDay? _cachedDayoutFromTime;
  TimeOfDay? _cachedDayoutToTime;
  bool _cachedTouchedDayoutDate = false;
  bool _cachedTouchedDayoutFromTime = false;
  bool _cachedTouchedDayoutToTime = false;

  RequestFormState();

  bool get isDayout => _requestType == RequestType.dayout;
  bool get isLeave => _requestType == RequestType.leave;

  bool get isFormValid {
    _validate();
    if (isDayout) {
      return errorDayoutDate == null &&
          errorDayoutFromTime == null &&
          errorDayoutToTime == null &&
          errorReason == null;
    } else {
      return errorLeaveFromDate == null &&
          errorLeaveToDate == null &&
          errorLeaveFromTime == null &&
          errorLeaveToTime == null &&
          errorReason == null;
    }
  }

  // Toggle with mapping + snapshot restore
  void setRequestType(RequestType t) {
    if (_requestType == t) return;

    if (t == RequestType.dayout) {
      // cache Leave
      _cachedLeaveFromDate = leaveFromDate;
      _cachedLeaveToDate = leaveToDate;
      _cachedLeaveFromTime = leaveFromTime;
      _cachedLeaveToTime = leaveToTime;
      _cachedTouchedLeaveFromDate = touchedLeaveFromDate;
      _cachedTouchedLeaveToDate = touchedLeaveToDate;
      _cachedTouchedLeaveFromTime = touchedLeaveFromTime;
      _cachedTouchedLeaveToTime = touchedLeaveToTime;

      // map Leave -> Dayout only if single-day
      if (leaveFromDate != null &&
          (leaveToDate == null ||
              _dateOnly(leaveFromDate!) == _dateOnly(leaveToDate!))) {
        dayoutDate = leaveFromDate;
        dayoutFromTime = leaveFromTime;
        dayoutToTime = leaveToTime;
        touchedDayoutDate = leaveFromDate != null;
        touchedDayoutFromTime = leaveFromTime != null;
        touchedDayoutToTime = leaveToTime != null;
      } else {
        dayoutDate = null;
        dayoutFromTime = null;
        dayoutToTime = null;
        touchedDayoutDate = false;
        touchedDayoutFromTime = false;
        touchedDayoutToTime = false;
      }
    } else {
      // restore cached Leave if present, else map Dayout -> Leave
      if (_cachedLeaveFromDate != null ||
          _cachedLeaveToDate != null ||
          _cachedLeaveFromTime != null ||
          _cachedLeaveToTime != null) {
        leaveFromDate = _cachedLeaveFromDate;
        leaveToDate = _cachedLeaveToDate;
        leaveFromTime = _cachedLeaveFromTime;
        leaveToTime = _cachedLeaveToTime;
        touchedLeaveFromDate = _cachedTouchedLeaveFromDate;
        touchedLeaveToDate = _cachedTouchedLeaveToDate;
        touchedLeaveFromTime = _cachedTouchedLeaveFromTime;
        touchedLeaveToTime = _cachedTouchedLeaveToTime;
      } else {
        leaveFromDate = dayoutDate;
        leaveFromTime = dayoutFromTime;
        leaveToTime = dayoutToTime;
        leaveToDate = null;
        touchedLeaveFromDate = dayoutDate != null;
        touchedLeaveFromTime = dayoutFromTime != null;
        touchedLeaveToTime = dayoutToTime != null;
        touchedLeaveToDate = false;
      }

      // cache Dayout
      _cachedDayoutDate = dayoutDate;
      _cachedDayoutFromTime = dayoutFromTime;
      _cachedDayoutToTime = dayoutToTime;
      _cachedTouchedDayoutDate = touchedDayoutDate;
      _cachedTouchedDayoutFromTime = touchedDayoutFromTime;
      _cachedTouchedDayoutToTime = touchedDayoutToTime;
    }

    _requestType = t;
    _validate();
    notifyListeners();
  }

  // Setters with immediate validation
  void setDayoutDate(DateTime d) {
    dayoutDate = d;
    touchedDayoutDate = true;
    _validate();
    notifyListeners();
  }

  void setDayoutFromTime(TimeOfDay t) {
    dayoutFromTime = t;
    touchedDayoutFromTime = true;
    _validate();
    notifyListeners();
  }

  void setDayoutToTime(TimeOfDay t) {
    dayoutToTime = t;
    touchedDayoutToTime = true;
    _validate();
    notifyListeners();
  }

  void setLeaveFromDate(DateTime d) {
    leaveFromDate = d;
    touchedLeaveFromDate = true;
    _validate();
    notifyListeners();
  }

  void setLeaveToDate(DateTime? d) {
    leaveToDate = d;
    touchedLeaveToDate = d != null;
    _validate();
    notifyListeners();
  }

  void setLeaveFromTime(TimeOfDay? t) {
    leaveFromTime = t;
    touchedLeaveFromTime = t != null;
    _validate();
    notifyListeners();
  }

  void setLeaveToTime(TimeOfDay? t) {
    leaveToTime = t;
    touchedLeaveToTime = t != null;
    _validate();
    notifyListeners();
  }

  // Controller-driven side-effect setters
  void setRestrictionLoading(bool v) {
    isLoadingRestriction = v;
    notifyListeners();
  }

  void setRestrictionWindow(RestrictionWindow? rw) {
    restrictionWindow = rw;
    isLoadingRestriction = false;
    _validate();
    notifyListeners();
  }

  void setSubmitting(bool v) {
    isSubmitting = v;
    notifyListeners();
  }

  void setSubmitError(String? e) {
    submitError = e;
    notifyListeners();
  }

  void validateAndMarkSubmitted() {
    showSubmitAttempted = true;
    _validate();
    notifyListeners();
  }

  bool get canSubmit => isSubmittable;

  // Validation
  void _validate() {
    errorDayoutDate = null;
    errorDayoutFromTime = null;
    errorDayoutToTime = null;
    errorLeaveFromDate = null;
    errorLeaveToDate = null;
    errorLeaveFromTime = null;
    errorLeaveToTime = null;

    // Dayout
    if (isDayout) {
      if (touchedDayoutDate || showSubmitAttempted) {
        if (dayoutDate == null) errorDayoutDate = "Date is required.";
      }
      if (touchedDayoutFromTime || showSubmitAttempted) {
        if (dayoutFromTime == null)
          errorDayoutFromTime = "From time is required.";
      }
      if (touchedDayoutToTime || showSubmitAttempted) {
        if (dayoutToTime == null) errorDayoutToTime = "To time is required.";
      }
      if (dayoutFromTime != null && dayoutToTime != null) {
        if (timeOfDayToMinutes(dayoutFromTime!) >=
            timeOfDayToMinutes(dayoutToTime!)) {
          errorDayoutFromTime = "From time must be before To time.";
        }
      }
      if (dayoutDate != null) {
        if (_dateOnly(dayoutDate!).isBefore(_todayDateOnly())) {
          errorDayoutDate = "Date cannot be in the past.";
        }
        if (_isToday(dayoutDate!)) {
          final nowMin = _nowMinutes();
          if (dayoutFromTime != null &&
              timeOfDayToMinutes(dayoutFromTime!) < nowMin) {
            errorDayoutFromTime = "From time cannot be in the past.";
          }
          if (dayoutToTime != null &&
              timeOfDayToMinutes(dayoutToTime!) < nowMin) {
            errorDayoutToTime = "To time cannot be in the past.";
          }
        }
      }
      if (restrictionWindow != null &&
          dayoutFromTime != null &&
          dayoutToTime != null) {
        final min = timeOfDayToMinutes(restrictionWindow!.minTime);
        final max = timeOfDayToMinutes(restrictionWindow!.maxTime);
        final fromMin = timeOfDayToMinutes(dayoutFromTime!);
        final toMin = timeOfDayToMinutes(dayoutToTime!);
        if (!restrictionWindow!.allowedToday) {
          errorDayoutDate = "Outing not allowed today.";
        }
        if (fromMin < min) {
          errorDayoutFromTime =
              "Must be after ${_formatTime(restrictionWindow!.minTime)}";
        }
        if (toMin > max) {
          errorDayoutToTime =
              "Must be before ${_formatTime(restrictionWindow!.maxTime)}";
        }
      }
      if (touchedReason || showSubmitAttempted) {
        final trimmed = reason.trim();
        if (trimmed.isEmpty) {
          errorReason = "Reason is required.";
        } else if (trimmed.length < 5) {
          errorReason = "Please provide a more descriptive reason.";
        } else {
          errorReason = null;
        }
      }
    }

    // Leave
    if (isLeave) {
      if (touchedLeaveFromDate || showSubmitAttempted) {
        if (leaveFromDate == null) errorLeaveFromDate = "From date required.";
      }
      if (leaveToDate != null && leaveFromDate != null) {
        if (leaveToDate!.isBefore(leaveFromDate!)) {
          errorLeaveToDate = "To date cannot be before From date.";
        }
      }
      final sameDay =
          (leaveToDate == null) ||
          (leaveFromDate != null &&
              _dateOnly(leaveFromDate!) == _dateOnly(leaveToDate!));
      if (leaveFromTime != null && leaveToTime != null && sameDay) {
        if (timeOfDayToMinutes(leaveFromTime!) >=
            timeOfDayToMinutes(leaveToTime!)) {
          errorLeaveFromTime = "From time must be before To time.";
        }
      }
      if (leaveFromDate != null &&
          _dateOnly(leaveFromDate!).isBefore(_todayDateOnly())) {
        errorLeaveFromDate = "From date cannot be in the past.";
      }
      if (leaveToDate != null &&
          _dateOnly(leaveToDate!).isBefore(_todayDateOnly())) {
        errorLeaveToDate = "To date cannot be in the past.";
      }
      final nowMin = _nowMinutes();
      if (leaveFromDate != null &&
          _isToday(leaveFromDate!) &&
          leaveFromTime != null) {
        if (timeOfDayToMinutes(leaveFromTime!) < nowMin) {
          errorLeaveFromTime = "From time cannot be in the past.";
        }
      }
      if (leaveToDate != null &&
          _isToday(leaveToDate!) &&
          leaveToTime != null) {
        if (timeOfDayToMinutes(leaveToTime!) < nowMin) {
          errorLeaveToTime = "To time cannot be in the past.";
        }
      }
      if (touchedReason || showSubmitAttempted) {
        final trimmed = reason.trim();
        if (trimmed.isEmpty) {
          errorReason = "Reason is required.";
        } else if (trimmed.length < 5) {
          errorReason = "Please provide a more descriptive reason.";
        } else {
          errorReason = null;
        }
      }
    }
  }

  // Formatting and helpers
  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "$h:$m $period";
  }

  DateTime _todayDateOnly() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  int _nowMinutes() {
    final now = TimeOfDay.now();
    return now.hour * 60 + now.minute;
  }

  int timeOfDayToMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
  bool _isToday(DateTime d) => _dateOnly(d) == _todayDateOnly();

  // Clear-all
  void clearState() {
    _requestType = RequestType.dayout;

    dayoutDate = null;
    dayoutFromTime = null;
    dayoutToTime = null;
    touchedDayoutDate = false;
    touchedDayoutFromTime = false;
    touchedDayoutToTime = false;

    leaveFromDate = null;
    leaveToDate = null;
    leaveFromTime = null;
    leaveToTime = null;
    touchedLeaveFromDate = false;
    touchedLeaveToDate = false;
    touchedLeaveFromTime = false;
    touchedLeaveToTime = false;

    errorDayoutDate = null;
    errorDayoutFromTime = null;
    errorDayoutToTime = null;
    errorLeaveFromDate = null;
    errorLeaveToDate = null;
    errorLeaveFromTime = null;
    errorLeaveToTime = null;

    isSubmitting = false;
    submitError = null;
    showSubmitAttempted = false;

    _cachedLeaveFromDate = null;
    _cachedLeaveToDate = null;
    _cachedLeaveFromTime = null;
    _cachedLeaveToTime = null;
    _cachedTouchedLeaveFromDate = false;
    _cachedTouchedLeaveToDate = false;
    _cachedTouchedLeaveFromTime = false;
    _cachedTouchedLeaveToTime = false;
    _cachedDayoutDate = null;
    _cachedDayoutFromTime = null;
    _cachedDayoutToTime = null;
    _cachedTouchedDayoutDate = false;
    _cachedTouchedDayoutFromTime = false;
    _cachedTouchedDayoutToTime = false;

    reason = "";
    touchedReason = false;
    errorReason = null;

    // profile = null;
    // isProfileLoading = false;

    _validate();
    notifyListeners();
  }
}
