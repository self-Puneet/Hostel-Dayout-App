import 'package:flutter/material.dart';

class DisabledElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // keep for API parity, pass null to disable

  const DisabledElevatedButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.labelLarge?.copyWith(fontSize: 14);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // match your enabled theme’s geometry
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        textStyle: textStyle,
        // disabled-specific visuals
        backgroundColor: Colors.grey.shade400,
        foregroundColor: Colors.grey.shade200,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed, // pass null to be truly untappable
      child: Text(text),
    );
  }
}
