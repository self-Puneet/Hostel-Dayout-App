import 'package:flutter/material.dart';

class CallOverlayIcon extends StatelessWidget {
  const CallOverlayIcon({
    super.key,
    this.size = 40,
    this.baseColor = const Color(0xFF22C55E),
    this.iconColor = Colors.white,
    this.badgeBg = Colors.white,
    this.badgeIconColor = Colors.black87,
    this.badge = Icons.person,
    this.tooltip,
    this.onTap,
  });

  final double size;
  final Color baseColor;
  final Color iconColor;
  final Color badgeBg;
  final Color badgeIconColor;
  final IconData badge;
  final String? tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final badgeSize = size * 0.44;

    Widget content = SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Base circular phone
          DecoratedBox(
            decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
            child: Center(
              child: Icon(Icons.call, size: size * 0.54, color: iconColor),
            ),
          ),
          // Bottom-right badge
          Positioned(
            right: -size * 0.06,
            bottom: -size * 0.06,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: badgeBg,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  badge,
                  size: badgeSize * 0.6,
                  color: badgeIconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (tooltip != null) {
      content = Tooltip(message: tooltip!, child: content);
    }

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: content,
        ),
      );
    }

    return Semantics(
      button: onTap != null,
      label: tooltip ?? 'Call',
      child: content,
    );
  }
}

// Specializations
class CallGuardianIcon extends StatelessWidget {
  const CallGuardianIcon({super.key, this.size = 40, this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CallOverlayIcon(
      size: size,
      badge: Icons.home, // Guardian
      tooltip: 'Call guardian',
      onTap: onTap,
      baseColor: const Color(0xFF16A34A),
      badgeBg: Colors.white,
      badgeIconColor: const Color(0xFF16A34A),
    );
  }
}

class CallStudentIcon extends StatelessWidget {
  const CallStudentIcon({super.key, this.size = 40, this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CallOverlayIcon(
      size: size,
      badge: Icons.school, // Student
      tooltip: 'Call student',
      onTap: onTap,
      baseColor: const Color(0xFF2563EB),
      badgeBg: Colors.white,
      badgeIconColor: const Color(0xFF2563EB),
    );
  }
}
