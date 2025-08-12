// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]) : super();

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
