import 'package:flutter/material.dart';
import 'package:hostel_mgmt/view/widgets/liquid_glass_chip.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Wrap(
          spacing: 12,
          children: const [
            LiquidGlassChip(label: "Thu"),
            LiquidGlassChip(label: "Fri"),
            LiquidGlassChip(label: "Weekend"),
          ],
        ),
      ),
    );
  }
}
