import 'dart:ui';
import 'dart:math';

class Goal {
  final String id;
  final String title;
  final List<Goal> subGoals;

  Goal({
    required this.id,
    required this.title,
    this.subGoals = const [],
  });
}
class PositionedGoal {
  final Goal goal;
  final Offset position;
  final Size size;

  PositionedGoal({
    required this.goal,
    required this.position,
    required this.size,
  });
}
class TreeLayout {
  final List<PositionedGoal> positionedGoals;
  final double totalWidth;
  final double totalHeight;

  TreeLayout({
    required this.positionedGoals,
    required this.totalWidth,
    required this.totalHeight,
  });
}

TreeLayout layoutGoals(Goal root, Offset startPosition, double levelHeight, double siblingSpacing) {
  final List<PositionedGoal> positionedGoals = [];
  final double nodeWidth = 100; // Width of each goal node
  final double nodeHeight = 100; // Height of each goal node

  // Position the root goal
  positionedGoals.add(PositionedGoal(
    goal: root,
    position: startPosition,
    size: Size(nodeWidth, nodeHeight),
  ));

  // Calculate the total width required for sub-goals
  double totalSubGoalsWidth = 0;
  for (final subGoal in root.subGoals) {
    final subGoalLayout = layoutGoals(subGoal, Offset(0, 0), levelHeight, siblingSpacing);
    totalSubGoalsWidth += subGoalLayout.totalWidth;
  }

  // Add spacing between sub-goals
  if (root.subGoals.isNotEmpty) {
    totalSubGoalsWidth += (root.subGoals.length - 1) * siblingSpacing;
  }

  // Start positioning sub-goals from the center
  double currentX = startPosition.dx - totalSubGoalsWidth / 2 + nodeWidth / 2;

  double maxHeight = startPosition.dy + nodeHeight;
  for (final subGoal in root.subGoals) {
    final subGoalPosition = Offset(currentX, startPosition.dy + levelHeight);
    final subGoalLayout = layoutGoals(subGoal, subGoalPosition, levelHeight, siblingSpacing);
    positionedGoals.addAll(subGoalLayout.positionedGoals);
    currentX += subGoalLayout.totalWidth + siblingSpacing;
    maxHeight = max(maxHeight, subGoalPosition.dy + subGoalLayout.totalHeight);
  }

  return TreeLayout(
    positionedGoals: positionedGoals,
    totalWidth: totalSubGoalsWidth,
    totalHeight: maxHeight - startPosition.dy + nodeHeight,
  );
}