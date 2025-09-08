import 'package:flutter/material.dart';
import 'package:hostel_mgmt/login/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import '../state/parent_state.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.size.width / 402,
    );
    return Consumer<ParentState>(
      builder: (context, state, _) {
        final loginSession = Get.find<LoginSession>();
        return Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height * 50 / 874),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    LoginController.logout(context);
                    // Handle button press
                  },
                  child: Text('Elevated Button'),
                ),
                Container(
                  margin: padding,
                  child: WelcomeHeader(
                    actor: loginSession.role,
                    name: loginSession.username,
                    avatarUrl: loginSession.imageURL,
                    greeting: 'Welcome back,',
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: padding,
                  child: Column(
                    children: [Center(child: Text('Your Child Widget'))],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
