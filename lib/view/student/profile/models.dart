// Models for Profile Feature

class BranchModel {
  final String branch;
  final int maxSemester;
  BranchModel({required this.branch, required this.maxSemester});
}

class HostelModel {
  final String hostelId;
  final String hostelName;
  HostelModel({required this.hostelId, required this.hostelName});
}

class ParentModel {
  final String parentId;
  final String name;
  String relation;
  final String phoneNo;
  ParentModel({
    required this.parentId,
    required this.name,
    required this.relation,
    required this.phoneNo,
  });
}

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
  ParentModel parent;
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
    required this.parent,
  });
}
