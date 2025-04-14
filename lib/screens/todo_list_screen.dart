import 'package:flutter/material.dart';

class ToDoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('To-Do List'),
      ),
      body: ListView(
        children: [
          ListTile(title: Text('Revise Literature Review')),
          ListTile(title: Text('Do FVP Work')),
          ListTile(title: Text('SECMAN Revision + ADNET Revision')),
          ListTile(title: Text('TEXT MORE TEXT')),
        ],
      ),
    );
  }
}