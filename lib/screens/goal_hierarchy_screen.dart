import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';
import 'package:provider/provider.dart';
import '../goal_provider.dart';
import 'create_goal_screen.dart';
import 'edit_goal_screen.dart';
import 'help_guidance_screen.dart';
import 'settings_screen.dart';
import '../widgets/goal_detail_popup.dart';
import '../widgets/background_shape_painter.dart';
import '../widgets/goal_node_widget.dart';

class GoalHierarchyScreen extends StatefulWidget {
  @override
  _GoalHierarchyScreenState createState() => _GoalHierarchyScreenState();
}

class _GoalHierarchyScreenState extends State<GoalHierarchyScreen> {
  final TransformationController _transformController =
      TransformationController();

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
                Navigator.of(context)
                    .pop(); // Still close the dialog, even on error
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

    final subgoals =
        await goalsRef.where('parentGoalId', isEqualTo: goalId).get();
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
              "Goal Hierarchy",
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
                MaterialPageRoute(
                    builder: (_) => HelpGuidanceScreen(showOnComplete: false)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SettingsScreen()));
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Matrix4>(
        valueListenable: _transformController,
        builder: (context, matrix, _) {
          final panOffset = Offset(matrix.storage[12], matrix.storage[13]);

          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                      // painter: BackgroundShapePainter(panOffset),
                      ),
                ),
              ),
              Consumer<GoalProvider>(
                builder: (context, goalProvider, child) {
                  final goalNodes = goalProvider.goalNodes;
                  return InteractiveViewer(
                    transformationController: _transformController,
                    constrained: false,
                    minScale: 0.5,
                    maxScale: 2.0,
                    boundaryMargin: EdgeInsets.all(800),
                    child: goalNodes.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 345, horizontal: 50),
                            child: Center(
                                child: Text(
                                    "Tap the '+' button to add your first goal!",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600]))))
                        : DirectGraph(
                            list: goalNodes,
                            centered: true,
                            defaultCellSize: Size(140.0, 100.0),
                            cellPadding: EdgeInsets.all(30.0),
                            orientation: MatrixOrientation.Vertical,
                            nodeBuilder: (context, node) {
                              final goalIdToName = Provider.of<GoalProvider>(
                                      context,
                                      listen: false)
                                  .goalIdToName;
                              final name =
                                  goalIdToName[node.id] ?? '[Missing Name]';
                              final goal = goalProvider.goals.firstWhere(
                                  (g) => g['id'] == node.id,
                                  orElse: () => {});
                              final progress =
                                  (goal['goalDetails']?['progress'] ?? 0)
                                      .toDouble();
                              return GestureDetector(
                                onLongPress: () {
                                  showGoalDetailPopup(
                                    context: context,
                                    goalId: node.id,
                                    onEdit: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => EditGoalScreen(
                                                goalId: node.id)),
                                      );
                                    },
                                    onSubGoal: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => CreateGoalScreen(
                                                parentGoalId: node.id)),
                                      );
                                    },
                                    onParentGoal: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CreateGoalScreen(
                                              parentGoalId: node.id,
                                              isParentGoal: true),
                                        ),
                                      );
                                    },
                                    onDelete: () => _showDeleteConfirmation(
                                        context, node.id),
                                  );
                                },
                                child: GoalNodeWidget(
                                    name: name, progress: progress),
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
                          ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateGoalScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
