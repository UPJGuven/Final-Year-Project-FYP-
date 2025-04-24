import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(0),
              child: Container(
                color: currentIndex == 0 ? Colors.orange[600] : Colors.white,
                child: Center(
                  child: Icon(
                    Icons.account_tree_rounded,
                    color: currentIndex == 0 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // first tab (Goals)


          Expanded(
            child: GestureDetector(
              onTap: () => onTap(1),
              child: Container(
                color: currentIndex == 1 ? Colors.orange[600] : Colors.white,
                child: Center(
                  child: Icon(
                    Icons.percent_rounded,
                    color: currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // second tab (progression)

          Expanded(
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                color: currentIndex == 2 ? Colors.orange[600] : Colors.white,
                child: Center(
                  child: Icon(
                    Icons.checklist,
                    color: currentIndex == 2 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // third tab (To-Do)
        ],
      ),
    );
  }
}
