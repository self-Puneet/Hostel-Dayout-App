import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String description,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    return showShadDialog<T>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        description: description,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: Text(title),
      description: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(description),
      ),
      actions: [
        ShadButton.outline(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ShadButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
