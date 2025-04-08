import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'login_screen.dart';


class SettingsScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

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
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false, // Removes all previous routes
              );
            },
          ),
          // Add more settings options here as needed.
        ],
      ),
    );
  }
}
