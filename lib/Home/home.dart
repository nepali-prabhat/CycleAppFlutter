import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import '../StaticWidgets/sectionRuler.dart';
import './userlocation.dart';

class MyHome extends StatelessWidget {
    final UserService userService = getIt.get<UserService>();
    
  @override
  Widget build(BuildContext context) {
      int id = userService.userValue.id;
    return Scaffold(
        backgroundColor: Color(0xFF2d3447),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(12, 30, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 12,
                    ),
                    Text("The 10/10 Cycle App",
                        style: TextStyle(
                          fontFamily: 'Gloria',
                          fontSize: 30,
                          color: Colors.white,
                        ))
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            SectionRuler(section: "Your cycle Id"),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Currently you are cyclist: $id",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            SizedBox(height: 25),
            SectionRuler(
              section: "Change Cyclist",
            ),
            SizedBox(height: 25),
            SizedBox(height: 25),
            SectionRuler(
              section: "Show/Hide your location",
            ),
            UserLocation(),
          ],
        )));
  }
}
