import 'package:flutter/material.dart';

class EmptyQueueCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double iconSize;
  final double minHeight;
  final double bottomPadding;

  const EmptyQueueCard({
    super.key,
    this.title = 'Your queue is empty.',
    this.subtitle = 'All clear! No requests for now.',
    this.iconSize = 84,
    this.minHeight = 320,
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = isDark ? Colors.white : Colors.black87;
    final sub = fg.withAlpha((0.7 * 225).toInt());

    return Container(
      padding: EdgeInsets.fromLTRB(24, 28, 24, 28 + bottomPadding),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt, size: iconSize, color: Colors.blue),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: fg,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: sub,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
