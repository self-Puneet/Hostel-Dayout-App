import 'package:flutter/material.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';
import 'package:hostel_dayout_app/core/exception.dart';
import 'package:hostel_dayout_app/features/requests/data/models/parent_info_model.dart';
import 'package:hostel_dayout_app/features/requests/data/models/student_info_model.dart';
import 'package:hostel_dayout_app/features/requests/domain/entities/timeline_event.dart';
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
