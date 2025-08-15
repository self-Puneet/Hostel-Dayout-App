import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/requests/domain/entities/request.dart';
import 'package:hostel_dayout_app/requests/domain/repository/request_repository.dart';

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
