import 'package:flutter/material.dart';
import 'goal_node.dart';

class GoalTree extends StatelessWidget {
  final bool useCircles;

  GoalTree({this.useCircles = false});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: EdgeInsets.all(20),
      minScale: 0.1,
      maxScale: 2.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level 1: Root Goal
            GoalNode(title: 'Goal 1', isCircle: useCircles),
            SizedBox(height: 20),
            // Level 2: Sub-Goals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GoalNode(title: 'Goal 2', isCircle: useCircles),
                GoalNode(title: 'Goal 3', isCircle: useCircles),
              ],
            ),
            SizedBox(height: 20),
            // Level 3: Sub-Sub-Goals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GoalNode(title: 'Goal 4', isCircle: useCircles),
                GoalNode(title: 'Goal 5', isCircle: useCircles),
                GoalNode(title: 'Goal 6', isCircle: useCircles),
              ],
            ),
          ],
        ),
      ),
    );
  }
}