// lib/domain/usecases/get_request_detail.dart
import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/requests/domain/repository/request_repository.dart';
import '../entities/request.dart';

class GetRequestDetailParams {
  final String requestId;
  GetRequestDetailParams(this.requestId);
}

class GetRequestDetail implements UseCase<Request, GetRequestDetailParams> {
  final RequestRepository repository;
  GetRequestDetail(this.repository);

  @override
  Future<Either<Failure, Request>> call(GetRequestDetailParams params) {
    return repository.getRequestDetail(params.requestId);
  }
}
