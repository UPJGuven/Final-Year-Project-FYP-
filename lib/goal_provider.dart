import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graphite/graphite.dart';

class GoalProvider with ChangeNotifier {
  List<NodeInput> _goalNodes = [];
  List<NodeInput> get goalNodes => _goalNodes;
  Map<String, String> _goalIdToName = {};
  Map<String, String> get goalIdToName => _goalIdToName;

  GoalProvider(String userId) {
    listenToGoals(userId); // Start listening on provider init
  }

  void listenToGoals(String userId) {
    FirebaseFirestore.instance
        .collection('Goal')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((querySnapshot) {
      List<Map<String, dynamic>> goals = querySnapshot.docs.map((doc) {
        Map<String, dynamic> goalData = doc.data() as Map<String, dynamic>;
        goalData['id'] = doc.id; // Ensure each goal has a unique ID
        goalData['parentGoalId'] = goalData['parentGoalId'] ?? ''; // Default to an empty string if null
        return goalData;
      }).toList();
      print(goals);
      _goalIdToName = {
        for (var goal in goals)
          goal['id']: goal['goalDetails']?['name'] ?? '[Unnamed Goal]'
      };
      _goalNodes = _convertToNodes(goals);
      notifyListeners();
    });
  }

  List<NodeInput> _convertToNodes(List<Map<String, dynamic>> goals) {
    return goals.map((goal) {
      final goalId = goal['id'] ?? '';

      return NodeInput(
          id: goal['id'],
        next: goals
            .where((g) => g['parentGoalId'] == goalId)
            .map((childGoal) {
          final childDetails = childGoal['goalDetails'] ?? {};
          final childName = childDetails['name'] ?? '[Unnamed Subgoal]';
          return EdgeInput(outcome: childName);
        })
            .toList(),
      );
    }).toList();
  }

  // void addGoalNode(String goalName, List<String> subGoals) {
  //   goalNodes.add(
  //     NodeInput(
  //       id: goalName,
  //       next: subGoals.map((dep) => EdgeInput(outcome: dep)).toList(),
  //     ),
  //   );
  //   notifyListeners(); // Notify UI to rebuild
  // }
}
