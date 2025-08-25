import 'package:flutter/material.dart';

class DisabledElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // 👈 Still allow a callback if needed

  const DisabledElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // 👇 Use custom disabled style (different from default theme)
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400, // Disabled background
        foregroundColor: Colors.grey.shade200, // Disabled text
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onPressed: onPressed, // 👈 If you want it fully unclickable, set null
      child: Text(text),
    );
  }
}
