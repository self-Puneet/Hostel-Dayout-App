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
    // STEP 1: Try local storage (SharedPreferences)
    try {
      final localMap = await local.getSession();
      if (localMap != null) {
        final session = UserSessionModel.fromPrefs(
          token: localMap['token'] as String,
          wardenId: localMap['wardenId'] as String?,
          rememberMe: localMap['rememberMe'] as bool? ?? false,
        );
        return Right(session.toEntity());
      }
    } on CacheException {
      return Left(CacheFailure());
    }

    // STEP 2: Try runtime-only cached session
    if (_cachedSession != null) {
      return Right(_cachedSession!.toEntity());
    }

    // STEP 3: Go remote if connected
    if (await networkInfo.isConnected) {
      try {
        final token = await remote.login(wardenId, password);

        final session = UserSessionModel(
          token: token,
          wardenId: wardenId,
          rememberMe: rememberMe,
        );

        if (rememberMe) {
          try {
            await local.saveSession(token, wardenId, rememberMe);
          } on CacheException {
            return Left(CacheFailure());
          }
          _cachedSession = null;
        } else {
          _cachedSession = session;
          await local.clearSession(); // make sure not persisted accidentally
        }

        return Right(session.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // No connection, no cached session
      return Left(NetworkFailure());
    }
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
