// lib/requests/presentation/bloc/request_list/request_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:hostel_dayout_app/core/enums/actions.dart';
import '../../domain/entities/request.dart';

abstract class RequestListState extends Equatable {
  const RequestListState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any loading happens
class RequestListInitial extends RequestListState {}

/// Loading state while fetching requests
class RequestListLoading extends RequestListState {}

/// Loaded state with fetched requests
class RequestListLoaded extends RequestListState {
  final List<Request> requests;
  final List<RequestAction> possibleActions;

  const RequestListLoaded(this.requests, this.possibleActions);

  @override
  List<Object?> get props => [requests, possibleActions];
}

class PriorityRequestListLoaded extends RequestListState {
  final List<Request> requests;

  const PriorityRequestListLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

/// Error state with failure message
class RequestListError extends RequestListState {
  final String message;

  const RequestListError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Triggered when a user taps the call button for a specific student
class CallRequestContactEvent extends RequestListState {
  final String phoneNumber;

  const CallRequestContactEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class UpdateRequestList extends RequestListState {
  final List<Request> requests;

  const UpdateRequestList(this.requests);

  @override
  List<Object?> get props => [requests];
}


class OpenDialogState extends RequestListState {
  final RequestAction action;

  const OpenDialogState(this.action);

  @override
  List<Object?> get props => [action];
}