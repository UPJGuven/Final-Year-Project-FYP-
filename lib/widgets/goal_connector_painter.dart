import 'package:flutter/material.dart';

import '../goal_model.dart';

class GoalConnectorPainter extends CustomPainter {
  final List<PositionedGoal> positionedGoals;

  GoalConnectorPainter({required this.positionedGoals});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Draw lines between goals
    for (final positionedGoal in positionedGoals) {
      final parentPosition = positionedGoal.position;
      final parentSize = positionedGoal.size;

      // Calculate the center-bottom position of the parent goal
      final parentCenterBottom = Offset(
        parentPosition.dx + parentSize.width / 2,
        parentPosition.dy + parentSize.height,
      );

      // Draw lines to each sub-goal
      for (final subGoal in positionedGoal.goal.subGoals) {
        final subGoalPositioned = positionedGoals.firstWhere((pg) => pg.goal.id == subGoal.id);
        final subGoalPosition = subGoalPositioned.position;
        final subGoalSize = subGoalPositioned.size;

        // Calculate the center-top position of the sub-goal
        final subGoalCenterTop = Offset(
          subGoalPosition.dx + subGoalSize.width / 2,
          subGoalPosition.dy,
        );

        // Draw a line from the parent's center-bottom to the sub-goal's center-top
        canvas.drawLine(parentCenterBottom, subGoalCenterTop, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}