import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/requests/domain/entities/request.dart';
import 'package:hostel_dayout_app/requests/domain/repository/request_repository.dart';

class GetPriorityRequests implements UseCase<List<Request>, NoParams> {
  final RequestRepository repository;
  GetPriorityRequests(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(NoParams params) {
    return repository.getPriorityRequests();
  }
}