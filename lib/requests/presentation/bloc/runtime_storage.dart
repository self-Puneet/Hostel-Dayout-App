// make a run time storage for the requests
import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/requests/domain/entities/request.dart';

class RequestStorage {
  final Map<String, Request> _storage = {};

  Request? getRequest(String id) {
    return _storage[id];
  }

  void saveRequest(Request request) {
    _storage[request.id] = request;
  }

  void deleteRequest(String id) {
    _storage.remove(id);
  }

  List<Request> getRequests() {
    return _storage.values.toList();
  }

  List<Request> getRequestsByStatus(RequestStatus status) {
    return _storage.values
        .where((request) => request.status == status)
        .toList();
  }

  void clear() {
    _storage.clear();
  }
}
