// lib/domain/repositories/request_repository.dart
import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/requests/domain/usecase/get_status_filter.dart';
import '../entities/request.dart';

abstract class RequestRepository {
  Future<Either<Failure, List<Request>>> getRequests({
    RequestStatus? filterRequestStatus,
  });

  Future<Either<Failure, Request>> getRequestDetail(String requestId);

  Future<Either<Failure, List<Request>>> getPriorityRequests();

  // function for getting the request by status
  Future<Either<Failure, List<Request>>> getRequestbyFilter(
    String? searchTerm,
    RequestStatus? status,
  );
}
