import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_events.dart';
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:hostel_dayout_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:hostel_dayout_app/features/auth/presentation/widgets/customm_text_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_dayout_app/features/auth/presentation/pages/_keyboard_visibility_observer.dart';
import '_keyboard_visibility_observer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final _keyboardObserver = KeyboardVisibilityObserver(
    onKeyboardClosed: () {
      final bloc = context.read<LoginBloc>();
      bloc.add(KeyboardVisibilityChanged(false));
    },
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_keyboardObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_keyboardObserver);
    _wardenIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _wardenIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool isKeyboardOpen = false;

  // @override
  // void dispose() {
  //   _wardenIdController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  void _onLoginPressed(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    bloc.add(
      LoginButtonPressed(
        _wardenIdController.text.trim(),
        _passwordController.text.trim(),
        _rememberMe,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Welcome, ${state.session.wardenId}!")),
            );
            // Navigate to the next page or home screen using go route
            context.go('/home');
          }
          if (state is KeyboardOpen) {
            isKeyboardOpen = true;
          } else if (state is KeyboardClosed) {
            isKeyboardOpen = false;
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  !isKeyboardOpen
                      ? Image.asset('assets/login.png', height: 250)
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  /// 🟢 Warden ID field
                  CustomTextField(
                    controller: _wardenIdController,
                    label: "Warden ID",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),

                  /// 🟢 Password field
                  CustomTextField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  /// 🟢 Remember Me
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (val) {
                          setState(() => _rememberMe = val ?? false);
                        },
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// 🟢 Login button
                  state is LoginLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Login",
                          onPressed: () => _onLoginPressed(context),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
