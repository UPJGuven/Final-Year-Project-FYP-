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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Edit Goal",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8), // spacing between text and image
            Image.asset(
              'assets/images/FYP Logo No Text v1.0.png',
              height: 30,
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goal Name',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
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
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _nameController,
                      maxLength: 60,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Goal Description',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
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
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 8,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Start Date",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _startDate != null
                              ? formatter.format(_startDate!)
                              : 'Not selected',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.orange[600],
                          size: 40,
                        ),
                        label: Text("Select",
                            style: TextStyle(color: Colors.orange[600])),
                        onPressed: () => _pickDate(context, true),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "End Date",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _endDate != null
                              ? formatter.format(_endDate!)
                              : 'Not selected',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.orange[600],
                          size: 40,
                        ),
                        label: Text("Select",
                            style: TextStyle(color: Colors.orange[600])),
                        onPressed: () => _pickDate(context, false),
                      ),
                    ],
                  ),
                  SizedBox(height: 34),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text(
                        "Update Goal",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _updateGoal,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
