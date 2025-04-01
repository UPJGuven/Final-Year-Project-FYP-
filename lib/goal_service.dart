import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createGoal(Map<String, dynamic> goalData) async {
  try {
    CollectionReference goals = FirebaseFirestore.instance.collection('Goal');
    await goals.add(goalData);
    print('Goal added successfully!');
  } catch (e) {
    print('Error adding goal: $e');
  }
}

Future<void> updateGoal(String goalDocumentId, Map<String, dynamic> updatedData) async {
  try {
    CollectionReference goals = FirebaseFirestore.instance.collection('Goal');
    await goals.doc(goalDocumentId).set(updatedData, SetOptions(merge: true)); // Merge the update
    print('Goal updated successfully!');
  } catch (e) {
    print('Error updating goal: $e');
  }
}