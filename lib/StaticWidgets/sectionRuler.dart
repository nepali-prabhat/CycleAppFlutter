import 'package:flutter/material.dart';
class SectionRuler extends StatelessWidget {
  final String section;
  SectionRuler({this.section});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Divider(
          color: Colors.white30,
        )),
        SizedBox(width: 5),
        Text(
          section,
          style: TextStyle(
              color: Colors.white30, fontSize: 20, fontFamily: 'Ubuntu'),
        ),
        SizedBox(width: 5),
        Expanded(
            child: Divider(
          color: Colors.white30,
        )),
      ],
    );
  }
}
