import 'package:flutter/material.dart';
import 'package:hostel_mgmt/view/widgets/liquid_glass_morphism/glass_nav_bar.dart';
import 'package:hostel_mgmt/view/widgets/liquid_glass_morphism/liquid_glass_chip.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          // Center(child: Container(width: 200, height: 100, color: Colors.red)),
          Center(
            child: Wrap(
              spacing: 12,
              children: const [
                LiquidGlassChip(label: "Thu"),
                LiquidGlassChip(label: "Fri"),
                LiquidGlassChip(label: "Weekend"),
                // SizedBox(height: 10),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 40,
                    vertical: 40,
                  ),
                  child: LiquidGlassNavBar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
