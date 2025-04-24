import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  // grab object from firebase AuthService for authentication service
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(125),
                ),
              ),
            ),
            // orange circle art

            Positioned(
              bottom: -120,
              right: -120,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),
            // blue circle art

            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App Logo
                    Image.asset(
                      'assets/images/FYP Logo v1.0 No Line.png',
                      height: 240,
                    ),
                    SizedBox(height: 20),

                    Text(
                      "\"Set goals, create your own goal hierarchy, track your progress and create your own to-do list!\".",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),

                    ElevatedButton.icon(
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text(
                        "Sign in with Google",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                        color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        User? user = await _authService.signInWithGoogle();
                        // authentication
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Google sign-in failed. Please try again."),
                            ),
                          );
                        }
                      },
                    ),
                    // Sign In Button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
