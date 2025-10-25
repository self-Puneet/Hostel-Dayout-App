import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:provider/provider.dart';

class WardenActionSelectionGuard extends StatelessWidget {
  final Widget child;
  const WardenActionSelectionGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        final s = context.read<WardenActionState>();
        // Block while actioning
        if (s.isActioning) return;

        if (s.hasSelection) {
          s.clearSelection();
          s.layoutState.hideActionsOverlay();
          // Optional UX: ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Selection cleared')),
          // );
          return; // consume first back; do not pop
        }
        context.pop(); // allow pop when nothing is selected
      },
      child: child,
    );
  }
}
