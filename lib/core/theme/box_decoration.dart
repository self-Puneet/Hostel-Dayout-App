import 'package:flutter/material.dart';

class AppDecorations {
  static final BoxDecoration base = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.transparent, width: 0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(12),
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
