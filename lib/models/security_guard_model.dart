class SecurityGuardModel {
  final String securityGuardId;
  final String empId;
  final String name;
  final String? phoneNo;
  final String? email;
  final String? languagePreference;

  const SecurityGuardModel({
    required this.securityGuardId,
    required this.empId,
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.languagePreference,
  });

  factory SecurityGuardModel.fromJson(Map<String, dynamic> json) {
    return SecurityGuardModel(
      securityGuardId: json['security_guard_id'] ?? '',
      empId: json['emp_id'] ?? '',
      name: json['name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      email: json['email'] ?? '',
      languagePreference: json['language_preference'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "security_guard_id": securityGuardId,
      "emp_id": empId,
      "name": name,
      "phone_no": phoneNo,
      "email": email,
      "language_preference": languagePreference,
    };
  }
}
