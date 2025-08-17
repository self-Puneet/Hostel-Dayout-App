import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/requests/domain/entities/request.dart';
import 'package:hostel_dayout_app/requests/domain/repository/request_repository.dart';

class UpdateRequestDetailParams {
  final Request request;
  final RequestStatus updatedStatus;

  UpdateRequestDetailParams({
    required this.request,
    required this.updatedStatus,
  });
}

class UpdateRequestDetail
    implements UseCase<Request, UpdateRequestDetailParams> {
  final RequestRepository repository;
  UpdateRequestDetail(this.repository);

  @override
  Future<Either<Failure, Request>> call(UpdateRequestDetailParams params) {
    return repository.updateRequestDetail(
      params.request,
      params.updatedStatus,
    );
  }
}
