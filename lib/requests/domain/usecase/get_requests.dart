// lib/domain/usecases/get_requests.dart
import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/requests/domain/repository/request_repository.dart';
import '../entities/request.dart';

class GetRequestsParams {
  final String? searchQuery;
  final String? sortOrder;

  GetRequestsParams({this.searchQuery, this.sortOrder});
}

class GetRequests implements UseCase<List<Request>, GetRequestsParams> {
  final RequestRepository repository;
  GetRequests(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(GetRequestsParams params) {
    return repository.getRequests(
      searchQuery: params.searchQuery,
      sortOrder: params.sortOrder,
    );
  }
}
