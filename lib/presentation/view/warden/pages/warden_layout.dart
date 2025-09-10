import 'package:flutter/material.dart';
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

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final padding = EdgeInsets.symmetric(
    //   horizontal: 31 * mediaQuery.size.width / 402,
    // );

    return GestureDetector(
      behavior:
          HitTestBehavior.translucent, // let taps pass through to children
      onTap: () => FocusManager.instance.primaryFocus
          ?.unfocus(), // unfocus on outside tap
      child: Consumer<WardenProfileState>(
        builder: (context, state, _) {
          final actor = state.loginSession.role;
          final List<Widget> _pages = [
            WardenHomePage(actor: actor),
            const Center(child: Text('Page Under Construction')),
            const Center(child: Text('Page Under Construction')),
          ];

          final padding2 = EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 24 / 392,
          );

          // Choose current page
          final Widget currentPage = _selectedIndex == 0
              ? widget.child
              : _pages[_selectedIndex];

          return Scaffold(
            backgroundColor: const Color(0xFFE9E9E9),
            body: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: EdgeInsets.only(
                  top: mediaQuery.size.height * 50 / 874,
                ),
                child: Padding(
                  padding: padding2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WelcomeHeader(
                        actor: actor,
                        name: state.loginSession.username,
                        avatarUrl: state.loginSession.imageURL,
                        greeting: 'Welcome back,',
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: currentPage),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.black,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Active Requests',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History Requests',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
