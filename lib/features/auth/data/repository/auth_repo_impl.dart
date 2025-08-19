import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/exception.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/network_info.dart';
import 'package:hostel_dayout_app/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:hostel_dayout_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:hostel_dayout_app/features/auth/domain/repository/auth_repository.dart';
import 'package:hostel_dayout_app/features/auth/domain/entity/user_session.dart';
import '../models/user_session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  final NetworkInfo networkInfo;

  UserSessionModel? _cachedSession; // runtime-only cache

  AuthRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserSession>> login(
    String wardenId,
    String password,
    bool rememberMe,
  ) async {
    // Static login: always succeed, no token, no cache, no network
    final session = UserSession(
      token: 'static-token',
      wardenId: wardenId,
      rememberMe: rememberMe,
    );
    return Right(session);
  }

  @override
  Future<Either<Failure, UserSession?>> getSavedSession() async {
    try {
      // 1) Try persisted session
      final map = await local.getSession();
      if (map != null) {
        final session = UserSessionModel.fromPrefs(
          token: map['token'] as String,
          wardenId: map['wardenId'] as String?,
          rememberMe: map['rememberMe'] as bool? ?? false,
        );
        return Right(session.toEntity());
      }

      // 2) Fallback to runtime-only cache
      if (_cachedSession != null) {
        return Right(_cachedSession!.toEntity());
      }

      // 3) No session
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearSession() async {
    if (await networkInfo.isConnected) {
      try {
        _cachedSession = null;
        final result = await local.clearSession();
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
