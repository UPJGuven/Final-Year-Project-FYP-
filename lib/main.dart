import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'goal_provider.dart';
import 'screens/loading_screen.dart';
import 'screens/login_screen.dart';
import 'screens/goal_hierarchy_screen.dart';
import 'screens/todo_list_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Setting App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWrapper(), // Decides what to show based on authentication
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While waiting for auth info, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If a user is signed in, pass the userId to GoalProvider and go to MainScreen
        if (snapshot.hasData && snapshot.data != null) {
          final String userId = snapshot.data!.uid;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => GoalProvider(userId)),
            ],
            child: MainScreen(initialIndex: 0), // default to Goal Hierarchy screen
          );
        }
        // If not signed in, show the LoginScreen
        return LoginScreen();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    GoalHierarchyScreen(),
    ToDoListScreen(),
  ];

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
    );
  }
}