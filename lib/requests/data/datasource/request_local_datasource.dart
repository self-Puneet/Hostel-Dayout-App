import 'package:hostel_dayout_app/core/exception.dart';
import '../models/request_model.dart';
import 'package:hive/hive.dart';

abstract class RequestLocalDataSource {
  /// Throws [CacheException] when there is no cached data.
  Future<List<RequestModel>> getCachedRequests();

  /// Throws [CacheException] when there is no cached data.
  Future<RequestModel?> getCachedRequestById(String id);

  Future<void> cacheRequests(List<RequestModel> requests);

  Future<void> cacheRequest(RequestModel request);
}

class RequestLocalDataSourceImpl implements RequestLocalDataSource {
  final Box<RequestModel> requestBox;

  RequestLocalDataSourceImpl({required this.requestBox});

  @override
  Future<void> cacheRequests(List<RequestModel> requests) async {
    for (var request in requests) {
      await requestBox.put(request.id, request);
    }
  }

  @override
  Future<void> cacheRequest(RequestModel request) async {
    await requestBox.put(request.id, request);
  }

  @override
  Future<List<RequestModel>> getCachedRequests() async {
    final cached = requestBox.values.toList();
    if (cached.isNotEmpty) {
      return cached;
    } else {
      throw CacheException('No cached requests found');
    }
  }

  @override
  Future<RequestModel?> getCachedRequestById(String id) async {
    final request = requestBox.get(id);
    if (request != null) {
      return request;
    } else {
      throw CacheException('Request not found in cache');
    }
  }
}
