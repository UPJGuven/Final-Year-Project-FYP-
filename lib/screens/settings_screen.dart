import 'package:flutter/material.dart';
import '../auth_service.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  // grab object from firebase AuthService for signout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () async {
              await _authService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => AuthWrapper()),
                (route) => false,
              );
            },
          ),

          // sign out makes the user go back to the login screen via main.dart's AuthWrapper() code.
        ],
      ),
    );
  }
}
