import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/exception.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/network_info.dart';
import 'package:hostel_dayout_app/requests/data/datasource/request_local_datasource.dart';
import 'package:hostel_dayout_app/requests/data/datasource/request_remote_datasource.dart';
import 'package:hostel_dayout_app/requests/domain/entities/request.dart'
    as domain; // alias to avoid clash
import 'package:hostel_dayout_app/requests/domain/repository/request_repository.dart';
import 'package:http/http.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;
  final RequestLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RequestRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<domain.Request>>> getRequests({
    String? searchQuery,
    String? sortOrder,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        print("6" * 89);
        final remoteRequests = await remoteDataSource.getRequests(
          searchQuery: searchQuery,
          sortOrder: sortOrder,
        );

        // Cache fetched data locally
        await localDataSource.cacheRequests(remoteRequests);

        // Map to domain entities
        return Right(remoteRequests.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure());
      }
    }

    // Fallback to local cache if offline
    try {
      final localRequests = await localDataSource.getCachedRequests();
      return Right(localRequests.map((model) => model.toEntity()).toList());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, domain.Request>> getRequestDetail(
    String requestId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRequest = await remoteDataSource.getRequestDetail(
          requestId,
        );

        // Cache this single request
        await localDataSource.cacheRequest(remoteRequest);

        return Right(remoteRequest.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      }
    }

    // Fallback to local cache if offline
    try {
      final localRequest = await localDataSource.getCachedRequestById(
        requestId,
      );
      if (localRequest != null) {
        return Right(localRequest.toEntity());
      } else {
        return Left(CacheFailure());
      }
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<domain.Request>>> getPriorityRequests() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRequest = await remoteDataSource.getPriorityRequests();

        // remoteRequest is a list of request models
        return Right(remoteRequest.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    {
      // return a empty list.
      return Right([]);
    }
  }
}
