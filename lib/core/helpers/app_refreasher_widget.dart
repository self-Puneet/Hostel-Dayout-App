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
      color: Colors.deepPurple,
      backgroundColor: Colors.white,
      strokeWidth: 3,
      displacement: 60,
      onRefresh: onRefresh,
      child: child,
    );
  }
}