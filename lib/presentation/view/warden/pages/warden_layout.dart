import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_home.dart';

class WardenLayout extends StatefulWidget {
  const WardenLayout({Key? key}) : super(key: key);

  @override
  State<WardenLayout> createState() => _WardenLayoutState();
}

class _WardenLayoutState extends State<WardenLayout> {
  int _selectedIndex = 0;
  late final TimelineActor actor;

  void initState() {
    super.initState();
    final session = Get.find<LoginSession>();
    actor = session.role;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder widgets for each tab
    final List<Widget> _pages = [
      WardenHomePage(actor: actor),
      const Center(child: Text('Active Requests Page')),
      const Center(child: Text('History Requests Page')),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: SafeArea(top: false, bottom: true, child: Padding(
            padding: EdgeInsetsGeometry.only(
              top: mediaQuery.size.height * 50 / 874,
            ),
            child: Container(
              child:
                  // ? SingleChildScrollView(child: const ShimmerCard())
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            LoginController.logout(context);
                            // Handle button press
                          },
                          child: Text('Elevated Button'),
                        ),
                        Container(
                          margin: padding,
                          child: WelcomeHeader(
                            name: state.profile?.name ?? '',
                            avatarUrl: state.profile?.profilePic,
                            greeting: 'Welcome back,',
                          ),
                        ),

      
      _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Active Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.extension), label: 'Custom'),
        ],
      ),
    );
  }
}
