import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../goal_provider.dart';
import 'main_screen.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<GoalProvider>(  // Listen for changes in GoalProvider
          builder: (context, goalProvider, child) {
            // Check if the goal data is loaded or still being fetched
            if (goalProvider.goalNodes.isEmpty) {
              // Still loading or no data found
              return CircularProgressIndicator();
            } else {
              // Once goals are loaded, navigate to GoalHierarchyScreen
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(initialIndex: 0)),
                );
              });
              return Container();  // Empty container as we are already navigating
            }
          },
        ),
      ),
    );
  }
}
