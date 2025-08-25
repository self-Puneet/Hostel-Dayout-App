// class KeyboardListener with WidgetsBindingObserver {
//   final Function(bool isOpen) onChanged;

//   KeyboardListener(this.onChanged) {
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void didChangeMetrics() {
//     final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
//     onChanged(bottomInset > 0);
//   }

//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//   }
// }
