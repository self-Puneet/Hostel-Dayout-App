import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/features/auth/domain/repository/auth_repository.dart';
import 'package:hostel_dayout_app/features/auth/domain/entity/user_session.dart';

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
