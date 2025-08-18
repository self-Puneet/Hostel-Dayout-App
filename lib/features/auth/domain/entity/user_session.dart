import 'package:equatable/equatable.dart';

class UserSession extends Equatable{
  final String token;
  final String wardenId;
  final bool rememberMe;

  const UserSession({
    required this.token,
    required this.wardenId,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [token, wardenId, rememberMe];

  
}
