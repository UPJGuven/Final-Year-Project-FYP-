import 'package:flutter/material.dart';
import '../auth_service.dart';


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
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          // Add more settings options here as needed.
        ],
      ),
    );
  }
}
