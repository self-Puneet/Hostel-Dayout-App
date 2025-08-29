import 'package:hostel_mgmt/core/util/time_utils.dart';
import 'package:hostel_mgmt/models/outing_rule_model.dart';

class HostelSingleResponse {
  final String message;
  final HostelModel hostel;

  HostelSingleResponse({required this.message, required this.hostel});

  factory HostelSingleResponse.fromJson(Map<String, dynamic> json) {
    return HostelSingleResponse(
      message: json['message'] as String? ?? '',
      hostel: HostelModel.fromJson(json['hostel'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'hostel': hostel.toJson()};
  }
}

class HostelResponse {
  final String message;
  final List<HostelModel> hostels;

  HostelResponse({required this.message, required this.hostels});

  factory HostelResponse.fromJson(Map<String, dynamic> json) {
    return HostelResponse(
      message: json['message'] as String,
      hostels: (json['hostels'] as List)
          .map((h) => HostelModel.fromJson(h))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'hostels': hostels.map((h) => h.toJson()).toList(),
    };
  }
}

class HostelModel {
  OutingRule toOutingRule() {
    if (!outingAllowed) {
      return OutingRule.restricted();
    }
    // If times are not set, treat as unrestricted
    if (checkOutStartTime == Duration.zero &&
        latestReturnTime == Duration.zero) {
      return OutingRule.unrestricted();
    }
    return OutingRule.allowed(
      fromTime: checkOutStartTime,
      toTime: latestReturnTime,
    );
  }

  final String hostelId;
  final String hostelName;
  final Duration checkOutStartTime; // since midnight
  final Duration latestReturnTime; // since midnight
  final bool outingAllowed;

  HostelModel({
    required this.hostelId,
    required this.hostelName,
    required this.checkOutStartTime,
    required this.latestReturnTime,
    required this.outingAllowed,
  });

  factory HostelModel.fromJson(Map<String, dynamic> json) {
    return HostelModel(
      hostelId: json['hostel_id'] as String,
      hostelName: json['name'] as String,
      checkOutStartTime: TimeUtils.parse(json['check_out_start_time']),
      latestReturnTime: TimeUtils.parse(json['latest_return_time']),
      outingAllowed: json['outing_allowed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostel_id': hostelId,
      'name': hostelName,
      'check_out_start_time': TimeUtils.format(checkOutStartTime),
      'latest_return_time': TimeUtils.format(latestReturnTime),
      'outing_allowed': outingAllowed,
    };
  }
}
