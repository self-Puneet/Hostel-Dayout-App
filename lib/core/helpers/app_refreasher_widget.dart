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

      // notificationPredicate: (notification) =>
      //     notification.metrics.axis == Axis.vertical && notification.depth > 0,
      strokeWidth: 3,
      displacement: 60,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
