import 'package:hostel_mgmt/models/hostels_model.dart';

enum WardenRole { assitentWarden, seniorWarden }

class WardenModel {
  final String wardenId;
  final String empId;
  final String name;
  final String phoneNo;
  final HostelModel hostelModel;
  final String? profilePicUrl;
  final WardenRole wardenRole;
  final String? email;
  final String? languagePreference;

  WardenModel({
    required this.wardenId,
    required this.empId,
    required this.name,
    required this.phoneNo,
    required this.hostelModel,
    this.profilePicUrl,
    required this.wardenRole,
    this.email,
    this.languagePreference,
  });

  static WardenRole _roleFromString(String status) {
    switch (status) {
      case "senior_warden":
        return WardenRole.seniorWarden;
      case "assistent_warden":
        return WardenRole.assitentWarden;
      default:
        return WardenRole.assitentWarden;
    }
  }

  factory WardenModel.fromJson(Map<String, dynamic> json) {
    return WardenModel(
      wardenId: json['warden_id'] ?? '',
      empId: json['emp_id'] ?? '',
      name: json['name'] ?? '',
      wardenRole: _roleFromString(json['role']),
      hostelModel: HostelModel.fromJson(json['hostel']),
      profilePicUrl: json['profile_pic'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      email: json['email'],
      languagePreference: json['language_preference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': wardenId,
      'emp_id': empId,
      'name': name,
      'role': wardenRole,
      if (profilePicUrl != null) 'profile_pic': profilePicUrl,
      'phone_no': phoneNo,
      'hostel_id': hostelModel.hostelId,
      if (email != null) 'email': email,
      if (languagePreference != null) 'language_preference': languagePreference,
    };
  }
}
