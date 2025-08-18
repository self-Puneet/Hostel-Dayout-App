// make a run time storage for the requests
import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/features/requests/domain/entities/request.dart';

class RequestStorage {
  final Map<String, Request> _storage = {};
  final Map<String, Request> _onScreenStorage = {};

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

  void saveRequests(List<Request> requests) {
    clear();
    for (var request in requests) {
      _storage[request.id] = request;
    }
  }

  List<Request> getRequestsByStatus(RequestStatus status) {
    return _storage.values
        .where((request) => request.status == status)
        .toList();
  }

  void clear() {
    _storage.clear();
  }

  void updateRequests(List<Request> requests) {
    // update all the request with the new requests send whose ids matches and keep others same
    for (var request in requests) {
      _storage[request.id] = request;
      _onScreenStorage[request.id] = request;
    }
    print('2' * 90);
    print(_onScreenStorage.length);
  }

  List<Request> getOnScreenRequests() {
    return _onScreenStorage.values.toList();
  }

  void clearOnScreenRequests() {
    _onScreenStorage.clear();
  }

  void saveOnScreenRequests(List<Request> requests) {
    print("\$" * 20);
    print(requests);
    print(_onScreenStorage[requests.first.student.name]);
    clearOnScreenRequests();
    for (var request in requests) {
      _onScreenStorage[request.id] = request;
      print(
        '--------------------------------------------------------------------------${_onScreenStorage[request.id]}',
      );
    }
    print('#' * 90);
    print(_onScreenStorage);
  }

  Request? getRequestById(String id) {
    return _onScreenStorage[id];
  }

  
}
