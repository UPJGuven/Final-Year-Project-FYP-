import 'package:flutter/material.dart';
import '../widgets/goal_tree.dart';

class GoalHierarchyScreen extends StatelessWidget {
  final bool useCircles;
  GoalHierarchyScreen({this.useCircles = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Hierarchy'),
      ),
      body: GoalTree(useCircles: useCircles),
    );
  }
}
