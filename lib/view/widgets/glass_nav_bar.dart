import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const GlassNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 300,
      height: 70,
      borderRadius: 40,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon(Icons.home, 0),
          _buildMiddleButton(),
          _buildIcon(Icons.person, 2),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIndex == index ? Colors.black : Colors.black54,
      ),
      onPressed: () => onTap(index),
    );
  }

  Widget _buildMiddleButton() {
    return GestureDetector(
      onTap: () => onTap(1),
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 6),
              Text("NEW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
