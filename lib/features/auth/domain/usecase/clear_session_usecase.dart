import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/features/auth/domain/repository/auth_repository.dart';

class ClearSessionUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;
  ClearSessionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearSession(); 
  }
}
