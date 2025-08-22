import 'package:flutter/material.dart';
import '../../../../../lib/core/enums/enum.dart';
import '../../../../../lib/core/exception.dart';
import '../models/parent_info_model.dart';
import '../models/student_info_model.dart';
import '../../domain/entities/timeline_event.dart';
import '../models/request_model.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/request.dart';

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

  Future<List<RequestModel>> updateRequestStatus(
    Map<String, RequestStatus> requestUpdates,
  );

  Future<RequestModel> updateRequestDetail(
    Request request,
    RequestStatus updatedStatus,
  );
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final http.Client client;

  RequestRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RequestModel>> getRequests() async {
    // --- Improved Demo Data ---
    return [
      RequestModel(
        id: 'REQ2025-001',
        type: RequestType.dayout,
        status: RequestStatus.requested,
        student: StudentInfoModel(
          name: 'Aarav Sharma',
          enrollment: 'ENR2025001',
          room: 'C-312',
          year: '2nd Year',
          block: 'C',
        ),
        parent: ParentInfoModel(
          name: 'Priya Sharma',
          relationship: 'Mother',
          phone: '9812345678',
        ),
        outTime: DateTime.now().add(const Duration(hours: 3)),
        returnTime: DateTime.now().add(const Duration(hours: 10)),
        reason: 'Medical appointment at city hospital',
        requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
        timeline: [
          TimelineEvent(
            type: 'requested',
            description: 'Request Created',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            actor: TimelineActor.student,
            icon: Icon(Icons.radio_button_checked),
          ),
          TimelineEvent(
            type: 'referred',
            description: 'Referred to Parents',
            timestamp: DateTime.now().subtract(
              const Duration(hours: 1, minutes: 30),
            ),
            actor: TimelineActor.warden,
            icon: Icon(Icons.phone_in_talk_outlined),
          ),
          TimelineEvent(
            type: 'parent_approved',
            description: 'Parent Approved Request',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.parent,
            icon: Icon(Icons.verified_outlined),
          ),
        ],
      ),
      RequestModel(
        id: 'REQ2025-002',
        type: RequestType.leave,
        status: RequestStatus.parentApproved,
        student: StudentInfoModel(
          name: 'Meera Singh',
          enrollment: 'ENR2025002',
          room: 'A-108',
          year: '1st Year',
          block: 'A',
        ),
        parent: ParentInfoModel(
          name: 'Rajesh Singh',
          relationship: 'Father',
          phone: '9876543211',
        ),
        outTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
        returnTime: DateTime.now().add(const Duration(days: 2, hours: 5)),
        reason: 'Family wedding in hometown',
        requestedAt: DateTime.now().subtract(const Duration(hours: 4)),
        timeline: [
          TimelineEvent(
            type: 'requested',
            description: 'Request Created',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            actor: TimelineActor.student,
            icon: Icon(Icons.radio_button_checked),
          ),
          TimelineEvent(
            type: 'referred',
            description: 'Referred to Parents',
            timestamp: DateTime.now().subtract(
              const Duration(hours: 3, minutes: 30),
            ),
            actor: TimelineActor.warden,
            icon: Icon(Icons.phone_in_talk_outlined),
          ),
          TimelineEvent(
            type: 'parent_approved',
            description: 'Parent Approved Request',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            actor: TimelineActor.parent,
            icon: Icon(Icons.verified_outlined),
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
      status: RequestStatus.requested,
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
        TimelineEvent(
          type: 'requested',
          description: 'Request Created',
          timestamp: DateTime.now(),
          actor: TimelineActor.student,
          icon: Icon(Icons.radio_button_checked),
        ),
        TimelineEvent(
          type: 'referred',
          description: 'Referred to Parents',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          actor: TimelineActor.warden,
          icon: Icon(Icons.phone_in_talk_outlined),
        ),
        TimelineEvent(
          type: 'parent_approved',
          description: 'Parent Approved Request',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          actor: TimelineActor.parent,
          icon: Icon(Icons.verified_outlined),
        ),
        TimelineEvent(
          type: 'accepted',
          description: 'Request Accepted',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          actor: TimelineActor.warden,
          icon: Icon(Icons.check),
        ),
        TimelineEvent(
          type: 'closed',
          description: 'Request Closed',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          actor: TimelineActor.server,
          icon: Icon(Icons.remove_circle_outline),
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

    // --- Improved Priority Demo Data ---
    return [
      RequestModel(
        id: 'REQ2025-P01',
        type: RequestType.dayout,
        status: RequestStatus.requested,
        student: StudentInfoModel(
          name: 'Riya Verma',
          enrollment: 'ENR2025P01',
          room: 'D-210',
          year: '4th Year',
          block: 'D',
        ),
        parent: ParentInfoModel(
          name: 'Sunita Verma',
          relationship: 'Mother',
          phone: '9811122233',
        ),
        outTime: DateTime.now().add(const Duration(hours: 1)),
        returnTime: DateTime.now().add(const Duration(hours: 7)),
        reason: 'Urgent passport appointment',
        requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
        timeline: [
          TimelineEvent(
            type: 'requested',
            description: 'Request Created',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.student,
            icon: Icon(Icons.radio_button_checked),
          ),
          TimelineEvent(
            type: 'parent_approved',
            description: 'Parent Approved Request',
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
            actor: TimelineActor.parent,
            icon: Icon(Icons.verified_outlined),
          ),
        ],
        priority: true,
      ),
      RequestModel(
        id: 'REQ2025-P02',
        type: RequestType.leave,
        status: RequestStatus.parentApproved,
        student: StudentInfoModel(
          name: 'Aditya Kumar',
          enrollment: 'ENR2025P02',
          room: 'B-115',
          year: '3rd Year',
          block: 'B',
        ),
        parent: ParentInfoModel(
          name: 'Manoj Kumar',
          relationship: 'Father',
          phone: '9876654321',
        ),
        outTime: DateTime.now().add(const Duration(days: 1)),
        returnTime: DateTime.now().add(const Duration(days: 2, hours: 4)),
        reason: 'Medical leave for surgery',
        requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
        timeline: [
          TimelineEvent(
            type: 'requested',
            description: 'Request Created',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            actor: TimelineActor.student,
            icon: Icon(Icons.radio_button_checked),
          ),
          TimelineEvent(
            type: 'parent_approved',
            description: 'Parent Approved Request',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.parent,
            icon: Icon(Icons.verified_outlined),
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
          TimelineEvent(
            type: 'requested',
            description: 'Request Created',
            timestamp: DateTime.now(),
            actor: TimelineActor.student,
            icon: Icon(Icons.radio_button_checked),
          ),
          TimelineEvent(
            type: 'referred',
            description: 'Referred to Parents',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
            icon: Icon(Icons.phone_in_talk_outlined),
          ),
          TimelineEvent(
            type: 'parent_approved',
            description: 'Parent Approved Request',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.parent,
            icon: Icon(Icons.verified_outlined),
          ),
          TimelineEvent(
            type: 'accepted',
            description: 'Request Accepted',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
            icon: Icon(Icons.check),
          ),
          TimelineEvent(
            type: 'closed',
            description: 'Request Closed',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.server,
            icon: Icon(Icons.remove_circle_outline),
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
          TimelineEvent(
            type: 'requested',
            description: 'Request Created',
            timestamp: DateTime.now(),
            actor: TimelineActor.student,
            icon: Icon(Icons.radio_button_checked),
          ),
          TimelineEvent(
            type: 'referred',
            description: 'Referred to Parents',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
            icon: Icon(Icons.phone_in_talk_outlined),
          ),
          TimelineEvent(
            type: 'parent_approved',
            description: 'Parent Approved Request',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.parent,
            icon: Icon(Icons.verified_outlined),
          ),
          TimelineEvent(
            type: 'accepted',
            description: 'Request Accepted',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
            icon: Icon(Icons.check),
          ),
          TimelineEvent(
            type: 'closed',
            description: 'Request Closed',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.server,
            icon: Icon(Icons.remove_circle_outline),
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
          TimelineEvent(
            type: 'requested',
            description: 'Request Created',
            timestamp: DateTime.now(),
            actor: TimelineActor.student,
            icon: Icon(Icons.radio_button_checked),
          ),
          TimelineEvent(
            type: 'referred',
            description: 'Referred to Parents',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
            icon: Icon(Icons.phone_in_talk_outlined),
          ),
          TimelineEvent(
            type: 'parent_approved',
            description: 'Parent Approved Request',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.parent,
            icon: Icon(Icons.verified_outlined),
          ),
          TimelineEvent(
            type: 'accepted',
            description: 'Request Accepted',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.warden,
            icon: Icon(Icons.check),
          ),
          TimelineEvent(
            type: 'closed',
            description: 'Request Closed',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actor: TimelineActor.server,
            icon: Icon(Icons.remove_circle_outline),
          ),
        ],
      ),
    ];
  }

  @override
  Future<List<RequestModel>> updateRequestStatus(
    Map<String, RequestStatus> requestUpdates,
  ) async {
    // --- API call commented out ---
    /*
    final uri = Uri.parse('https://api.example.com/requests/update-status');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestUpdates),
    );
    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.map((json) => RequestModel.fromJson(json)).toList();
    } else {
      throw ServerException('Failed to update request status');
    }
    */

    // --- Demo Update ---
    return requestUpdates.entries.map((entry) {
      return RequestModel(
        id: entry.key,
        type: RequestType.dayout,
        status: entry.value,
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
        timeline: [],
      );
    }).toList();
  }

  @override
  Future<RequestModel> updateRequestDetail(
    Request request,
    RequestStatus updatedStatus,
  ) async {
    final updatedRequest = request.copyWith(
      status: updatedStatus,
      // Update other fields as necessary
    );
    return RequestModel.fromEntity(updatedRequest);
  }
}
