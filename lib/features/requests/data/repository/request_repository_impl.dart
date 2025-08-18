import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';
import 'package:hostel_dayout_app/core/exception.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/network_info.dart';
import 'package:hostel_dayout_app/features/requests/data/datasource/request_remote_datasource.dart';
import 'package:hostel_dayout_app/features/requests/domain/entities/request.dart';
import 'package:hostel_dayout_app/features/requests/domain/repository/request_repository.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/runtime_storage.dart';
import 'package:hostel_dayout_app/injection.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RequestRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final runtimeStorage = sl<RequestStorage>();

  @override
  Future<Either<Failure, List<Request>>> getRequests({
    RequestStatus? filterRequestStatus,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRequests = await remoteDataSource.getRequests();
        runtimeStorage.saveRequests(
          remoteRequests.map((model) => model.toEntity()).toList(),
        );
        runtimeStorage.saveOnScreenRequests(
          remoteRequests.map((model) => model.toEntity()).toList(),
        );
        // Map to domain entities
        return Right(remoteRequests.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Request>> getRequestDetail(String requestId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRequest = await remoteDataSource.getRequestDetail(
          requestId,
        );
        return Right(remoteRequest.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Request>>> getPriorityRequests() async {
    try {
      if (await networkInfo.isConnected) {
        // Fetch from API
        final remoteRequests = await remoteDataSource.getPriorityRequests();

        // Return as entities
        return Right(remoteRequests.map((model) => model.toEntity()).toList());
      } else {
        return Left(NetworkFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Request>>> getRequestbyFilter(
    String? searchTerm,
    RequestStatus? status,
  ) async {
    // Case 1: No filters -> return all requests
    if (status == null && searchTerm == null) {
      return getRequests();
    }

    // Case 2: Status filter applied
    if (status != null) {
      final cachedRequests = runtimeStorage.getRequestsByStatus(status);

      if (searchTerm != null && searchTerm.isNotEmpty) {
        final filteredRequests = cachedRequests.where((request) {
          return request.student.name.toLowerCase().contains(
            searchTerm.toLowerCase(),
          );
        }).toList();
        runtimeStorage.saveOnScreenRequests(filteredRequests);
        return Right(filteredRequests);
      }
      runtimeStorage.saveOnScreenRequests(cachedRequests);
      return Right(cachedRequests);
    }

    // Case 3: Search term only
    final cachedRequests = runtimeStorage.getRequests();
    if (cachedRequests.isNotEmpty) {
      final filteredRequests = cachedRequests.where((request) {
        return request.student.name.toLowerCase().contains(
          searchTerm!.toLowerCase(),
        );
      }).toList();
      runtimeStorage.saveOnScreenRequests(filteredRequests);
      return Right(filteredRequests);
    }

    // Case 4: Search from remote if cache is empty
    try {
      final requests = await remoteDataSource.getRequestsByFilter(
        searchTerm: searchTerm,
        status: null,
      );
      runtimeStorage.saveOnScreenRequests(
        requests.map((model) => model.toEntity()).toList(),
      );
      return Right(requests.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Request>>> updateRequestStatus(
    Map<String, RequestStatus> requestUpdates,
  ) async {
    if (await networkInfo.isConnected) {
      // log everything here in this function
      try {
        final updatedRequests = await remoteDataSource.updateRequestStatus(
          requestUpdates,
        );

        runtimeStorage.updateRequests(
          updatedRequests.map((model) => model.toEntity()).toList(),
        );

        return Right(runtimeStorage.getOnScreenRequests());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Request>> updateRequestDetail(
    Request request,
    RequestStatus updatedStatus,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedRequest = await remoteDataSource.updateRequestDetail(
          request,
          updatedStatus,
        );
        return Right(updatedRequest.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
