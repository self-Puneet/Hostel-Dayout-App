import 'package:dartz/dartz.dart';
import '../../../../../lib/core/enums/enum.dart';
import '../../../../../lib/core/failures.dart';
import '../../../../../lib/core/usecase.dart';
import '../entities/request.dart';
import '../repository/request_repository.dart';

class UpdateRequest
    implements UseCase<List<Request>, Map<String, RequestStatus>> {
  final RequestRepository repository;
  UpdateRequest(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(
    Map<String, RequestStatus> params,
  ) {
    return repository.updateRequestStatus(params);
  }
}
