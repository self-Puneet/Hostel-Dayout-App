import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hostel_mgmt/view/student/profile/profile_service.dart';
import 'package:hostel_mgmt/view/student/profile/models.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load();

  final service = ProfileService();
  try {
    print('Fetching hostel info...');
    final hostels = await service.fetchHostelInfo();
    print('Hostel Info:');
    for (final hostel in hostels) {
      print('ID: ${hostel.hostelId}, Name: ${hostel.hostelName}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
