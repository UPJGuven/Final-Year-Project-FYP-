import 'package:flutter/material.dart';

class GoalNode extends StatelessWidget {
  final String title;
  final bool isCircle;

  GoalNode({required this.title, this.isCircle = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Size of the node
      height: 100,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        color: Colors.blue,
        borderRadius: isCircle ? null : BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}