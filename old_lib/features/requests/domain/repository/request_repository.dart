// lib/domain/repositories/request_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../../lib/core/enums/enum.dart';
import '../../../../../lib/core/failures.dart';
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

  // function for changing  the status of a request
  Future<Either<Failure, List<Request>>> updateRequestStatus(
    Map<String, RequestStatus> requestUpdates,
  );

  Future<Either<Failure, Request>> updateRequestDetail(
    Request requestId,
    RequestStatus updatedStatus,
  );
}
