import 'package:flutter/material.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:hostel_mgmt/core/helpers/unfocus.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/login/login_form.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:provider/provider.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final selectedTextStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);
    final state = context.watch<LoginState>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: KeyboardDismissOnTap(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ), // also fixed bug: should be const
              child: Column(
                children: [
                  !state.isKeyboardOpen ? Container(height: 200) : Container(),
                  const SizedBox(height: 16),
                  !state.isKeyboardOpen
                      ? SegmentedTabControl(
                          barDecoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          indicatorDecoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tabTextColor: Colors.black,
                          selectedTabTextColor: Colors.white,
                          textStyle: textStyle,
                          selectedTextStyle: selectedTextStyle,
                          squeezeIntensity: 2,
                          tabs: const [
                            SegmentTab(label: 'Student'),
                            SegmentTab(label: 'Warden'),
                            SegmentTab(label: 'Parent'),
                          ],
                        )
                      : Container(),
                  Expanded(
                    child: TabBarView(
                      children: const [
                        LoginPage(actor: TimelineActor.student),
                        LoginPage(actor: TimelineActor.warden),
                        LoginPage(actor: TimelineActor.parent),
                      ],
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
