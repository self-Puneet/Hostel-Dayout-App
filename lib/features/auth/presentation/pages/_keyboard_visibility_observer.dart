import 'package:flutter/widgets.dart';

class KeyboardVisibilityObserver extends WidgetsBindingObserver {
  final VoidCallback onKeyboardClosed;
  KeyboardVisibilityObserver({required this.onKeyboardClosed});

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset == 0.0) {
      onKeyboardClosed();
    }
  }
}
