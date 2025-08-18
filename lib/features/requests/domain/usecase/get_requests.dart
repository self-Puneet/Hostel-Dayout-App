// lib/domain/usecases/get_requests.dart
import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/features/requests/domain/repository/request_repository.dart';
import '../entities/request.dart';

class GetRequests implements UseCase<List<Request>, RequestStatus?> {
  final RequestRepository repository;
  GetRequests(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(RequestStatus? params) {
    return repository.getRequests(filterRequestStatus: params);
  }
}
