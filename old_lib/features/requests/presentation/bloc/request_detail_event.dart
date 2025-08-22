// make a abstract class for request details events
import 'package:equatable/equatable.dart';
import '../../../../../lib/core/enums/request_status.dart';
import '../../domain/entities/request.dart';

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

class UpdateRequestDetailEvent extends RequestDetailEvent {
  final RequestStatus updatedStatuse;
  final Request request;

  const UpdateRequestDetailEvent({
    required this.updatedStatuse,
    required this.request,
  });

  @override
  List<Object?> get props => [updatedStatuse, request];
}
