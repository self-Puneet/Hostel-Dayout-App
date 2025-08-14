// make a abstract class for request details events
import 'package:equatable/equatable.dart';

abstract class RequestDetailEvent extends Equatable {
  const RequestDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when a user wants to load a specific request's details
class LoadRequestDetailEvent extends RequestDetailEvent {
  final String requestId;

  const LoadRequestDetailEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
