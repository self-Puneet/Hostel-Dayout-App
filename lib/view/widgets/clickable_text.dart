import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 16,
          color: color,
        ),
      ),
    );
  }
}
