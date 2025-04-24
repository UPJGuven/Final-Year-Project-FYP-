import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

Stream<List<Map<String, dynamic>>> getUserTasks() {
  final user = _auth.currentUser;
  if (user == null) return const Stream.empty();
  // get current signed-in user

  return _firestore
      .collection('ToDo')
      .where('userId', isEqualTo: user.uid)
      .orderBy('position')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
    final data = doc.data();
    return {
      'id': doc.id,
      'text': data['text'] ?? '',
      'completed': data['completed'] ?? false,
      'position': data['position'] ?? 0,
    };
  }).toList());
}

// gets to-do list data of current user from firebase

Future<void> addTask(String text) async {
  final user = _auth.currentUser;
  if (user == null) return;

  final snapshot = await _firestore
      .collection('ToDo')
      .where('userId', isEqualTo: user.uid)
      .orderBy('position', descending: true)
      .limit(1)
      .get();

  // get snapshot of a to-do item

  final newPosition = snapshot.docs.isNotEmpty
      ? (snapshot.docs.first.data()['position'] ?? 0) + 1
      : 0;
  // index new position

  await _firestore.collection('ToDo').add({
    'userId': user.uid,
    'text': text,
    'completed': false,
    'position': newPosition,
    'timestamp': FieldValue.serverTimestamp(),
  });
  // add to-do to firebase .
}
//

Future<void> updateTask(String docId, String newText, bool isDone) async {
  await _firestore.collection('ToDo').doc(docId).update({
'text': newText,
'completed': isDone,
});
}
// update ONLY text and completion status in firebase

Future<void> updateTaskPosition(String docId, int newPosition) async {
  await _firestore.collection('ToDo').doc(docId).update({
    'position': newPosition,
  });
}
//update task position index

Future<void> deleteTask(String docId) async {
  await _firestore.collection('ToDo').doc(docId).delete();
}

// delete to-do