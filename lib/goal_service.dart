import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

Future<void> createGoalMap(Map<String, dynamic> goalData) async {
  try {
    CollectionReference goals = _firestore.collection('Goal');

    DocumentReference docRef = await goals.add(goalData);

    await docRef.update({"id": docRef.id});

    print("Goal added successfully with ID: ${docRef.id}");
  } catch (e) {
    print('Error adding goal: $e');
  }
}
