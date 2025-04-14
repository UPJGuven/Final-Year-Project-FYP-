import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditGoalScreen extends StatefulWidget {
  final String goalId;

  EditGoalScreen({required this.goalId});

  @override
  _EditGoalScreenState createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final doc = await FirebaseFirestore.instance
        .collection('Goal')
        .doc(widget.goalId)
        .get();
    final data = doc.data();
    if (data != null) {
      final details = data['goalDetails'];
      setState(() {
        _nameController.text = details['name'] ?? '';
        _descriptionController.text = details['description'] ?? '';
        _startDate = (details['startDate'] as Timestamp).toDate();
        _endDate = (details['endDate'] as Timestamp).toDate();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateGoal() async {
    await FirebaseFirestore.instance.collection('Goal').doc(widget.goalId).set({
      "goalDetails": {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'startDate': _startDate != null
            ? Timestamp.fromDate(_startDate!)
            : FieldValue.serverTimestamp(),
        'endDate': _endDate != null
            ? Timestamp.fromDate(_endDate!)
            : FieldValue.serverTimestamp(),
      }
    }, SetOptions(merge: true));

    Navigator.pop(context); // Return after updating
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
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
      appBar: AppBar(title: Text('Edit Goal')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            "Start Date: ${_startDate != null ? formatter.format(_startDate!) : 'Not set'}"),
                      ),
                      TextButton(
                        onPressed: () => _pickDate(context, true),
                        child: Text('Select Start Date'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            "End Date: ${_endDate != null ? formatter.format(_endDate!) : 'Not set'}"),
                      ),
                      TextButton(
                        onPressed: () => _pickDate(context, false),
                        child: Text('Select End Date'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateGoal,
                    child: Text('Update Goal'),
                  ),
                ],
              ),
            ),
    );
  }
}
