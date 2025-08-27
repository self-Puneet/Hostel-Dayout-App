import 'models.dart';

class ProfileService {
  // Mock data
  static final List<HostelModel> _hostels = [
    HostelModel(hostelId: '1', hostelName: 'A Block'),
    HostelModel(hostelId: '2', hostelName: 'B Block'),
    HostelModel(hostelId: '3', hostelName: 'C Block'),
  ];

  static final List<BranchModel> _branches = [
    BranchModel(branch: 'CSE', maxSemester: 8),
    BranchModel(branch: 'ECE', maxSemester: 8),
    BranchModel(branch: 'ME', maxSemester: 8),
    BranchModel(branch: 'CE', maxSemester: 8),
    BranchModel(branch: 'MBA', maxSemester: 4),
  ];

  static final StudentProfileModel _profile = StudentProfileModel(
    studentId: 'S123',
    enrollmentNo: 'ENR2021001',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phoneNo: '9876543210',
    profilePic: '',
    hostelName: 'A Block',
    roomNo: '101',
    semester: 3,
    branch: 'CSE',
    parent: ParentModel(
      parentId: 'P123',
      name: 'Jane Doe',
      relation: 'Mother',
      phoneNo: '9123456789',
    ),
  );

  Future<List<HostelModel>> fetchHostels() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _hostels;
  }

  Future<List<BranchModel>> fetchBranches() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _branches;
  }

  Future<StudentProfileModel> fetchProfile() async {
    await Future.delayed(Duration(milliseconds: 500));
    return _profile;
  }

  Future<void> updateProfile(StudentProfileModel updatedProfile) async {
    await Future.delayed(Duration(milliseconds: 300));
    _profile.hostelName = updatedProfile.hostelName;
    _profile.roomNo = updatedProfile.roomNo;
    _profile.semester = updatedProfile.semester;
    _profile.branch = updatedProfile.branch;
    _profile.parent.relation = updatedProfile.parent.relation;
  }
}
