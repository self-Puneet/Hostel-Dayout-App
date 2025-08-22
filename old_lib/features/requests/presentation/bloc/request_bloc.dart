// lib/requests/presentation/bloc/request_list/request_list_bloc.dart
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../lib/core/failures.dart';
import '../../../../../lib/core/usecase.dart';
import '../../domain/entities/request.dart';
import '../../domain/usecase/get_priority_request.dart';
import '../../domain/usecase/get_request_detail.dart';
import '../../domain/usecase/get_requests.dart';
import '../../domain/usecase/get_status_filter.dart';
import '../../domain/usecase/update_requests.dart';
import 'action_mapping.dart';
import 'request_event.dart';
import 'request_state.dart';

class RequestListBloc extends Bloc<RequestListEvent, RequestListState> {
  final GetRequests getAllRequests;
  final GetRequestDetail getRequestDetail;
  final GetPriorityRequests getPriorityRequests;
  final GetFilterRequest getFilterRequest;
  final UpdateRequest updateRequests;

  RequestListBloc({
    required this.getAllRequests,
    required this.getRequestDetail,
    required this.getPriorityRequests,
    required this.getFilterRequest,
    required this.updateRequests,
  }) : super(RequestListInitial()) {
    on<LoadRequestsEvent>(_onLoadRequests);
    on<RequestSelectedEvent>(_onRequestSelected);
    on<LoadPriorityRequestsEvent>(_onPriorityRequests);
    on<LoadRequestsByFilterEvent>(_onLoadRequestsByFilter);
    on<UpdateRequestsEvent>(_onUpdateRequests);
  }

  Future<void> _onLoadRequests(
    LoadRequestsEvent event,
    Emitter<RequestListState> emit,
  ) async {
    emit(RequestListLoading());

    final Either<Failure, List<Request>> result = await getAllRequests(
      event.filterRequestStatus,
    );

    result.fold(
      (failure) => emit(RequestListError(_mapFailureToMessage(failure))),
      (requests) => emit(
        RequestListLoaded(
          requests,
          ActionMapping.getPossibleActionsForOnScreenRequests(),
        ),
      ),
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
      (request) => emit(
        RequestListLoaded([
          request,
        ], ActionMapping.getPossibleActionsForOnScreenRequests()),
      ),
    );
  }

  // implement _onPriorityRequests
  Future<void> _onPriorityRequests(
    LoadPriorityRequestsEvent event,
    Emitter<RequestListState> emit,
  ) async {
    emit(RequestListLoading());

    final Either<Failure, List<Request>> result = await getPriorityRequests(
      NoParams(),
    );

    result.fold(
      (failure) => emit(RequestListError(_mapFailureToMessage(failure))),
      (requests) => emit(PriorityRequestListLoaded(requests)),
    );
  }

  Future<void> _onLoadRequestsByFilter(
    LoadRequestsByFilterEvent event,
    Emitter<RequestListState> emit,
  ) async {
    emit(RequestListLoading());

    final Either<Failure, List<Request>> result = await getFilterRequest(
      GetRequestByFilterParams(
        status: event.status,
        searchTerm: event.searchTerm,
      ),
    );

    result.fold(
      (failure) => emit(RequestListError(_mapFailureToMessage(failure))),
      (requests) => emit(
        RequestListLoaded(
          requests,
          ActionMapping.getPossibleActionsForOnScreenRequests(),
        ),
      ),
    );
  }

  Future<void> _onUpdateRequests(
    UpdateRequestsEvent event,
    Emitter<RequestListState> emit,
  ) async {
    emit(RequestListLoading());
    print('puneet' * 78);

    final updatedRequests = await updateRequests(event.updatedStatuses);

    updatedRequests.fold(
      (failure) => emit(RequestListError(_mapFailureToMessage(failure))),
      (requests) => emit(
        RequestListLoaded(
          requests,
          ActionMapping.getPossibleActionsForOnScreenRequests(),
        ),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return "Server error occurred";
      case NetworkFailure _:
        return "No internet connection";
      default:
        return "Unexpected error occurred";
    }
  }
}
