import 'package:equatable/equatable.dart';
import '../../domain/entities/request.dart';

abstract class RequestDetailState extends Equatable {
  const RequestDetailState();

  @override
  List<Object?> get props => [];
}

class RequestDetailInitial extends RequestDetailState {}

class RequestDetailLoading extends RequestDetailState {}

class RequestDetailLoaded extends RequestDetailState {
  final Request request;
  const RequestDetailLoaded(this.request);

  @override
  List<Object?> get props => [request];
}

class RequestDetailError extends RequestDetailState {
  final String message;
  const RequestDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
