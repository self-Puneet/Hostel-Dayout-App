import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/box_decoration_enum.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppBoxDecoration.alert.decoration,
              child: Icon(Icons.wifi_off, color: Colors.red.shade400, size: 48),
            ),
            const SizedBox(height: 24),
            // correct styling to the text
            const Text(
              "No internet connection",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please check your internet connection and try again",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
