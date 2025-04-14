import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGoalScreen extends StatefulWidget {
  final String? parentGoalId;
  final bool isParentGoal;

  const CreateGoalScreen({this.parentGoalId, this.isParentGoal = false});

  @override
  _CreateGoalScreenState createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  void _addGoal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not authenticated");
      return;
    }

    final goalsRef = FirebaseFirestore.instance.collection('Goal');

    DocumentReference newDoc = goalsRef.doc(); // Let Firestore generate the ID
    final newGoalId = newDoc.id;

    String? actualParentGoalId;

    if (widget.isParentGoal && widget.parentGoalId != null) {
      // If creating a parent, we make the existing node the child
      // So this new node has no parent, but we must update the existing one
      actualParentGoalId = null;

      await goalsRef.doc(widget.parentGoalId!).update({
        'parentGoalId': newGoalId,
      });
    } else {
      // If we're making a subgoal or a regular goal
      actualParentGoalId = widget.parentGoalId;
    }

    final goalData = {
      'id': newGoalId,
      'userId': user.uid,
      'parentGoalId': actualParentGoalId ?? '',
      'goalDetails': {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'startDate': Timestamp.fromDate(_startDate),
        'endDate': Timestamp.fromDate(_endDate),
      }
    };

    await newDoc.set(goalData);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Goal Name'),
                maxLength: 45),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                  'Start Date: ${_startDate.toLocal().toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text(
                  'End Date: ${_endDate.toLocal().toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addGoal,
              child: Text('Add Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
