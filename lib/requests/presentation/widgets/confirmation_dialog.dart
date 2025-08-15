import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> actions;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.actions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String description,
    required List<Widget> actions,
  }) {
    return showShadDialog<T>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        description: description,
        actions: actions,
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
      actions: actions,
    );
  }
}
