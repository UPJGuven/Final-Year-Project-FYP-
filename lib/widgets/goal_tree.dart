import 'package:flutter/material.dart';
import '../goal_model.dart';
import 'goal_node.dart';
import 'goal_connector_painter.dart';

class GoalTree extends StatelessWidget {
  final Goal rootGoal;
  final bool useCircles;

  GoalTree({required this.rootGoal, this.useCircles = false});

  @override
  Widget build(BuildContext context) {
    // Calculate positions of goals and total tree size
    final treeLayout = layoutGoals(rootGoal, Offset(200, 50), 150, 150);

    return InteractiveViewer(
      boundaryMargin: EdgeInsets.all(40),
      minScale: 0.1,
      maxScale: 2.0,
      constrained: false, // Allow panning beyond the initial boundaries
      child: Container(
        width: treeLayout.totalWidth + 400, // Add extra padding
        height: treeLayout.totalHeight + 400, // Add extra padding
        child: Stack(
          children: [
            // Draw connecting lines
            CustomPaint(
              size: Size(treeLayout.totalWidth, treeLayout.totalHeight),
              painter: GoalConnectorPainter(
                positionedGoals: treeLayout.positionedGoals,
              ),
            ),
            // Render goal nodes
            for (final positionedGoal in treeLayout.positionedGoals)
              Positioned(
                left: positionedGoal.position.dx,
                top: positionedGoal.position.dy,
                child: GoalNode(title: positionedGoal.goal.title, isCircle: useCircles),
              ),
          ],
        ),
      ),
    );
  }
}