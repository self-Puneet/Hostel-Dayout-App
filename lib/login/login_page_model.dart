import 'package:flutter/material.dart';

class LoginPageModel {
  final String loginTitle;
  final String identityFieldName;
  final String verificationFieldName;
  final String elevatedButtonText;
  final String disabledButtonText;
  final IconData identityFieldIconData;
  final IconData verificationFieldIconData;
  final bool showForgotPassword;
  final bool showResetPassword;

  LoginPageModel({
    required this.loginTitle,
    required this.identityFieldName,
    required this.verificationFieldName,
    required this.elevatedButtonText,
    required this.disabledButtonText,
    required this.identityFieldIconData,
    required this.verificationFieldIconData,
    this.showForgotPassword = true,
    this.showResetPassword = true,
  });
}
