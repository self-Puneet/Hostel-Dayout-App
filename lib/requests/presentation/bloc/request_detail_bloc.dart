import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:hostel_dayout_app/requests/domain/entities/request.dart';
import 'package:hostel_dayout_app/requests/domain/usecase/get_request_detail.dart';
import 'request_detail_event.dart';
import 'request_detail_state.dart';

class RequestDetailBloc extends Bloc<RequestDetailEvent, RequestDetailState> {
  final GetRequestDetail getRequestDetail;

  RequestDetailBloc({required this.getRequestDetail})
    : super(RequestDetailInitial()) {
    on<LoadRequestDetailEvent>(_onRequestSelected);
  }

  Future<void> _onRequestSelected(
    LoadRequestDetailEvent event,
    Emitter<RequestDetailState> emit,
  ) async {
    emit(RequestDetailLoading());

    final Either<Failure, Request> result = await getRequestDetail(
      GetRequestDetailParams(event.requestId),
    );

    result.fold(
      (failure) => emit(RequestDetailError(_mapFailureToMessage(failure))),
      (request) => emit(RequestDetailLoaded(request)),
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
