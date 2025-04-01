import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _addGoal() async {
    Map<String, dynamic> goalData = {
      "id": "autogenId",
      'parentGoalId': null, // Change if this goal has a parent
      'userId': 'user_12345', // Replace with actual user ID
      "goalDetails": {
        'name': 'My New Goal', // Replace with user input
        'description': 'Description of my goal',
        'startDate': Timestamp.now(), // Example start date
        'endDate': Timestamp.now(), // Example end date
      }
    };
    await createGoalMap(goalData);
  }

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
                _addGoal();
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
