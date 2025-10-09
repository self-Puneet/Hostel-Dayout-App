import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/presentation/widgets/status_tag.dart';

class SimpleActionRequestCard extends StatelessWidget {
  final String reason;
  final String name;
  final RequestStatus status;
  final RequestType leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final VoidCallback? onRejection; // null => disabled (handled by parent)
  final VoidCallback? onAcceptence; // null => disabled (handled by parent)
  final String? profileImageUrl;

  // Selection UI + gestures
  final bool selected;
  final VoidCallback? onLongPress; // first selection when none selected
  final VoidCallback? onTap; // toggle when selection mode is active

  // Customization fields (added earlier)
  final bool isRejection; // show/hide reject button
  final bool isAcceptence; // show/hide accept button
  final Color rejectionColor; // reject button color
  final Color accrptenceCOlor; // accept button color (kept spelling)
  final Color? borderColor; // base color for card, rendered pale

  // New icon customization fields
  final IconData acceptenceIcon; // default: Icons.check
  final IconData declineIcon; // default: Icons.close

  final bool isLate;

  const SimpleActionRequestCard({
    this.isLate = false,
    super.key,
    required this.reason,
    required this.name,
    required this.status,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    this.onRejection,
    this.onAcceptence,
    this.selected = false,
    this.onLongPress,
    this.onTap,
    required this.profileImageUrl,

    // Defaults
    this.isRejection = true,
    this.isAcceptence = true,
    this.rejectionColor = Colors.red,
    this.accrptenceCOlor = Colors.green,
    this.borderColor,

    // New defaults as requested
    this.acceptenceIcon = Icons.check,
    this.declineIcon = Icons.close,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const selectedColor = Colors.blue; // force blue selected visuals

    // Button styles (WidgetStateProperty on recent Flutter)
    final ButtonStyle dangerStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.surfaceContainerHighest;
        }
        return rejectionColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.onSurface.withAlpha(85);
        }
        return Colors.white;
      }),
      minimumSize: const WidgetStatePropertyAll(Size(40, 40)),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    final ButtonStyle successStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.surfaceContainerHighest;
        }
        return accrptenceCOlor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.onSurface.withAlpha(85);
        }
        return Colors.white;
      }),
      minimumSize: const WidgetStatePropertyAll(Size(40, 40)),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    final BorderRadius radius = BorderRadius.circular(16);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // vertical margin
      // Use Material + Ink + InkWell so ink splash is clipped to rounded shape
      child: Material(
        type: MaterialType.transparency,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: selected
              ? const BorderSide(color: selectedColor, width: 2)
              : BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ), // Use borderColor here
        ),
        clipBehavior: Clip.antiAlias, // ensures rounded clipping
        child: Ink(
          decoration: ShapeDecoration(
            // Keep existing selected blue tint; otherwise use pale background.
            color: selected
                ? selectedColor.withAlpha((0.08 * 255).toInt())
                : (borderColor == null)
                ? Colors.white
                : borderColor!.withAlpha((0.08 * 255).toInt()),
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(
                color: selected ? selectedColor : Colors.transparent,
                width: selected ? 2 : 0,
              ),
            ),
          ),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            splashColor: selectedColor.withAlpha((0.12 * 255).toInt()),
            highlightColor: selectedColor.withAlpha((0.06 * 255).toInt()),
            child: Stack(
              children: [
                // Main content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          _buildAvatar(),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  leaveType.displayName.toUpperCase(),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          StatusTag(
                            status: status.displayName,
                            color: status.minimalStatusColor,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Text(
                        "\"$reason\"",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Bottom: Row< Column(in/out), Row(icon-only buttons) >
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // In/Out dates column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.north_east, size: 16),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        InputConverter.dateFormater(fromDate),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.south_west,
                                      size: 16,
                                      color: isLate ? Colors.red : Colors.black,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        InputConverter.dateFormater(toDate),
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.h5.w500.copyWith(
                                          color: isLate
                                              ? Colors.red
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Icon-only actions (conditional)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isRejection)
                                ElevatedButton(
                                  onPressed: onRejection, // null => disabled
                                  style: dangerStyle,
                                  child: Icon(declineIcon, size: 20),
                                ),
                              if (isRejection && isAcceptence)
                                const SizedBox(width: 8),
                              if (isAcceptence)
                                ElevatedButton(
                                  onPressed: onAcceptence, // null => disabled
                                  style: successStyle,
                                  child: Icon(acceptenceIcon, size: 20),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Selection badge (non-intrusive)
                if (selected)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.check_circle,
                      size: 20,
                      color: selectedColor, // blue badge
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final hasImage = (profileImageUrl != null && profileImageUrl!.isNotEmpty);
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey,
      backgroundImage: hasImage ? NetworkImage(profileImageUrl!) : null,
      child: hasImage ? null : const Icon(Icons.person, color: Colors.white),
    );
  }
}
