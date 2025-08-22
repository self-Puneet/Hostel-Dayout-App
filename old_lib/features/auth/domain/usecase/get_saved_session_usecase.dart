import 'package:dartz/dartz.dart';
import '../../../../../lib/core/failures.dart';
import '../../../../../lib/core/usecase.dart';
import '../repository/auth_repository.dart';
import '../entity/user_session.dart';

class GetSavedSessionUseCase extends UseCase<UserSession?, NoParams> {
  final AuthRepository repository;
  GetSavedSessionUseCase(this.repository);

  @override
  Future<Either<Failure, UserSession?>> call(NoParams params) {
    return repository.getSavedSession();
  }
}
