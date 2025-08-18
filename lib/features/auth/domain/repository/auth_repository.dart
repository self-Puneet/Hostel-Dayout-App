import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/features/auth/domain/entity/user_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserSession>> login(
    String wardenId,
    String password,
    bool rememberMe,
  );
  Future<Either<Failure, UserSession?>> getSavedSession();
  Future<Either<Failure, void>> clearSession();
}
