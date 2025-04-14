import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';
import 'package:provider/provider.dart';
import '../goal_provider.dart';
import 'create_goal_screen.dart';
import 'edit_goal_screen.dart';
import 'help_guidance_screen.dart';
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

  void _showGoalOptions(BuildContext context, String goalId) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final goalProvider = Provider.of<GoalProvider>(context, listen: false);
    final goalHasParent = goalProvider.goals.any(
          (goal) => goal['id'] == goalId && goal['parentGoalId'] != null && goal['parentGoalId'] != '',
    );
    final menuItems = <PopupMenuEntry>[
      PopupMenuItem(value: 'sub-goal', child: Text('Create New Sub-goal')),
      if (!goalHasParent) // only show this if goal has no parent
        PopupMenuItem(value: 'parentGoal', child: Text('Create New Parent Goal')),
      PopupMenuItem(value: 'edit', child: Text('Edit Goal')),
      PopupMenuItem(value: 'delete', child: Text('Delete Goal')),
    ];

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          100, 300, 0, 0), // You can adjust this or calculate dynamically
      items: menuItems
    );

    switch (result) {
      case 'sub-goal':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateGoalScreen(parentGoalId: goalId),
            ));
        break;
      case 'parentGoal':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreateGoalScreen(
              parentGoalId: goalId,
              isParentGoal: true,
            ),
          ),
        );
        break;
      case 'edit':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditGoalScreen(goalId: goalId),
            ));
        break;
      case 'delete':
        _showDeleteConfirmation(context, goalId);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, String goalId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Goal'),
        content: Text('Are you sure you want to delete this goal?\n \n'
            'NOTE: This action will separate the sub-goals into a new tree.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _deleteGoal(goalId);
                Navigator.of(context).pop(); // Close the dialog AFTER delete
              } catch (e) {
                print("Failed to delete goal: $e");
                Navigator.of(context).pop(); // Still close the dialog, even on error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete goal')),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteGoal(String goalId) async {
    final goalsRef = FirebaseFirestore.instance.collection('Goal');

    final subgoals = await goalsRef.where('parentGoalId', isEqualTo: goalId).get();
    for (var doc in subgoals.docs) {
      await doc.reference.update({'parentGoalId': ''});
    }

    await goalsRef.doc(goalId).delete();
    print('Deleted goal $goalId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Higher-Arc",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8), // spacing between text and image
            Image.asset(
              'assets/images/FYP Logo No Text v1.0.png',
              height: 30,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HelpGuidanceScreen(showOnComplete: false)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
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
                    defaultCellSize: Size(140.0, 100.0),
                    cellPadding: EdgeInsets.all(30.0),
                    orientation: MatrixOrientation.Vertical,
                    nodeBuilder: (context, node) {
                      final goalIdToName =
                          Provider.of<GoalProvider>(context, listen: false)
                              .goalIdToName;
                      final name = goalIdToName[node.id] ?? '[Missing Name]';
                      return GestureDetector(
                        onLongPress: () => _showGoalOptions(context, node.id),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            name,

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
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
        backgroundColor: Colors.orange[600],
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
