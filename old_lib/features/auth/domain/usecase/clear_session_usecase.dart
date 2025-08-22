import 'package:dartz/dartz.dart';
import '../../../../../lib/core/failures.dart';
import '../../../../../lib/core/usecase.dart';
import '../repository/auth_repository.dart';

class ClearSessionUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;
  ClearSessionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearSession(); 
  }
}
