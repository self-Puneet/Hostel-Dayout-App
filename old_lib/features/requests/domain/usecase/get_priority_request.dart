import 'package:dartz/dartz.dart';
import '../../../../../lib/core/failures.dart';
import '../../../../../lib/core/usecase.dart';
import '../entities/request.dart';
import '../repository/request_repository.dart';

class GetPriorityRequests implements UseCase<List<Request>, NoParams> {
  final RequestRepository repository;
  GetPriorityRequests(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(NoParams params) {
    return repository.getPriorityRequests();
  }
}