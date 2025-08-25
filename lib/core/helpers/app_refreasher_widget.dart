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


// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class AppRefreshWrapper extends StatefulWidget {
//   final Widget child;
//   final Future<void> Function() onRefresh;

//   const AppRefreshWrapper({
//     super.key,
//     required this.child,
//     required this.onRefresh,
//   });
//   @override
//   State<AppRefreshWrapper> createState() => _AppRefreshWrapperState();
// }

// class _AppRefreshWrapperState extends State<AppRefreshWrapper> {
//   final RefreshController _controller = RefreshController();

//   Future<void> _handleRefresh() async {
//     await widget.onRefresh();
//     _controller.refreshCompleted();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SmartRefresher(
//       controller: _controller,
//       enablePullDown: true,
//       onRefresh: _handleRefresh,
//       header: const WaterDropHeader(), // can be customized
//       child: widget.child,
//     );
//   }
// }
