import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/unfocus.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/login/login_form.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:hostel_mgmt/presentation/widgets/glass_segmented_button.dart';
import 'package:provider/provider.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // final textStyle = Theme.of(context).textTheme.bodyLarge;
    // final selectedTextStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);
    final state = context.watch<LoginState>();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/hostel_image.png'),
          fit: BoxFit.fitHeight,
          alignment: Alignment.center,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: KeyboardDismissOnTap(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  if (!state.isKeyboardOpen)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/hero1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                  // const SizedBox(height: 200),

                  // Replace SegmentedTabControl + TabBarView with your GlassSegmentedTabs
                  // if (!state.isKeyboardOpen)
                  Expanded(
                    child: GlassSegmentedTabs(
                      showTabs: !state.isKeyboardOpen,
                      options: const ['Student', 'Warden', 'Parent'],
                      views: const [
                        LoginPage(actor: TimelineActor.student),
                        LoginPage(actor: TimelineActor.assistentWarden),
                        LoginPage(actor: TimelineActor.parent),
                      ],
                      labelFontSize: 14,
                      selectedLabelFontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
