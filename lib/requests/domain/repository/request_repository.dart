// lib/domain/repositories/request_repository.dart
import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import '../entities/request.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<Request>>> getRequests({
    String? searchQuery,
    String? sortOrder,
  });

  Future<Either<Failure, Request>> getRequestDetail(String requestId);

  Future<Either<Failure, List<Request>>> getPriorityRequests();
}
