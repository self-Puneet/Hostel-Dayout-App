// import 'package:hostel_dayout_app/core/enums/request_status.dart';
// import 'package:hostel_dayout_app/core/exception.dart';
// import '../models/request_model.dart';
// import 'package:hive/hive.dart';

// abstract class RequestLocalDataSource {
//   /// Throws [CacheException] when there is no cached data.
//   Future<List<RequestModel>> getCachedRequests();

//   /// Throws [CacheException] when there is no cached data.
//   Future<RequestModel?> getCachedRequestById(String id);

//   Future<void> cacheRequests(List<RequestModel> requests);

//   Future<void> cacheRequest(RequestModel request);

//   Future<void> cachePriorityRequests(List<RequestModel> requests);

//   Future<List<RequestModel>> getCachedRequestsByStatus(RequestStatus status);

//   Future<List<RequestModel>> getCachedPriorityRequests();

//   Future<void> clearCache();

//   Future<void> clearPriorityCache();
// }

// class RequestLocalDataSourceImpl implements RequestLocalDataSource {
//   final Box<RequestModel> requestBox;

//   RequestLocalDataSourceImpl({required this.requestBox});

//   @override
//   Future<void> cacheRequests(List<RequestModel> requests) async {
//     for (var request in requests) {
//       await requestBox.put(request.id, request);
//     }
//   }

//   @override
//   Future<void> clearPriorityCache() async {
//     final priorityRequests = requestBox.values
//         .where((request) => request.priority == true)
//         .toList();
//     for (var request in priorityRequests) {
//       await requestBox.delete(request.id);
//     }
//   }

//   @override
//   Future<void> cacheRequest(RequestModel request) async {
//     if (!requestBox.containsKey(request.id)) {
//       await requestBox.put(request.id, request);
//     } else {
//       // Optionally, log or handle the duplicate case
//       print("Request with ID ${request.id} already exists in Hive.");
//     }
//   }

//   @override
//   Future<List<RequestModel>> getCachedRequests() async {
//     final cached = requestBox.values.toList();
//     if (cached.isNotEmpty) {
//       return cached;
//     } else {
//       throw CacheException('No cached requests found');
//     }
//   }

//   @override
//   Future<List<RequestModel>> getCachedPriorityRequests() async {
//     final cached = requestBox.values
//         .where((request) => request.priority == true)
//         .toList();
//     if (cached.isNotEmpty) {
//       return cached;
//     } else {
//       throw CacheException('No cached requests found');
//     }
//   }

//   @override
//   Future<RequestModel?> getCachedRequestById(String id) async {
//     final request = requestBox.get(id);
//     if (request != null) {
//       return request;
//     } else {
//       throw CacheException('Request not found in cache');
//     }
//   }

//   @override
//   Future<List<RequestModel>> getCachedRequestsByStatus(
//     RequestStatus status,
//   ) async {
//     final cached = requestBox.values
//         .where((request) => request.status == status)
//         .toList();
//     if (cached.isNotEmpty) {
//       return cached;
//     } else {
//       throw CacheException('No cached requests found for status: $status');
//     }
//   }

//   @override
//   Future<void> clearCache() async {
//     await requestBox.clear();
//   }

//   @override
//   Future<void> cachePriorityRequests(List<RequestModel> requests) async {
//     await clearPriorityCache();

//     for (var request in requests) {
//       if (!requestBox.containsKey(request.id)) {
//         await requestBox.put(request.id, request);
//       }
//     }
//   }
// }
