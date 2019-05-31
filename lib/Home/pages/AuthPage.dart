import 'package:flutter/material.dart';
import 'package:streaming/LoginTokenPreferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  LoginCredentials _token = new LoginCredentials();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        child: Text(_token.retrieveToken().toString()),
      ),
    );
  }
}
