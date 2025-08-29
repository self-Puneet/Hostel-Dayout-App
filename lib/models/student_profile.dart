import 'parent_model.dart';

class StudentProfileModel {
  final String studentId;
  final String enrollmentNo;
  final String name;
  final String email;
  final String phoneNo;
  final String profilePic;
  String hostelName;
  String roomNo;
  int semester;
  String branch;
  List<ParentModel> parents;

  StudentProfileModel({
    required this.studentId,
    required this.enrollmentNo,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.profilePic,
    required this.hostelName,
    required this.roomNo,
    required this.semester,
    required this.branch,
    required this.parents,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      studentId: json['_id'] ?? '',
      enrollmentNo: json['enrollment_no'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      profilePic: json['profile_pic'] ?? '',
      hostelName: json['hostel_id'] ?? '',
      roomNo: json['room_no'] ?? '',
      semester: json['semester'] is int
          ? json['semester']
          : int.tryParse(json['semester']?.toString() ?? '') ?? 0,
      branch: json['branch'] ?? '',
      parents:
          (json['parentsInfo'] as List<dynamic>?)
              ?.map((p) => ParentModel.fromJson(p))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': studentId,
      'enrollment_no': enrollmentNo,
      'name': name,
      'email': email,
      'phone_no': phoneNo,
      'profile_pic': profilePic,
      'hostel_id': hostelName,
      'room_no': roomNo,
      'semester': semester,
      'branch': branch,
      'parentsInfo': parents.map((p) => p.toJson()).toList(),
    };
  }
}

class StudentApiResponse {
  final String message;
  final StudentProfileModel student;

  StudentApiResponse({required this.message, required this.student});

  factory StudentApiResponse.fromJson(Map<String, dynamic> json) {
    return StudentApiResponse(
      message: json['message'] ?? '',
      student: StudentProfileModel.fromJson(
        json['student']['student'] ?? {}
          ..['parentsInfo'] = json['student']['parentsInfo'],
      ),
    );
  }
}
