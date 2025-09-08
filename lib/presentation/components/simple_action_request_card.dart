// simple_action_request_card.dart

import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/presentation/widgets/status_tag.dart';

class SimpleActionRequestCard extends StatelessWidget {
  final String name;
  final RequestStatus status;
  final RequestType leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final VoidCallback? onCancel; // null => disabled (handled by parent)
  final VoidCallback? onReferToParent; // null => disabled (handled by parent)

  // Selection UI + gestures
  final bool selected;
  final VoidCallback? onLongPress; // first selection when none selected
  final VoidCallback? onTap; // toggle when selection mode is active

  const SimpleActionRequestCard({
    super.key,
    required this.name,
    required this.status,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    this.onCancel,
    this.onReferToParent,
    this.selected = false,
    this.onLongPress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const selectedColor = Colors.blue; // force blue selected visuals

    // Button styles (WidgetStateProperty works on recent Flutter)
    final ButtonStyle dangerStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return theme.colorScheme.surfaceContainerHighest;
        }
        return Colors.red;
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
        return Colors.green;
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
              : const BorderSide(color: Colors.transparent, width: 0),
        ),
        clipBehavior: Clip.antiAlias, // ensures rounded clipping
        child: Ink(
          decoration: ShapeDecoration(
            color: selected
                ? selectedColor.withOpacity(0.08) // subtle blue tint
                : theme.colorScheme.surface,
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
            // ensure ink uses the same rounded shape for ripple
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            splashColor: selectedColor.withOpacity(0.12),
            highlightColor: selectedColor.withOpacity(0.06),
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
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
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
                            color: status.statusColor,
                          ),
                        ],
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
                                    const Icon(Icons.south_west, size: 16),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        InputConverter.dateFormater(toDate),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Icon-only actions
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: onCancel, // null => disabled
                                style: dangerStyle,
                                child: const Icon(Icons.close, size: 20),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: onReferToParent, // null => disabled
                                style: successStyle,
                                child: const Icon(Icons.check, size: 20),
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
}
