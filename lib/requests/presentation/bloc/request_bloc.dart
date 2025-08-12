// lib/requests/presentation/bloc/request_list/request_list_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/core/usecase.dart';
import 'package:hostel_dayout_app/requests/domain/entities/request.dart';
import 'package:hostel_dayout_app/requests/domain/usecase/get_priority_request.dart';
import 'package:hostel_dayout_app/requests/domain/usecase/get_request_detail.dart';
import 'package:hostel_dayout_app/requests/domain/usecase/get_requests.dart';
import 'package:hostel_dayout_app/requests/presentation/bloc/request_event.dart';
import 'package:hostel_dayout_app/requests/presentation/bloc/request_state.dart';

class RequestListBloc extends Bloc<RequestListEvent, RequestListState> {
  final GetRequests getAllRequests;
  final GetRequestDetail getRequestDetail;
  final GetPriorityRequests getPriorityRequests;

  RequestListBloc({
    required this.getAllRequests,
    required this.getRequestDetail,
    required this.getPriorityRequests,
  }) : super(RequestListInitial()) {
    on<LoadRequestsEvent>(_onLoadRequests);
    on<RequestSelectedEvent>(_onRequestSelected);
    on<GetPriorityRequestsEvent>(_onPriorityRequests);
  }

  Future<void> _onLoadRequests(
    LoadRequestsEvent event,
    Emitter<RequestListState> emit,
  ) async {
    emit(RequestListLoading());

    final Either<Failure, List<Request>> result = await getAllRequests(
      GetRequestsParams(
        searchQuery: event.searchQuery,
        sortOrder: event.sortOrder,
      ),
    );

    print(result);

    result.fold(
      (failure) => emit(RequestListError(_mapFailureToMessage(failure))),
      (requests) => emit(RequestListLoaded(requests)),
    );
  }

  Future<void> _onRequestSelected(
    RequestSelectedEvent event,
    Emitter<RequestListState> emit,
  ) async {
    emit(RequestListLoading());

    final Either<Failure, Request> result = await getRequestDetail(
      GetRequestDetailParams(event.requestId),
    );

    result.fold(
      (failure) => emit(RequestListError(_mapFailureToMessage(failure))),
      (request) => emit(RequestListLoaded([request])),
    );
  }

  // implement _onPriorityRequests
  Future<void> _onPriorityRequests(
    GetPriorityRequestsEvent event,
    Emitter<RequestListState> emit,
  ) async {
    emit(RequestListLoading());

    final Either<Failure, List<Request>> result = await getPriorityRequests(NoParams());

    result.fold(
      (failure) => emit(RequestListError(_mapFailureToMessage(failure))),
      (requests) => emit(RequestListLoaded(requests)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return "Server error occurred";
      case CacheFailure _:
        return "No cached data available";
      default:
        return "Unexpected error occurred";
    }
  }
}
