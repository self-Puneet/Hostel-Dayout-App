import 'package:dartz/dartz.dart';
import '../../../../../lib/core/failures.dart';
import '../../../../../lib/core/usecase.dart';
import '../repository/auth_repository.dart';
import '../entity/user_session.dart';

class LoginUseCaseParams {
  final String wardenId;
  final String password;
  final bool remmeberMe;

  LoginUseCaseParams({required this.wardenId, required this.password, required this.remmeberMe});
}

class LoginUseCase implements UseCase<UserSession, LoginUseCaseParams>{
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserSession>> call(LoginUseCaseParams params) {
    return repository.login(params.wardenId, params.password, params.remmeberMe);
  }
}
