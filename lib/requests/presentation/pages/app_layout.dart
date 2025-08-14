import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final String location;
  const AppLayout({Key? key, required this.child, required this.location})
    : super(key: key);

  static const _tabs = [
    _TabInfo(
      name: 'home',
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    _TabInfo(
      name: 'requests',
      label: 'Requests',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
    ),
    _TabInfo(
      name: 'alerts',
      label: 'Alerts',
      icon: Icons.notifications_none,
      activeIcon: Icons.notifications,
    ),
    _TabInfo(
      name: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
    ),
  ];

  static const _titles = ['Home', 'Requests', 'Alerts', 'Settings'];

  int _calculateSelectedIndex() {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith('/${_tabs[i].name}')) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4, // a bit more shadow for separation
        shadowColor: Colors.grey.withOpacity(0.3), // subtle gray shadow
        title: Text(
          _titles[selectedIndex],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        toolbarHeight: 60, // slightly taller for better presence
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(12), // gentle rounded bottom corners
        //   ),
        // ),
      ),

      body: child, // The current route’s page from ShellRoute child
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          final tab = _tabs[index];
          print(selectedIndex);
          if (tab.name != _tabs[selectedIndex].name) {
            GoRouter.of(context).go('/${tab.name}');
          }
        },
        items: _tabs
            .map(
              (tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                activeIcon: Icon(tab.activeIcon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TabInfo {
  final String name;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _TabInfo({
    required this.name,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
