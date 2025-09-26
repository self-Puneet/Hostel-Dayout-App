import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
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
                    context.go(AppRoutes.profile);
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
              // Option A: use backgroundImage
              backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
              // If using foregroundImage instead, same condition applies:
              // foregroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,

              // Show initials only when no URL
              child: hasAvatar
                  ? null
                  : Text(
                      name.initials,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.0,
                        letterSpacing: 0.0,
                        color: Colors.black87,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  textHeightBehavior: const TextHeightBehavior(
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.0, // 100% line-height
                    letterSpacing: 0.0, // 0% letter-spacing
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
          ),
          LiquidGlassChip(label: pillText),
          // const SizedBox(width: 12),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade200,
          //     borderRadius: BorderRadius.circular(18),
          //     boxShadow: const [
          //       BoxShadow(
          //         color: Color(0x11000000),
          //         blurRadius: 6,
          //         offset: Offset(0, 2),
          //       ),
          //     ],
          //   ),
          //   child: Text(
          //     pillText,
          //     style: const TextStyle(
          //       fontFamily: 'Poppins',
          //       fontSize: 14,
          //       fontWeight: FontWeight.w500,
          //       height: 1.0,
          //       letterSpacing: 0.0,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
