import '../../domain/entity/user_session.dart';

class UserSessionModel {
  final String token;
  final String wardenId;
  final bool rememberMe;

  const UserSessionModel({
    required this.token,
    required this.wardenId,
    required this.rememberMe,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      token: json['token'] as String,
      wardenId: json['wardenId'] as String? ?? '',
      rememberMe: json['rememberMe'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'wardenId': wardenId,
    'rememberMe': rememberMe,
  };

  // Helper for local storage (SharedPreferences)
  factory UserSessionModel.fromPrefs({
    required String token,
    required String? wardenId,
    required bool rememberMe,
  }) {
    return UserSessionModel(
      token: token,
      wardenId: wardenId ?? '',
      rememberMe: rememberMe,
    );
  }

  // to UserSession

  factory UserSessionModel.fromEntity(UserSession entity) {
    return UserSessionModel(
      token: entity.token,
      wardenId: entity.wardenId,
      rememberMe: entity.rememberMe,
    );
  }

  UserSession toEntity() {
    return UserSession(
      token: token,
      wardenId: wardenId,
      rememberMe: rememberMe,
    );
  }
}
