import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/outing_rule_model.dart';
import 'request_form_page.dart';

class StudentLayout extends StatelessWidget {
  const StudentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Outing Request"), elevation: 10),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              RequestFormPage(
                outingRule: OutingRule.allowed(
                  fromTime: TimeOfDay.now(),
                  toTime: TimeOfDay.now().replacing(
                    hour: TimeOfDay.now().hour + 1,
                  ),
                ),
              ),
            ],
          ),

          // Overlay the shape near the bottom center
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              bottom: true,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: OverlappingThreeButtons(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverlappingThreeButtons extends StatelessWidget {
  const OverlappingThreeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print("object");
                },
                child: Text("Home"),
              ),
            ),
            const SizedBox(width: 60), // space for the middle button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print("object");
                },
                child: Text("Profile"),
              ),
            ),
          ],
        ),

        ElevatedButton(
          onPressed: () => print('Tapped'),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(25), // controls size
            elevation: 6,
            shadowColor: Colors.black54,
            backgroundColor: Colors.blue, // button color
          ),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ],
    );
  }
}
