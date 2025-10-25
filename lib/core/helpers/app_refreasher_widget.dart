import 'package:flutter/material.dart';

class AppRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      color: Colors.black,
      backgroundColor: Colors.white,
      strokeWidth: 3,
      displacement: 60,
      onRefresh: () async {
        final real = onRefresh();
        // Hide as soon as either the real refresh completes or 2s elapse.
        await Future.any<void>([
          // Prevent unhandled errors if the delay wins.
          real.catchError((_) {}),
          Future.delayed(const Duration(seconds: 1)),
        ]);
      },
      child: child,
    );
  }
}
