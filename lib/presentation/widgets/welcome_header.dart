import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/util/string_extensions.dart';
import 'package:hostel_mgmt/login/login_controller.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/liquid_glass_chip.dart';
import 'package:hostel_mgmt/presentation/widgets/profile_overlay.dart';
import 'package:intl/intl.dart';

class WelcomeHeader extends StatelessWidget {
  final String name;
  final DateTime date;
  final TimelineActor actor;
  final String? avatarUrl; // nullable URL
  final String greeting;
  final String? enrollmentNumber;
  final String? phoneNumber;
  final String? hostelName;
  final String? roomNumber;

  WelcomeHeader({
    super.key,
    required this.name,
    this.avatarUrl,
    this.greeting = 'Welcome back,',
    required this.actor,
    DateTime? date,
    this.enrollmentNumber,
    this.phoneNumber,
    this.hostelName,
    this.roomNumber,
  }) : date = date ?? DateTime.now();

  // Derive initials from a full name (e.g., "Alvaro Morte" -> "AM").
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pillText = DateFormat('EEE, MMM d').format(date); // Thu, Aug 27
    final hasAvatar = (avatarUrl?.trim().isNotEmpty ?? false);
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) => ProfileOverlay(
                  name: name,
                  subtitle: actor.displayName,
                  avatarUrl: avatarUrl,
                  onEditProfile: () {
                    // go route for AppRoutes.profile
                    context.go(
                      (actor == TimelineActor.assistentWarden ||
                              actor == TimelineActor.seniorWarden)
                          ? AppRoutes.wardenProfile
                          : AppRoutes.profile,
                    );
                    // context.go(AppRoutes.wardenProfile);
                    Navigator.pop(context);
                    debugPrint("Edit Profile clicked");
                  },
                  onLogout: () {
                    LoginController.logout(context);
                    Navigator.pop(context);
                    debugPrint("Logout clicked");
                  },
                  onClose: () => Navigator.pop(context),
                  enrollmentNumber: enrollmentNumber,
                  hostelName: hostelName,
                  roomNo: roomNumber,
                  phoneNumber: phoneNumber,
                ),
              );
            },

            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
              child: hasAvatar
                  ? null
                  : Text(name.initials, style: textTheme.h3.w500),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: textTheme.h5),
                Text(name, style: textTheme.h2),
              ],
            ),
          ),
          LiquidGlassChip(label: pillText),
        ],
      ),
    );
  }
}
