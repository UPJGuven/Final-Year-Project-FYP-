import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Height of the bottom navigation bar
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Left Tab (Goals)
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(0),
              child: Container(
                color: currentIndex == 0 ? Colors.blue : Colors.white,
                child: Center(
                  child: Icon(
                    Icons.account_tree_rounded,
                    color: currentIndex == 0 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Right Tab (To-Do)
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(1),
              child: Container(
                color: currentIndex == 1 ? Colors.blue : Colors.white,
                child: Center(
                  child: Icon(
                    Icons.checklist,
                    color: currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}