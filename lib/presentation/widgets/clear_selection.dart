// A tiny helper you can reuse anywhere you want “tap to clear selection”.
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:provider/provider.dart';

class ClearSelectionOnTap extends StatelessWidget {
  final Widget child;
  const ClearSelectionOnTap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent, // still lets inner controls work
      onPointerDown: (_) {
        // optional: collapse keyboard when tapping the header area
        FocusScope.of(context).unfocus();

        final s = context.read<WardenActionState>();
        if (s.hasSelection && !s.isActioning) {
          s.clearSelection();                // unselect all
          s.layoutState.hideActionsOverlay(); // hide bulk bar if you show one
        }
      },
      child: child,
    );
  }
}
