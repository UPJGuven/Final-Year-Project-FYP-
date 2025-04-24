import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
    final formatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Create Goal", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Image.asset('assets/images/FYP Logo No Text v1.0.png', height: 30),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goal Name Field
            Text(
              'Goal Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[500]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 4)),
                ],
              ),
              child: TextField(
                controller: _nameController,
                maxLength: 60,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter Goal Name...',
                  hintStyle: TextStyle(color: Colors.white70),
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Description Field
            Text(
              'Goal Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[500]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 4)),
                ],
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 8,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter Goal Description...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Start Date
            Text("Start Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatter.format(_startDate),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.calendar_today, color: Colors.orange[600], size: 40),
                  label: Text("Select", style: TextStyle(color: Colors.orange[600])),
                  onPressed: () => _selectDate(context, true),
                ),
              ],
            ),

            SizedBox(height: 16),

            // End Date
            Text("End Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatter.format(_endDate),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.calendar_today, color: Colors.orange[600], size: 40),
                  label: Text("Select", style: TextStyle(color: Colors.orange[600])),
                  onPressed: () => _selectDate(context, false),
                ),
              ],
            ),

            SizedBox(height: 34),

            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text("Create Goal", style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _addGoal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

