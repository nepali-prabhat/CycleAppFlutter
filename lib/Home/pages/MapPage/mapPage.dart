import 'package:cycle_app/Home/pages/MapPage/map.dart';
import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/Service/userLocationService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  final UserService userService = getIt.get<UserService>();
  final LocationService locationService = getIt.get<LocationService>();
  final MapService mapService = getIt.get<MapService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Container(
              height: MediaQuery.of(context).size.height * .4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                BoxShadow(
                    blurRadius: 8, color: Colors.black45, spreadRadius: 2),
              ]),
              child: MyMap()),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Container(

            child: StreamBuilder(
                stream: mapService.shouldGetNearbyUsers$,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  //once value arrived
                  if (snapshot.connectionState == ConnectionState.active) {
                    bool shouldGetNearbyUsers = snapshot.data;

                    if (shouldGetNearbyUsers == true) {
                      //return list of nearby users
                        return Text("list of nearby users");
                    } else {
                      //return a button to get nearby user
                      return 
                      
                      Center(
                        child: RaisedButton(
                            onPressed: () {
                              mapService.setGetNearbyUsers(true);
                            },
                            child: Text('Get nearby cyclists.')),
                      );
                    }
                  }
                }),
          ),
        ))
      ],
    );
  }
}
