enum WardenRole { assistantWarden, seniorWarden }

extension WardenRoleX on WardenRole {
  String get displayName {
    switch (this) {
      case WardenRole.assistantWarden:
        return "Assistant Warden";
      case WardenRole.seniorWarden:
        return "Senior Warden";
    }
  }

  String get apiValue {
    switch (this) {
      case WardenRole.assistantWarden:
        return "warden";
      case WardenRole.seniorWarden:
        return "senior_warden";
    }
  }
}

class WardenModel {
  final String wardenId;
  final String empId;
  final String name;
  final String phoneNo;
  final List<String> hostels;
  final String? profilePicUrl;
  final WardenRole wardenRole;
  final String? email;
  final String? languagePreference;

  WardenModel({
    required this.wardenId,
    required this.empId,
    required this.name,
    required this.phoneNo,
    required this.hostels,
    this.profilePicUrl,
    required this.wardenRole,
    this.email,
    this.languagePreference,
  });

  /// Convert string role from API → Enum
  static WardenRole _roleFromString(String? role) {
    switch (role) {
      case "senior_warden":
        return WardenRole.seniorWarden;
      case "warden":
        return WardenRole.assistantWarden;
      default:
        return WardenRole.assistantWarden;
    }
  }

  factory WardenModel.fromJson(Map<String, dynamic> json) {
    final hostels_ =
        (json['hostel_id'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    // print(hostels_);
    // print(hostels_.runtimeType);
    return WardenModel(
      wardenId: json['warden_id'] ?? '',
      empId: json['emp_id'] ?? '',
      name: json['name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      profilePicUrl: json['profile_pic'],
      wardenRole: _roleFromString(json['role']),
      email: json['email'],
      languagePreference: json['language_preference'],
      hostels: hostels_,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warden_id': wardenId,
      'emp_id': empId,
      'name': name,
      'phone_no': phoneNo,
      'role': wardenRole.apiValue,
      if (profilePicUrl != null) 'profile_pic': profilePicUrl,
      if (email != null) 'email': email,
      if (languagePreference != null) 'language_preference': languagePreference,
      'hostels': hostels,
    };
  }
}
