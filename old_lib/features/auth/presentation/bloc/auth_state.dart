import '../../domain/entity/user_session.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final UserSession session;
  LoginSuccess(this.session);
}
class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}
class KeyboardOpen extends LoginState {}
class KeyboardClosed extends LoginState {}
