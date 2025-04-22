import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Training'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Programs'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Recap'),
        BottomNavigationBarItem(icon: Icon(Icons.link), label: 'Connection'),
        BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Challenges'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
    );
  }
}