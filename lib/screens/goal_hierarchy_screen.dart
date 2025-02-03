import 'package:flutter/material.dart';
import '../goal_model.dart';
import '../widgets/goal_tree.dart';

class GoalHierarchyScreen extends StatelessWidget {
  final bool useCircles;
  GoalHierarchyScreen({this.useCircles = false});

  final rootGoal = Goal(
    id: '1',
    title: 'Goal 1',
    subGoals: [
      Goal(
        id: '2',
        title: 'Goal 2',
        subGoals: [
          Goal(id: '4', title: 'Goal 4'),
          Goal(id: '5', title: 'Goal 5'),
        ],
      ),
      Goal(
        id: '3',
        title: 'Goal 3',
        subGoals: [
          Goal(id: '6', title: 'Goal 6'),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Hierarchy'),
      ),
      body: GoalTree(useCircles: useCircles, rootGoal: rootGoal,),
    );
  }
}
