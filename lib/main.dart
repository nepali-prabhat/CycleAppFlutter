import 'package:flutter/material.dart';
import './Home/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int userId = 1;
  @override
  void initState() {
    super.initState();
  }

  void setUserId(int id) {
    setState(() {
      userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "The Cycle App", home: MyHome(setUserId: setUserId, id: userId));
  }
}
