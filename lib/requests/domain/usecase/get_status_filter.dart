// lib/domain/usecases/get_requests.dart
import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/requests/domain/repository/request_repository.dart';
import '../entities/request.dart';

// create a new param class with RequestStatus and string? as attributes

class GetRequestByFilterParams {
  final RequestStatus? status;
  final String? searchTerm;

  GetRequestByFilterParams({required this.status, this.searchTerm});
}

class GetFilterRequest
    implements UseCase<List<Request>, GetRequestByFilterParams> {
  final RequestRepository repository;
  GetFilterRequest(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(GetRequestByFilterParams params) {
    return repository.getRequestbyFilter(params.searchTerm, params.status);
  }
}
