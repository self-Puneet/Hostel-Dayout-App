import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/models/restriction_window.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
import 'package:hostel_mgmt/presentation/widgets/skeleton_circle.dart';

class RestrictionCard extends StatelessWidget {
  final RestrictionWindow? restriction;
  final bool isLoading;
  final bool isApplicable;
  final VoidCallback? onRetry;

  const RestrictionCard({
    Key? key,
    required this.restriction,
    required this.isLoading,
    required this.isApplicable,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // ~10% black
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: _buildContent(context),
    );

    return Opacity(
      opacity: isApplicable ? 1.0 : 0.5,
      child: AbsorbPointer(absorbing: !isApplicable, child: card),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 66,
        child: Center(
          child: Row(
            children: [
              shimmerCircle(size: 35),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(width: 60, height: 18, borderRadius: 10),
                  const SizedBox(height: 4),
                  shimmerBox(width: 180, height: 18, borderRadius: 10),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (restriction == null) {
      return _errorRow(
        context: context,
        leading: Icon(Icons.error_outline, color: colorScheme.error),
        title: "Unable to load restriction",
        subtitle: "Check connection or try again.",
        showRetry: onRetry != null,
      );
    }

    if (restriction!.errroLoading == true) {
      return _errorRow(
        context: context,
        leading: Icon(Icons.error_outline, color: colorScheme.error),
        title: "Error loading restriction",
        subtitle: restriction!.note.isNotEmpty
            ? restriction!.note
            : "Please try again shortly.",
        showRetry: onRetry != null,
      );
    }

    final r = restriction!;
    final isAllowed = r.allowedToday;
    final icon = isAllowed
        ? Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.green[700],
            size: 35,
          )
        : Icon(Icons.error_outline_outlined, color: Colors.red[700], size: 35);

    final title = isAllowed
        ? "Day-out Allowed Today"
        : "Day-out Not Allowed Today";
    final subtitle = isAllowed
        ? "Allowed time: ${_format12h(context, r.minTime)} – ${_format12h(context, r.maxTime)}"
        : (r.note.isNotEmpty ? r.note : "Not allowed today.");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.h4.w500.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(subtitle, style: textTheme.h6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorRow({
    required BuildContext context,
    required Widget leading,
    required String title,
    required String subtitle,
    required bool showRetry,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.h4.w500.copyWith(color: colorScheme.error),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.h3.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (showRetry)
            TextButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }

  // 12-hour AM/PM formatting
  String _format12h(BuildContext context, TimeOfDay t) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(t, alwaysUse24HourFormat: false);
  }
}
