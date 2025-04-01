import 'package:flutter/material.dart';
import '../goal.dart';
import '../goal_service.dart';

class CreateGoalScreen extends StatefulWidget {
  @override
  _CreateGoalScreenState createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Goal Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newGoal = Goal(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  description: _descriptionController.text,
                );

                Map<String, dynamic> newGoalDB = {
                  'title': 'Run a marathon',
                  'description': 'Train and complete a marathon within a year.',
                  'startDate': '2024-12-31',
                  'endDate': '2025-12-31',
                };
                createGoal(newGoalDB);

                Navigator.pop(context, newGoal); // Return goal to previous screen
              },
              child: Text('Add Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
