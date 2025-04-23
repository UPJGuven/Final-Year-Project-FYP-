import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_goalapp/screens/help_guidance_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'goal_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Higher-Arc',
      theme:
          ThemeData(fontFamily: 'MADEOkineSans', primarySwatch: Colors.orange),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return LoginScreen();
        }

        final userId = snapshot.data!.uid;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GoalProvider(userId)),
          ],
          child: FutureBuilder<bool>(
            future: shouldShowHelpScreen(userId),
            builder: (context, helpSnapshot) {
              if (helpSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              return helpSnapshot.data == true
                  ? HelpGuidanceScreen()
                  : MainScreen();
            },
          ),
        );
      },
    );
  }
}

Future<bool> shouldShowHelpScreen(String userId) async {
  try {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (!doc.exists || doc.data()?['hasSeenHelp'] != true) {
      print("Showing help screen for first-time user: $userId");
      await FirebaseFirestore.instance.collection('Users').doc(userId).set(
        {'hasSeenHelp': true},
        SetOptions(merge: true),
      );
      return true;
    }
    print("User $userId has already seen help screen.");
    return false;
  } catch (e) {
    print("Error checking help screen status: $e");
    return false;
  }
}
