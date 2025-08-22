// lib/domain/usecases/get_requests.dart
import 'package:dartz/dartz.dart';
import '../../../../../lib/core/enums/request_status.dart';
import '../../../../../lib/core/failures.dart';
import '../../../../../lib/core/usecase.dart';
import '../repository/request_repository.dart';
import '../entities/request.dart';

class GetRequests implements UseCase<List<Request>, RequestStatus?> {
  final RequestRepository repository;
  GetRequests(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(RequestStatus? params) {
    return repository.getRequests(filterRequestStatus: params);
  }
}
