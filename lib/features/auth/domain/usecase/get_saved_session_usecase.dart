import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/features/auth/domain/repository/auth_repository.dart';
import 'package:hostel_dayout_app/features/auth/domain/entity/user_session.dart';

class GetSavedSessionUseCase extends UseCase<UserSession?, NoParams> {
  final AuthRepository repository;
  GetSavedSessionUseCase(this.repository);

  @override
  Future<Either<Failure, UserSession?>> call(NoParams params) {
    return repository.getSavedSession();
  }
}
