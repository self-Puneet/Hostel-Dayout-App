// lib/requests/presentation/bloc/request_list/request_list_event.dart
import 'package:equatable/equatable.dart';

abstract class RequestListEvent extends Equatable {
  const RequestListEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the page should load requests (e.g., on init or refresh)
class LoadRequestsEvent extends RequestListEvent {
  final String? searchQuery;
  final String? sortOrder;

  const LoadRequestsEvent({this.searchQuery, this.sortOrder});

  @override
  List<Object?> get props => [searchQuery, sortOrder];
}

/// Triggered when a user taps on a specific request card
class RequestSelectedEvent extends RequestListEvent {
  final String requestId;

  const RequestSelectedEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

/// Triggered when a user comes on the home screen and get priority requests
class GetPriorityRequestsEvent extends RequestListEvent {
  const GetPriorityRequestsEvent();

  @override
  List<Object?> get props => [];
}