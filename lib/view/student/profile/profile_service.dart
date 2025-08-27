import 'models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hostel_mgmt/core/util/crypto_utils.dart';
import 'dart:typed_data';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';

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

  Future<List<HostelModel>> fetchHostelInfo() async {
    // Load session
    final session = await LoginSession.loadFromPrefs();
    if (session == null || session.token.isEmpty) {
      throw Exception('Invalid or missing session. Please login again.');
    }

    final url = Uri.parse('http://20.192.25.27:4141/api/student/hostel-info');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${session.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch hostel info: ${response.statusCode}');
    }

    try {
      // Decrypt response body
      final encryptedBody = response.body.trim().replaceAll('"', '');
      // Use the same secret/iv as in StudentAuthService
      final secret = dotenv.env['CRYPTO_SECRET'] ?? '';
      final ivString = dotenv.env['CRYPTO_IV'] ?? '';
      final ivList = ivString
          .split(',')
          .map((e) => int.parse(e, radix: 16))
          .toList();
      final iv = Uint8List.fromList(ivList);
      final decrypted = CryptoUtil.decryptPayload(encryptedBody, secret, iv);

      // Parse to List<HostelModel>
      final List<dynamic> hostelsJson = decrypted['hostels'] ?? decrypted;
      print(hostelsJson);
      return hostelsJson
          .map(
            (json) => HostelModel(
              hostelId: json['hostelId'].toString(),
              hostelName: json['hostelName'].toString(),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Decryption or parsing error: $e');
    }
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
