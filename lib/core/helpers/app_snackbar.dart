import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/snackbar_type.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required AppSnackBarType type,
    IconData icon = Icons.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: type.bgColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        dismissDirection: DismissDirection.horizontal,
        animation: CurvedAnimation(
          parent: AnimationController(
            vsync: Navigator.of(context),
            duration: const Duration(seconds: 1),
          ),
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  // dismiss snackbar function
  static void dismiss(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
  }
}
