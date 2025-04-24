import 'package:flutter/material.dart';
import 'create_goal_screen.dart';
import 'edit_goal_screen.dart';
import 'goal_hierarchy_screen.dart';
import 'todo_list_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import 'progress_overview_screen.dart';
import '../widgets/goal_detail_popup.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  List<Widget> get _screens => [
    GoalHierarchyScreen(),
    ProgressOverviewScreen(
      onGoalSelected: (goalId) {
        setState(() {
          _currentIndex = 0;
        });

        Future.delayed(Duration(milliseconds: 300), () {
          showGoalDetailPopup(
            context: context,
            goalId: goalId,
            onEdit: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => EditGoalScreen(goalId: goalId)),
              );
            },
            onSubGoal: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => CreateGoalScreen(parentGoalId: goalId)),
              );
            },
            onParentGoal: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => CreateGoalScreen(parentGoalId: goalId, isParentGoal: true)),
              );
            },
            onDelete: () {
            },
          );
        });
      },
    ),
    ToDoListScreen(),
  ];

  // screens list for navigation, passes goal information to progression screen

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      // bottom navigatinon bar
    );
  }
}