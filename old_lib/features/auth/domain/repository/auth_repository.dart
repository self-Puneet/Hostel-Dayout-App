import 'package:dartz/dartz.dart';
import '../../../../../lib/core/failures.dart';
import '../entity/user_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserSession>> login(
    String wardenId,
    String password,
    bool rememberMe,
  );
  Future<Either<Failure, UserSession?>> getSavedSession();
  Future<Either<Failure, void>> clearSession();
}
