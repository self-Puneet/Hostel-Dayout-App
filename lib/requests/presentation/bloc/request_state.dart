// lib/requests/presentation/bloc/request_list/request_list_state.dart
import 'package:equatable/equatable.dart';
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

  const RequestListLoaded(this.requests);

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
