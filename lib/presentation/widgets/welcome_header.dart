import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/liquid_glass_chip.dart';
import 'package:intl/intl.dart';

class WelcomeHeader extends StatelessWidget {
  final String name;
  final DateTime date;
  final String? avatarUrl; // nullable URL
  final String greeting;

  WelcomeHeader({
    super.key,
    required this.name,
    this.avatarUrl,
    this.greeting = 'Welcome back,',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  // Derive initials from a full name (e.g., "Alvaro Morte" -> "AM").
  @override
  Widget build(BuildContext context) {
    final pillText = DateFormat('EEE, MMM d').format(date); // Thu, Aug 27

    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade300,
            // Use the network image only when available
            // foregroundImage: hasUrl ? NetworkImage(avatarUrl!) : null,
            foregroundImage: AssetImage("assets/profile_pic_demo.png"),
            // Fallback to initials when no URL
            // child: hasUrl
            //     ? null
            //     : Text(
            //         _initials(name),
            //         style: const TextStyle(
            //           fontFamily: 'Poppins',
            //           fontWeight: FontWeight.w600,
            //           fontSize: 14,
            //           height: 1.0,
            //           letterSpacing: 0.0,
            //           color: Colors.black87,
            //         ),
            //       ),
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
