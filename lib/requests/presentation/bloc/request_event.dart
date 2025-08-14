// lib/requests/presentation/bloc/request_list/request_list_event.dart
import 'package:equatable/equatable.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';

abstract class RequestListEvent extends Equatable {
  const RequestListEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the page should load requests (e.g., on init or refresh)
class LoadRequestsEvent extends RequestListEvent {
  final RequestStatus? filterRequestStatus;
  final String? searchTerm;

  const LoadRequestsEvent({this.filterRequestStatus, this.searchTerm});

  @override
  List<Object?> get props => [filterRequestStatus, searchTerm];
}

/// Triggered when a user taps on a specific request card
class RequestSelectedEvent extends RequestListEvent {
  final String requestId;

  const RequestSelectedEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

/// Triggered when a user comes on the home screen and get priority requests
class LoadPriorityRequestsEvent extends RequestListEvent {
  const LoadPriorityRequestsEvent();

  @override
  List<Object?> get props => [];
}


// write a event function for loading requests by request status
class LoadRequestsByFilterEvent extends RequestListEvent {
  final RequestStatus? status;
  final String? searchTerm;

  const LoadRequestsByFilterEvent(this.status, this.searchTerm);

  @override
  List<Object?> get props => [status, searchTerm];
}