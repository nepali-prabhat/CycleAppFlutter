import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http/http.dart' as http;
import 'package:cycle_app/Service/userService.dart';
import '../../../globals.dart';
import 'dart:convert';
import 'dart:async';

class NearByUsersList extends StatelessWidget {
  final MapService mapService = getIt.get<MapService>();
//  int getIndex(NearbyUsers user, List<NearbyUsers> nearby){
//      nearby.map((value)=>{
//         if(nearby.){

//         }
//      });
//  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mapService.nearbyUsers$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (mapService.nearbyUsersHasValue) {
              //return list of nearby users
              List<NearbyUsers> nearby = mapService.nearbyUsers;
              if (nearby.length == 0) {
                return Center(
                    child: Notify(
                  title: "No Cyclists near you.",
                  typeColor: NotifyType.error,
                  desc: "sorry fam.",
                ));
              }
              return ListView(
                  children: nearby.map((value) {
                return NearbyUsersListTile(
                    value,
                    nearby.lastIndexWhere(
                        (near) => near.user.username == value.user.username));
              }).toList());
            } else {
              //meaning it has errors, return an error message
              return Center(child: Text("Sorry, couldnt get nearby users."));
            }
          }
        });
  }
}

class NotifyType {
  static const Color error = Color.fromARGB(255, 247, 174, 158);
  static const Color normal = Color.fromARGB(255, 235, 250, 253);
  static const Color notify = Color.fromARGB(255, 196, 249, 184);
}

class Notify extends StatelessWidget {
  final String title;
  final String desc;
  final Color typeColor;

  const Notify(
      {Key key,
      this.title = "",
      this.desc = "",
      this.typeColor = NotifyType.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: typeColor),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("$title",
                  style: TextStyle(fontFamily: 'Titil', fontSize: 16)),
              Text("$desc",
                  style: TextStyle(
                      fontFamily: 'Catamaran',
                      color: Color.fromARGB(100, 0, 0, 0))),
            ],
          ),
        ));
  }
}

class NearbyUsersListTile extends StatelessWidget {
  final NearbyUsers nearby;
  final int number;
  NearbyUsersListTile(this.nearby, this.number);
  @override
  Widget build(BuildContext context) {
    String bio = nearby.user.bio;
    if (bio.length >= 20) {
      String smallBio = bio.substring(0, 20);
      int i = smallBio.lastIndexOf(" ");
      smallBio = smallBio.substring(0, i);
      smallBio = smallBio + " ...";
      bio = smallBio;
    }
    Future<String> getPhoneNumber() async {
      UserService userService = getIt.get<UserService>();
      http.Response response = await http.get(
          '$base_url/users/getUser/${nearby.user.username}',
          headers: {"Authorization": "Bearer " + userService.tokenValue});
      var res = json.decode(response.body);
      return res["phone_no"];
    }

    String leadingNum = "${number + 1 < 10 ? "0" : ""}${number + 1}";
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return FutureBuilder(
                future: getPhoneNumber(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var phone = snapshot.data;
                    return AlertDialog(
                      title: new Text("You can call!"),
                      content: new Text(""),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text("Phone"),
                          onPressed: () {
                            UrlLauncher.launch("tel:+977 $phone");
                          },
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                });
          },
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: <Widget>[
            Container(
              width: 50,
              child: Center(
                  child: Text(leadingNum,
                      style: TextStyle(fontFamily: 'Titil', fontSize: 25))),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        //avatar
                        Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 235, 250, 253),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Text(
                                    "${nearby.user.username[0].toUpperCase()}",
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 30,
                                        color: Color(0xff2d386b))))),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${nearby.user.username}",
                                  style: TextStyle(
                                      fontFamily: 'Titil', fontSize: 16)),
                              Text("$bio",
                                  style: TextStyle(
                                      fontFamily: 'Catamaran',
                                      color: Color.fromARGB(100, 0, 0, 0))),
                            ],
                          ),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
