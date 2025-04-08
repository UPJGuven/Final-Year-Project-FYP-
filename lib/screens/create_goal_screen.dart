import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../goal_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGoalScreen extends StatefulWidget {
  @override
  _CreateGoalScreenState createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addGoal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Map<String, dynamic> goalData = {
        "id": "autogenId",
        'parentGoalId': null, // Change if this goal has a parent
        'userId': user.uid, // Replace with actual user ID
        "goalDetails": {
          'name': _nameController.text, // Replace with user input
          'description': _descriptionController.text,
          'startDate': Timestamp.now(), // Example start date
          'endDate': Timestamp.now(), // Example end date
        }
      };
      await createGoalMap(goalData);
      } else {
      print("User not Authenticated");
    }

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
                // final newGoal = Goal(
                //   id: DateTime.now().millisecondsSinceEpoch.toString(),
                //   name: _nameController.text,
                //   description: _descriptionController.text,
                // );
                _addGoal();
                Navigator.pop(context); // Return goal to previous screen
              },
              child: Text('Add Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
