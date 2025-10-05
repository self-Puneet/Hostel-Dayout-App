// student_profile.dart
import 'parent_model.dart';

class StudentProfileModel {
  final String studentId;
  final String enrollmentNo;
  final String name;
  final String email;
  final String phoneNo;
  final String? profilePic;
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
    this.profilePic,
    required this.hostelName,
    required this.roomNo,
    required this.semester,
    required this.branch,
    required this.parents,
  });

  // Small helper to coerce any JSON value to String safely.
  static String? _asString(dynamic v) => v == null ? null : v.toString();

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    // print(json['profile_pic']);
    // print("aaaaaaaaaaaaaaaaaaaaaaaaaa");
    return StudentProfileModel(
      // Accept either `_id` or `student_id`
      studentId: _asString(json['student_id']) ?? '',
      enrollmentNo: _asString(json['enrollment_no']) ?? '',
      name: _asString(json['name']) ?? '',
      email: _asString(json['email']) ?? '',
      // Coerce possible int -> String
      phoneNo: _asString(json['phone_no']) ?? '',
      // Optional picture; coerce to String if present
      profilePic: _asString(json['profile_pic']),
      hostelName: _asString(json['hostel_id']) ?? '',
      // Coerce possible int -> String
      roomNo: _asString(json['room_no']) ?? '',
      // Handle both int and String for semester
      semester: json['semester'] is int
          ? json['semester'] as int
          : int.tryParse(_asString(json['semester']) ?? '') ?? 0,
      branch: _asString(json['branch']) ?? '',
      // Keep existing parents mapping; default to empty list if absent
      parents:
          (json['parentsInfo'] as List<dynamic>?)
              ?.map((p) => ParentModel.fromJson(p as Map<String, dynamic>))
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

  StudentProfileModel copyWith({
    String? studentId,
    String? enrollmentNo,
    String? name,
    String? email,
    String? phoneNo,
    String? profilePic,
    String? hostelName,
    String? roomNo,
    int? semester,
    String? branch,
    List<ParentModel>? parents,
  }) {
    return StudentProfileModel(
      studentId: studentId ?? this.studentId,
      enrollmentNo: enrollmentNo ?? this.enrollmentNo,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      profilePic: profilePic ?? this.profilePic,
      hostelName: hostelName ?? this.hostelName,
      roomNo: roomNo ?? this.roomNo,
      semester: semester ?? this.semester,
      branch: branch ?? this.branch,
      parents: parents ?? this.parents,
    );
  }
}

class StudentApiResponse {
  final String message;
  final StudentProfileModel student;

  StudentApiResponse({required this.message, required this.student});

  factory StudentApiResponse.fromJson(Map<String, dynamic> json) {
    return StudentApiResponse(
      message: (json['message'] ?? '').toString(),
      student: StudentProfileModel.fromJson(
        (json['student']['student'] ?? {})
          ..['parentsInfo'] = json['student']['parentsInfo'],
      ),
    );
  }
}
