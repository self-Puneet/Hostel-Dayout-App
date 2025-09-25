/// RestrictionCard widget: clean static card with soft shadow + applicability & error states.
/// - No glow/animation/border color changes.
/// - Allowed: green check + "Day-out Allowed Today" + "Allowed time: ...".
/// - Not allowed: red alert icon + "Day-out Not Allowed Today" + note as reason.
/// - Error-loading: explicit red error row when `restriction.errroLoading == true`.
/// - Times use 12-hour AM/PM via MaterialLocalizations.
/// - `isApplicable` dims the whole card when false (e.g., in Leave mode).

import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/restriction_window.dart';

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
        color: Colors.white,
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
      child: AbsorbPointer(
        absorbing: !isApplicable,
        child: card,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 72,
        child: Center(
          child: Text(
            "Loading restriction…",
            style: TextStyle(color: Color(0xFF757575), fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    // If no data at all
    if (restriction == null) {
      return _errorRow(
        leading: const Icon(Icons.error_outline, color: Colors.redAccent),
        title: "Unable to load restriction",
        subtitle: "Check connection or try again.",
        showRetry: onRetry != null,
      );
    }

    // If data object signals error explicitly
    if (restriction!.errroLoading == true) {
      return _errorRow(
        leading: const Icon(Icons.error_outline, color: Colors.redAccent),
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
        ? const Icon(Icons.check_circle, color: Colors.green, size: 22)
        : const Icon(Icons.error_outline, color: Colors.red, size: 22);

    final title = isAllowed ? "Day-out Allowed Today" : "Day-out Not Allowed Today";
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
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF616161), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorRow({
    required Widget leading,
    required String title,
    required String subtitle,
    required bool showRetry,
  }) {
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
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF616161), fontSize: 13)),
              ],
            ),
          ),
          if (showRetry) TextButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }

  // 12-hour AM/PM formatting
  String _format12h(BuildContext context, TimeOfDay t) {
    return MaterialLocalizations.of(context)
        .formatTimeOfDay(t, alwaysUse24HourFormat: false);
  }
}
