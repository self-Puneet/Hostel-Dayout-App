import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/unfocus.dart';
import 'package:hostel_mgmt/core/theme/elevated_button_theme.dart';

import 'package:hostel_mgmt/login/login_state.dart';

import 'package:provider/provider.dart';
import 'login_controller.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';

class LoginPage extends StatelessWidget {
  final TimelineActor actor; // 👈 decides which login config to use
  const LoginPage({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginState>();
    final controller = LoginController(state);

    // pull the correct model + controllers for this actor
    final loginModel = state.textFieldMap[actor]?[FieldsType.model];
    final identityController =
        state.textFieldMap[actor]?[FieldsType.identityField];
    final verificationController =
        state.textFieldMap[actor]?[FieldsType.verificationField];

    final otherFunctionalities = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        loginModel.showForgotPassword
            ? TextButton(
                onPressed: () => controller.forgotPassword(context, actor),
                child: const Text("Forgot Password?"),
              )
            : const SizedBox.shrink(),
        loginModel.showResetPassword
            ? TextButton(
                onPressed: () =>
                    LoginController.doResetPassword(context, actor),
                child: const Text("Reset Password"),
              )
            : const SizedBox.shrink(),
      ],
    );

    final varificationField = TextField(
      controller: verificationController,
      obscureText: loginModel.verificationFieldName.toLowerCase().contains(
        "password",
      ), // 👈 only hide if "password"
      decoration: InputDecoration(
        labelText: loginModel.verificationFieldName,
        prefixIcon: Icon(loginModel.verificationFieldIconData),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final identityField = TextField(
      controller: identityController,
      decoration: InputDecoration(
        labelText: loginModel.identityFieldName,
        prefixIcon: Icon(loginModel.identityFieldIconData),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final formTitle = Text(
      loginModel.loginTitle,
      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    );

    // Warden type selector row (only for assistentWarden)
    final wardenTypeSelector = actor == TimelineActor.assistentWarden
        ? (!state.isKeyboardOpen)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'warden',
                          groupValue: state.wardenType,
                          onChanged: (val) {
                            if (val != null) state.setWardenType(val);
                          },
                        ),
                        const Text('Assistant\nWarden'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'senior_warden',
                          groupValue: state.wardenType,
                          onChanged: (val) {
                            if (val != null) state.setWardenType(val);
                          },
                        ),
                        const Text('Senior\nWarden'),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink()
        : const SizedBox.shrink();

    final loginButton = !state.isLoggingIn
        ? ElevatedButton(
            onPressed: () => controller.login(context, actor), // 👈 pass actor
            child: Text(
              loginModel.elevatedButtonText,
              style: const TextStyle(fontSize: 16),
            ),
          )
        : DisabledElevatedButton(text: loginModel.disabledButtonText);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: KeyboardDismissOnTap(
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    formTitle,
                    const SizedBox(height: 24),
                    wardenTypeSelector,
                    const SizedBox(height: 16),
                    identityField,
                    const SizedBox(height: 16),
                    varificationField,
                    const SizedBox(height: 24),
                    loginButton,
                    const SizedBox(height: 16),
                    otherFunctionalities,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
