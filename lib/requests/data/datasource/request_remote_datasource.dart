import 'package:hostel_dayout_app/core/enums/request_state.dart';
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
  Future<List<RequestModel>> getRequests({
    String? searchQuery,
    String? sortOrder,
  });

  /// Throws a [ServerException] for all error codes.
  Future<RequestModel> getRequestDetail(String requestId);
}

// class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
//   final http.Client client;

//   RequestRemoteDataSourceImpl({required this.client});

//   @override
//   Future<List<RequestModel>> getRequests({
//     String? searchQuery,
//     String? sortOrder,
//   }) async {
//     final uri = Uri.parse('https://api.example.com/requests').replace(
//       queryParameters: {
//         if (searchQuery != null) 'search': searchQuery,
//         if (sortOrder != null) 'sort': sortOrder,
//       },
//     );

//     final response = await client.get(uri);

//     if (response.statusCode == 200) {
//       final List<dynamic> decoded = json.decode(response.body);
//       return decoded.map((json) => RequestModel.fromJson(json)).toList();
//     } else {
//       throw ServerException('Failed to fetch requests');
//     }
//   }

//   @override
//   Future<RequestModel> getRequestDetail(String requestId) async {
//     final uri = Uri.parse('https://api.example.com/requests/$requestId');
//     final response = await client.get(uri);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> decoded = json.decode(response.body);
//       return RequestModel.fromJson(decoded);
//     } else {
//       throw ServerException('Failed to fetch request detail');
//     }
//   }
// }

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final http.Client client;

  RequestRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RequestModel>> getRequests({
    String? searchQuery,
    String? sortOrder,
  }) async {
    // --- API call commented out ---
    /*
    final uri = Uri.parse('https://api.example.com/requests').replace(
      queryParameters: {
        if (searchQuery != null) 'search': searchQuery,
        if (sortOrder != null) 'sort': sortOrder,
      },
    );
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.map((json) => RequestModel.fromJson(json)).toList();
    } else {
      throw ServerException('Failed to fetch requests');
    }
    */

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
        requestState: RequestState.active,
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
        requestState: RequestState.active,
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
      requestState: RequestState.inactive,
    );
  }
}
