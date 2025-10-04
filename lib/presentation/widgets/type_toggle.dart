import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';

class TypeToggle extends StatelessWidget {
  final RequestType selected;
  final ValueChanged<RequestType> onChanged;

  const TypeToggle({Key? key, required this.selected, required this.onChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OptionCard(
            isActive: selected == RequestType.dayout,
            icon: Icons.directions_walk, // footsteps-like
            iconColor: const Color(0xFF4485F6),
            title: "Day-out",
            subtitle: "Same day return",
            onTap: () => onChanged(RequestType.dayout),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _OptionCard(
            isActive: selected == RequestType.leave,
            icon: Icons.luggage_outlined, // suitcase
            iconColor: const Color(0xFF9B6BFF),
            title: "Leave",
            subtitle: "Multi-day absence",
            onTap: () => onChanged(RequestType.leave),
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    Key? key,
    required this.isActive,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Color borderColor = isActive
        ? const Color(0xFF3B82F6)
        : const Color(0x22000000);
    final Color fillColor = isActive ? const Color(0xFFF0F6FF) : Colors.white;

    return AspectRatio(
      aspectRatio: 1.25, // square shape
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: isActive ? 2 : 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                spreadRadius: 0,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: textTheme.h4.w500,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: textTheme.h6.w500,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
