import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../lib/core/usecase.dart';
import '../../domain/usecase/clear_session_usecase.dart';
import '../../domain/usecase/get_saved_session_usecase.dart';
import '../../domain/usecase/login_usecase.dart';
import 'auth_events.dart';
import 'auth_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final GetSavedSessionUseCase getSavedSessionUseCase;
  final ClearSessionUseCase clearSessionUseCase;

  LoginBloc({
    required this.loginUseCase,
    required this.getSavedSessionUseCase,
    required this.clearSessionUseCase,
  }) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginPressed);
    on<KeyboardVisibilityChanged>(_onKeyboardChanged);
    on<LogoutRequested>(_onLogout);
    on<AutoLoginRequested>(_onAutoLoginRequested);
  }

  Future<void> _onAutoLoginRequested(
    AutoLoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await getSavedSessionUseCase(NoParams());
    result.fold((failure) => emit(LoginInitial()), (session) {
      if (session != null) {
        emit(LoginSuccess(session));
      } else {
        emit(LoginInitial());
      }
    });
  }

  Future<void> _onLoginPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await loginUseCase(
      LoginUseCaseParams(
        wardenId: event.wardenId,
        password: event.password,
        remmeberMe: event.rememberMe,
      ),
    );
    result.fold(
      (failure) => emit(LoginFailure(failure.toString())),
      (session) => emit(LoginSuccess(session)),
    );
  }

  void _onKeyboardChanged(
    KeyboardVisibilityChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(event.isOpen ? KeyboardOpen() : KeyboardClosed());
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await clearSessionUseCase(NoParams());
    result.fold(
      (failure) => emit(LoginFailure(failure.toString())),
      (success) => emit(LoginInitial()),
    );
  }
}
