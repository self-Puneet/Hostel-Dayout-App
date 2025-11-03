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
  final List<String> hostelId;
  final List<String>? hostels;
  final String? profilePicUrl;
  final WardenRole wardenRole;
  final String? email;
  final String? languagePreference;

  WardenModel({
    required this.wardenId,
    required this.empId,
    required this.name,
    required this.phoneNo,
    required this.hostelId,
    this.profilePicUrl,
    required this.wardenRole,
    this.email,
    this.languagePreference,
    this.hostels,
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
    List<String> hostels_;
    final hostelIdFromJson = json['hostel_id'];
    if (hostelIdFromJson is List) {
      hostels_ = hostelIdFromJson.map((e) => e.toString()).toList();
    } else if (hostelIdFromJson is String) {
      hostels_ = [hostelIdFromJson];
    } else {
      hostels_ = [];
    }
    return WardenModel(
      wardenId: json['warden_id'] ?? '',
      empId: json['emp_id'] ?? '',
      name: json['name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      profilePicUrl: json['profile_pic'],
      wardenRole: _roleFromString(json['role']),
      email: json['email'],
      languagePreference: json['language_preference'],
      hostelId: hostels_,
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
      'hostels': hostelId,
    };
  }

  // ---------------- copyWith ----------------
  WardenModel copyWith({
    String? wardenId,
    String? empId,
    String? name,
    String? phoneNo,
    List<String>? hostelId,
    List<String>? hostels,
    String? profilePicUrl,
    WardenRole? wardenRole,
    String? email,
    String? languagePreference,
  }) {
    print(hostels);
    return WardenModel(
      wardenId: wardenId ?? this.wardenId,
      empId: empId ?? this.empId,
      name: name ?? this.name,
      phoneNo: phoneNo ?? this.phoneNo,
      hostelId: hostelId ?? List<String>.from(this.hostelId),
      hostels:
          hostels ??
          (this.hostels != null ? List<String>.from(this.hostels!) : null),
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      wardenRole: wardenRole ?? this.wardenRole,
      email: email ?? this.email,
      languagePreference: languagePreference ?? this.languagePreference,
    );
  }

  @override
  String toString() {
    final hostelsStr = hostels == null ? 'null' : '[${hostels!.join(', ')}]';
    return 'WardenModel{'
        'wardenId: $wardenId, '
        'empId: $empId, '
        'name: $name, '
        'phoneNo: $phoneNo, '
        'hostelId: [${hostelId.join(', ')}], '
        'hostels: $hostelsStr, '
        'profilePicUrl: ${profilePicUrl ?? 'null'}, '
        'wardenRole: ${wardenRole.displayName} (${wardenRole.apiValue}), '
        'email: ${email ?? 'null'}, '
        'languagePreference: ${languagePreference ?? 'null'}'
        '}';
  }

  /// Multi-line pretty representation (useful for debugging).
  String toPrettyString() {
    final hostelsStr = hostels == null ? 'null' : '[${hostels!.join(', ')}]';
    return '''
WardenModel(
  wardenId: $wardenId,
  empId: $empId,
  name: $name,
  phoneNo: $phoneNo,
  hostelId: [${hostelId.join(', ')}],
  hostels: $hostelsStr,
  profilePicUrl: ${profilePicUrl ?? 'null'},
  wardenRole: ${wardenRole.displayName} (${wardenRole.apiValue}),
  email: ${email ?? 'null'},
  languagePreference: ${languagePreference ?? 'null'},
)''';
  }
}
