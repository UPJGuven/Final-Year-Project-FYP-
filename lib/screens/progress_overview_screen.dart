import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/goal_detail_popup.dart';
import 'create_goal_screen.dart';
import 'edit_goal_screen.dart';

Color getProgressColor(double progress) {
  if (progress < 33) return Colors.redAccent;
  if (progress < 66) return Colors.orangeAccent;
  return Colors.greenAccent;
}

class ProgressOverviewScreen extends StatefulWidget {
  final Function(String goalId) onGoalSelected;

  ProgressOverviewScreen({required this.onGoalSelected});

  @override
  _ProgressOverviewScreenState createState() => _ProgressOverviewScreenState();
}

class _ProgressOverviewScreenState extends State<ProgressOverviewScreen> {
  String _filter = 'in_progress';

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Goal Progress",
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
          PopupMenuButton<String>(
            icon: Icon(Icons.sort_rounded, size: 30),
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'all', child: Text("All")),
              PopupMenuItem(value: 'in_progress', child: Text("In Progress")),
              PopupMenuItem(value: 'completed', child: Text("Completed")),
              PopupMenuItem(value: 'not_started', child: Text("Not Started")),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Goal')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final goals = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .where((goal) {
            final progress = (goal['goalDetails']['progress'] ?? 0).toDouble();
            if (_filter == 'in_progress') return progress > 0 && progress < 100;
            if (_filter == 'completed') return progress == 100;
            if (_filter == 'not_started') return progress == 0;
            return true;
          }).toList();

          if (goals.isEmpty) {
            return Center(child: Text("No goals match your filter.", style: TextStyle(fontSize: 16, color: Colors.grey[600])));
          }

          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              final name = goal['goalDetails']['name'] ?? 'Unnamed';
              final progress = (goal['goalDetails']['progress'] ?? 0).toDouble();

              return ListTile(
                onLongPress: () {
                  showGoalDetailPopup(
                    context: context,
                    goalId: goal['id'],
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditGoalScreen(goalId: goal['id'])),
                      );
                    },
                    onSubGoal: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreateGoalScreen(parentGoalId: goal['id'])),
                      );
                    },
                    onParentGoal: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreateGoalScreen(
                          parentGoalId: goal['id'],
                          isParentGoal: true,
                        )),
                      );
                    },
                    onDelete: () {
                      // Optionally refresh the progress screen
                    },
                  );
                },
                title: Text(name, style: TextStyle(fontSize: 18)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(8.0),
                      minHeight: 15,
                      value: progress / 100,
                      backgroundColor: Colors.grey[300],

                      valueColor: AlwaysStoppedAnimation<Color>(getProgressColor(progress)),
                    ),
                    SizedBox(height: 4),
                    Text("${progress.toInt()}%"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
