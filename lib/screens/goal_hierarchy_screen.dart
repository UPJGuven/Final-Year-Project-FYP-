import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';
import 'package:provider/provider.dart';
import '../goal_provider.dart';
import 'create_goal_screen.dart';
import 'settings_screen.dart';

class GoalHierarchyScreen extends StatefulWidget {
  @override
  _GoalHierarchyScreenState createState() => _GoalHierarchyScreenState();
}

class _GoalHierarchyScreenState extends State<GoalHierarchyScreen> {
  // List<NodeInput> goalNodes = [
  //   NodeInput(id: 'Goal 1', next: [
  //     EdgeInput(outcome: 'Goal 2'),
  //     EdgeInput(outcome: 'Goal 3'),
  //     EdgeInput(outcome: 'Goal 4')
  //   ]),
  //   NodeInput(id: 'Goal 2', next: []),
  //   NodeInput(id: 'Goal 3', next: [EdgeInput(outcome: 'Goal 5')]),
  //   NodeInput(
  //       id: 'Goal 4',
  //       next: [EdgeInput(outcome: 'Goal 5'), EdgeInput(outcome: 'Goal 6')]),
  //   NodeInput(id: 'Goal 5', next: []),
  //   NodeInput(
  //       id: 'Goal 6',
  //       next: [EdgeInput(outcome: 'Goal 7'), EdgeInput(outcome: 'Goal 8')]),
  //   NodeInput(id: 'Goal 7', next: []),
  //   NodeInput(id: 'Goal 8', next: []),
  // ];

  // void addGoal(String goalId,String goalName, List<String> subGoals) {
  //   setState(() {
  //     goalNodes.add(NodeInput(
  //       id: goalName,
  //       next: subGoals.map((dep) => EdgeInput(outcome: dep)).toList(),
  //     ));
  //     debugPrint(goalNodes.map((node) => 'Node ID: ${node.id}, Next: ${node.next.map((edge) => edge.outcome).join(", ")}').toList().toString());
  //   });
  // }

  // void addGoal(BuildContext context, String goalId, String goalName, List<String> subGoals) {
  //   final goalProvider = Provider.of<GoalProvider>(context, listen: false);
  //
  //   goalProvider.addGoalNode(goalName, subGoals);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.account_tree_rounded,
          color: Colors.blue,
        ),
        title: Text('Goal Hierarchy'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to the Settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        constrained: false,
        minScale: 0.5,
        maxScale: 2.0,
        boundaryMargin: EdgeInsets.all(800),
        child: Consumer<GoalProvider>(
          // 👈 Updates when goals change
          builder: (context, goalProvider, child) {
            final goalNodes = goalProvider.goalNodes;

            return goalNodes.isEmpty
                ? Center(child: Text("No goals found")) // Handles empty state
                : DirectGraph(
                    list: goalNodes,
                    centered: true,
                    defaultCellSize: Size(100.0, 80.0),
                    cellPadding: EdgeInsets.all(30.0),
                    orientation: MatrixOrientation.Vertical,
                    nodeBuilder: (context, node) {
                      final goalIdToName =
                          Provider.of<GoalProvider>(context, listen: false)
                              .goalIdToName;
                      final name = goalIdToName[node.id] ?? '[Missing Name]';
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    styleBuilder: (edge) {
                      var paint = Paint()
                        ..color = Colors.grey
                        ..style = PaintingStyle.stroke
                        ..strokeCap = StrokeCap.round
                        ..strokeJoin = StrokeJoin.round
                        ..strokeWidth = 3;

                      return EdgeStyle(
                        lineStyle: LineStyle.solid,
                        linePaint: paint,
                        borderRadius: 80,
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGoalScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
