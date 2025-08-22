import 'package:dartz/dartz.dart';
import '../../../../../lib/core/enums/enum.dart';
import '../../../../../lib/core/failures.dart';
import '../../../../../lib/core/usecase.dart';
import '../entities/request.dart';
import '../repository/request_repository.dart';

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
