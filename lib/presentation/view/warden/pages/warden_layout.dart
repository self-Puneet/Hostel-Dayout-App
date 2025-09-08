import 'package:flutter/material.dart';
import 'package:hostel_mgmt/login/login_controller.dart';
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_home.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_profile_state.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';

class WardenLayout extends StatefulWidget {
  final Widget child;
  const WardenLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<WardenLayout> createState() => _WardenLayoutState();
}

class _WardenLayoutState extends State<WardenLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WardenProfileState>(
      builder: (context, state, _) {
        final actor = state.loginSession.role;
        final List<Widget> _pages = [
          WardenHomePage(actor: actor),
          const Center(child: Text('Active Requests Page')),
          const Center(child: Text('History Requests Page')),
        ];
        final mediaQuery = MediaQuery.of(context);
        final padding = EdgeInsets.symmetric(
          horizontal: mediaQuery.size.width * 24 / 392,
        );

        // Use widget.child for the current tab, otherwise use _pages
        Widget currentPage;
        if (_selectedIndex == 0) {
          currentPage = widget.child;
        } else {
          currentPage = _pages[_selectedIndex];
        }

        return Scaffold(
          backgroundColor: const Color(0xFFE9E9E9),
          body: SafeArea(
            top: false,
            bottom: true,
            child: Padding(
              padding: EdgeInsets.only(top: mediaQuery.size.height * 50 / 874),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // a elevated button for logout
                  // ElevatedButton(
                  //   onPressed: () {
                  //     LoginController.logout(context);
                  //   },
                  //   child: const Text('Logout'),
                  // ),
                  Container(
                    margin: padding,
                    child: WelcomeHeader(
                      actor: actor,
                      name: state.loginSession.username,
                      avatarUrl: state.loginSession.imageURL,
                      greeting: 'Welcome back,',
                    ),
                  ),
                  Expanded(child: currentPage),
                ],
              ),
            ),
          ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.extension),
                label: 'Custom',
              ),
            ],
          ),
        );
      },
    );
  }
}
