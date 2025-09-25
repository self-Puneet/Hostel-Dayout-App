import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';

class ParentLayout extends StatefulWidget {
  final Widget child;
  const ParentLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<ParentLayout> createState() => _ParentLayoutState();
}

class _ParentLayoutState extends State<ParentLayout> {
  // int _selectedIndex = 0;

  int _indexForLocation(String location) {
    if (location.startsWith(AppRoutes.parentHistory)) return 1;
    if (location.startsWith(AppRoutes.profile)) return 2;
    return 0; // default to Home
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.push(AppRoutes.parentHome);
        break;
      case 1:
        context.push(AppRoutes.parentHistory);
        break;
      case 2:
        context.push(AppRoutes.parentHome);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int currentIndex = _indexForLocation(location);
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int i) => _onItemTapped(context, i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
