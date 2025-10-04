import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const ClickableText({
    Key? key,
    required this.text,
    required this.onTap,
    this.color = Colors.black, // default clickable color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Text(text, style: textTheme.h5),
    );
  }
}
