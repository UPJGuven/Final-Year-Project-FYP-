import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text("Sign in with Google"),
          onPressed: () async {
            User? user = await _authService.signInWithGoogle();
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Google sign-in failed. Please try again.")),
              );
            }
          },
        ),
      ),
    );
  }
}