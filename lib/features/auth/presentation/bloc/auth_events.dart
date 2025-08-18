abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String wardenId;
  final String password;
  final bool rememberMe;

  LoginButtonPressed(this.wardenId, this.password, this.rememberMe);
}

class KeyboardVisibilityChanged extends LoginEvent {
  final bool isOpen;
  KeyboardVisibilityChanged(this.isOpen);
}

class AutoLoginRequested extends LoginEvent {}
class LogoutRequested extends LoginEvent {}
