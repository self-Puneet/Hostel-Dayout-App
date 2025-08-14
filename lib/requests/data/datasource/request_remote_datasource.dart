import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/core/enums/request_type.dart';
import 'package:hostel_dayout_app/core/enums/timeline_actor.dart';
import 'package:hostel_dayout_app/core/exception.dart';
import 'package:hostel_dayout_app/requests/data/models/parent_info_model.dart';
import 'package:hostel_dayout_app/requests/data/models/student_info_model.dart';
import 'package:hostel_dayout_app/requests/data/models/timeline_event_model.dart';
import '../models/request_model.dart';
import 'package:http/http.dart' as http;

abstract class RequestRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<RequestModel>> getRequests();

  /// Throws a [ServerException] for all error codes.
  Future<RequestModel> getRequestDetail(String requestId);

  Future<List<RequestModel>> getPriorityRequests();

  Future<List<RequestModel>> getRequestsByFilter({
    String? searchTerm,
    RequestStatus? status,
  });
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final http.Client client;

  RequestRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RequestModel>> getRequests() async {
    // --- Demo Data ---
    return [
      RequestModel(
        id: 'REQ001',
        type: RequestType.dayout,
        status: RequestStatus.requested,
        student: StudentInfoModel(
          name: 'John Meow',
          enrollment: 'ENR123456',
          room: 'B-201',
          year: '3rd Year',
          block: 'B',
        ),
        parent: ParentInfoModel(
          name: 'Jane Doe',
          relationship: 'Mother',
          phone: '9876543210',
        ),
        outTime: DateTime.now().add(const Duration(hours: 2)),
        returnTime: DateTime.now().add(const Duration(hours: 8)),
        reason: 'Attending family function',
        requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.student,
          ),
        ],
      ),
      RequestModel(
        id: 'REQ002',
        type: RequestType.leave,
        status: RequestStatus.parentApproved,
        student: StudentInfoModel(
          name: 'Kashyap Ojha',
          enrollment: 'ENR789012',
          room: 'A-105',
          year: '2nd Year',
          block: 'A',
        ),
        parent: ParentInfoModel(
          name: 'Kashyap Ojha',
          relationship: 'Father',
          phone: '8733907926',
        ),
        outTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        returnTime: DateTime.now().add(const Duration(days: 2)),
        reason: 'Visiting relatives',
        requestedAt: DateTime.now().subtract(const Duration(hours: 3)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            actor: TimelineActor.student,
          ),
          TimelineEventModel(
            description: 'Request approved by warden',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
          ),
        ],
      ),
    ];
  }

  @override
  Future<RequestModel> getRequestDetail(String requestId) async {
    // --- API call commented out ---
    /*
    final uri = Uri.parse('https://api.example.com/requests/$requestId');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      return RequestModel.fromJson(decoded);
    } else {
      throw ServerException('Failed to fetch request detail');
    }
    */

    // --- Demo detail (using REQ001 as example) ---
    return RequestModel(
      id: requestId,
      type: RequestType.dayout,
      status: RequestStatus.parentDenied,
      student: StudentInfoModel(
        name: 'John Doe',
        enrollment: 'ENR123456',
        room: 'B-201',
        year: '3rd Year',
        block: 'B',
      ),
      parent: ParentInfoModel(
        name: 'Jane Doe',
        relationship: 'Mother',
        phone: '9876543210',
      ),
      outTime: DateTime.now().add(const Duration(hours: 2)),
      returnTime: DateTime.now().add(const Duration(hours: 8)),
      reason: 'Attending family function',
      requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
      timeline: [
        TimelineEventModel(
          description: 'Request created by student',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          actor: TimelineActor.student,
        ),
      ],
    );
  }

  @override
  Future<List<RequestModel>> getPriorityRequests() async {
    // --- API call commented out ---
    /*
  final uri = Uri.parse('https://api.example.com/requests/priority');
  final response = await client.get(uri);
  if (response.statusCode == 200) {
    final List<dynamic> decoded = json.decode(response.body);
    return decoded.map((json) => RequestModel.fromJson(json)).toList();
  } else {
    throw ServerException('Failed to fetch priority requests');
  }
  */

    // --- Demo Priority Data ---
    return [
      RequestModel(
        id: 'REQ001',
        type: RequestType.dayout,
        status: RequestStatus.requested,
        student: StudentInfoModel(
          name: 'John Meow',
          enrollment: 'ENR123456',
          room: 'B-201',
          year: '3rd Year',
          block: 'B',
        ),
        parent: ParentInfoModel(
          name: 'Jane Doe',
          relationship: 'Mother',
          phone: '9876543210',
        ),
        outTime: DateTime.now().add(const Duration(hours: 2)),
        returnTime: DateTime.now().add(const Duration(hours: 8)),
        reason: 'Attending family function',
        requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.student,
          ),
        ],
        priority: true,
      ),
      RequestModel(
        id: 'REQ002',
        type: RequestType.leave,
        status: RequestStatus.parentApproved,
        student: StudentInfoModel(
          name: 'Kashyap Ojha',
          enrollment: 'ENR789012',
          room: 'A-105',
          year: '2nd Year',
          block: 'A',
        ),
        parent: ParentInfoModel(
          name: 'Kashyap Ojha',
          relationship: 'Father',
          phone: '8733907926',
        ),
        outTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        returnTime: DateTime.now().add(const Duration(days: 2)),
        reason: 'Visiting relatives',
        requestedAt: DateTime.now().subtract(const Duration(hours: 3)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            actor: TimelineActor.student,
          ),
          TimelineEventModel(
            description: 'Request approved by warden',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
          ),
        ],
        priority: true,
      ),
      RequestModel(
        id: 'REQ001',
        type: RequestType.dayout,
        status: RequestStatus.requested,
        student: StudentInfoModel(
          name: 'John Meow',
          enrollment: 'ENR123456',
          room: 'B-201',
          year: '3rd Year',
          block: 'B',
        ),
        parent: ParentInfoModel(
          name: 'Jane Doe',
          relationship: 'Mother',
          phone: '9876543210',
        ),
        outTime: DateTime.now().add(const Duration(hours: 2)),
        returnTime: DateTime.now().add(const Duration(hours: 8)),
        reason: 'Attending family function',
        requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.student,
          ),
        ],
        priority: true,
      ),
      RequestModel(
        id: 'REQ002',
        type: RequestType.leave,
        status: RequestStatus.parentApproved,
        student: StudentInfoModel(
          name: 'Kashyap Ojha',
          enrollment: 'ENR789012',
          room: 'A-105',
          year: '2nd Year',
          block: 'A',
        ),
        parent: ParentInfoModel(
          name: 'Kashyap Ojha',
          relationship: 'Father',
          phone: '8733907926',
        ),
        outTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        returnTime: DateTime.now().add(const Duration(days: 2)),
        reason: 'Visiting relatives',
        requestedAt: DateTime.now().subtract(const Duration(hours: 3)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            actor: TimelineActor.student,
          ),
          TimelineEventModel(
            description: 'Request approved by warden',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
          ),
        ],
        priority: true,
      ),

      RequestModel(
        id: 'REQ003',
        type: RequestType.leave,
        status: RequestStatus.requested,
        student: StudentInfoModel(
          name: 'Priya Sharma',
          enrollment: 'ENR456789',
          room: 'C-302',
          year: '4th Year',
          block: 'C',
        ),
        parent: ParentInfoModel(
          name: 'Ramesh Sharma',
          relationship: 'Father',
          phone: '9988776655',
        ),
        outTime: DateTime.now().add(const Duration(hours: 1)),
        returnTime: DateTime.now().add(const Duration(hours: 6)),
        reason: 'Emergency medical visit',
        requestedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        timeline: [
          TimelineEventModel(
            description: 'Priority request created by student',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            actor: TimelineActor.student,
          ),
        ],
        priority: true,
      ),
      RequestModel(
        id: 'REQ004',
        type: RequestType.dayout,
        status: RequestStatus.approved,
        student: StudentInfoModel(
          name: 'Amit Kumar',
          enrollment: 'ENR654321',
          room: 'D-101',
          year: '1st Year',
          block: 'D',
        ),
        parent: ParentInfoModel(
          name: 'Anita Kumar',
          relationship: 'Mother',
          phone: '8877665544',
        ),
        outTime: DateTime.now().add(const Duration(hours: 2)),
        returnTime: DateTime.now().add(const Duration(hours: 5)),
        reason: 'Urgent family meeting',
        requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeline: [
          TimelineEventModel(
            description: 'Priority request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.student,
          ),
          TimelineEventModel(
            description: 'Request approved by warden',
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
            actor: TimelineActor.warden,
          ),
        ],
        priority: true,
      ),
    ];
  }

  @override
  Future<List<RequestModel>> getRequestsByFilter({
    String? searchTerm,
    RequestStatus? status,
  }) async {
    return [
      RequestModel(
        id: 'requestId',
        type: RequestType.dayout,
        status: status ?? RequestStatus.requested,
        student: StudentInfoModel(
          name: searchTerm ?? 'John Doe',
          enrollment: 'ENR123456',
          room: 'B-201',
          year: '3rd Year',
          block: 'B',
        ),
        parent: ParentInfoModel(
          name: 'Jane Doe',
          relationship: 'Mother',
          phone: '9876543210',
        ),
        outTime: DateTime.now().add(const Duration(hours: 2)),
        returnTime: DateTime.now().add(const Duration(hours: 8)),
        reason: 'Attending family function',
        requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.student,
          ),
        ],
      ),
      RequestModel(
        id: 'REQ001',
        type: RequestType.dayout,
        status: status ?? RequestStatus.requested,
        student: StudentInfoModel(
          name: searchTerm ?? 'John Doe',
          enrollment: 'ENR123456',
          room: 'B-201',
          year: '3rd Year',
          block: 'B',
        ),
        parent: ParentInfoModel(
          name: 'Jane Doe',
          relationship: 'Mother',
          phone: '9876543210',
        ),
        outTime: DateTime.now().add(const Duration(hours: 2)),
        returnTime: DateTime.now().add(const Duration(hours: 8)),
        reason: 'Attending family function',
        requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.student,
          ),
        ],
      ),
      RequestModel(
        id: 'REQ002',
        type: RequestType.leave,
        status: status ?? RequestStatus.requested,
        student: StudentInfoModel(
          name: searchTerm ?? 'John Doe',
          enrollment: 'ENR789012',
          room: 'A-105',
          year: '2nd Year',
          block: 'A',
        ),
        parent: ParentInfoModel(
          name: 'Kashyap Ojha',
          relationship: 'Father',
          phone: '8733907926',
        ),
        outTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        returnTime: DateTime.now().add(const Duration(days: 2)),
        reason: 'Visiting relatives',
        requestedAt: DateTime.now().subtract(const Duration(hours: 3)),
        timeline: [
          TimelineEventModel(
            description: 'Request created by student',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            actor: TimelineActor.student,
          ),
          TimelineEventModel(
            description: 'Request approved by warden',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
          ),
        ],
      ),
    ];
  }
}
