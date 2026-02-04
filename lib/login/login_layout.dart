import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/unfocus.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
// import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/login/login_form.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:hostel_mgmt/presentation/widgets/glass_segmented_button.dart';
import 'package:provider/provider.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // final textStyle = Theme.of(context).textTheme;
    // final selectedTextStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);
    final state = context.watch<LoginState>();
    final mediaQuery = MediaQuery.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/spsu2.jpg'),
          fit: BoxFit.fitHeight,
          alignment: Alignment.center,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: KeyboardDismissOnTap(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!state.isKeyboardOpen) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Image.asset(
                      'assets/spsu_logo.png',
                      fit: BoxFit.contain,
                      height: 50,
                    ),
                  ),

                  Container(
                    height: mediaQuery.size.height * 0.20,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Center(
                      child: Text(
                        'HOSTEL Leave erp'.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: textTheme.h1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1228),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  Container(),
                ],

                Expanded(
                  child: GlassSegmentedTabs(
                    showTabs: !state.isKeyboardOpen,
                    margin: 24,
                    options: const ['Student', 'Warden', 'Parent'],
                    views: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: LoginPage(actor: TimelineActor.student),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: LoginPage(actor: TimelineActor.assistentWarden),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: LoginPage(actor: TimelineActor.parent),
                      ),
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
    );
  }
}

class HostelPassLogo extends StatelessWidget {
  const HostelPassLogo({super.key, this.width = 380, this.height = 150});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // Dark carbon fiber-like backdrop approximation
    final bg = Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141414), Color(0xFF0F0F0F)],
        ),
      ),
    ); // [web:12][web:15]

    // Subtle vignette overlay using ShaderMask (dark edges)
    final vignette = ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black26, Colors.transparent],
          stops: [0.0, 0.5, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.darken,
      child: bg,
    ); // [web:20][web:12]

    // Common text base
    const letterSpacing = 8.0; // Wide tracking like the sample [web:4]
    const fontSize = 64.0;

    // A soft outer glow via text shadows (mimics the image’s subtle bloom)
    const textShadows = [
      Shadow(color: Colors.black54, blurRadius: 2, offset: Offset(0, 0)),
      Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 0)),
    ]; // [web:9][web:13][web:18]

    final hostelText = Text(
      'HOSTEL',
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: letterSpacing,
        color: Color(0xFF14224A), // deep navy
        shadows: textShadows,
      ),
    ); // [web:4][web:19]

    final passText = Text(
      'PASS',
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: letterSpacing,
        color: Color(0xFF9DDB4C), // lime green
        shadows: textShadows,
      ),
    ); // [web:4][web:19]

    // Stack content
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          vignette, // background with vignette [web:20][web:12]
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [hostelText, const SizedBox(height: 8), passText],
            ),
          ),
        ],
      ),
    );
  }
}
