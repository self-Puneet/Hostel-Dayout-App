import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network_info.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NetworkProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigation(),
    );
  }
}

/// Main Bottom Navigation Wrapper
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ContentPage(title: "Home Page"),
    ContentPage(title: "Profile Page"),
    ContentPage(title: "Settings Page"),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Show selected page
        _pages[_currentIndex],

        // Fixed bottom nav above everything
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
            ],
          ),
        ),
      ],
    );
  }
}

/// Page with Scaffold and Network Consumer
class ContentPage extends StatelessWidget {
  final String title;
  const ContentPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      
      builder: (context, network, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (network.isConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Connected to Internet")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No Internet Connection")),
            );
          }
        });
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(
            child: Text(
              "sdddf"))
        );
      },
    );
  }
}
