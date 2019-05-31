import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import './nearbyUsers.dart';
import '../StaticWidgets/sectionRuler.dart';
import '../Service/userLocationService.dart';

class UserLocation extends StatelessWidget {
  final LocationService locationService = getIt.get<LocationService>();
  final UserService userService = getIt.get<UserService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: <Widget>[
        StreamBuilder<Object>(
            stream: locationService.currentLocation$,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                bool shouldPost = locationService.shouldPost;
                bool shouldGetNearbyUsers =
                    locationService.shouldGetNearbyUsers;
                LongLat currentLocation = snapshot.data;
                return Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        if (shouldPost) {
                          locationService.setGetNearbyUsers(false);
                        }
                        locationService
                            .setShouldPost(!locationService.shouldPost);
                      },
                      color: Colors.transparent,
                      child: shouldPost
                          ? Text("stop posting",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontFamily: 'Ubuntu'))
                          : Text("Start posting",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontFamily: 'Ubuntu')),
                    ),
                    SizedBox(height: 25),
                    shouldPost
                        ? FutureBuilder(
                            future: postUserLocation(userService.userValue.id,
                                locationService.currentLocation),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Text(
                                      'Error in posting cyclist location to database',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'Ubuntu'));
                                }
                                return Text(
                                    "your location:(lat: ${currentLocation.lat}, long: ${currentLocation.long}) is posted.",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Ubuntu'));
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                        : SizedBox(),
                    SizedBox(height: 25),
                    SectionRuler(
                      section: "get cyclists near your locatin(1km)",
                    ),
                    SizedBox(height: 25),
                    Column(children: <Widget>[
                      currentLocation != null
                          ? RaisedButton(
                              onPressed: () {
                                if (locationService.shouldPost) {
                                  //toggle value of should get nearby users
                                  locationService.setGetNearbyUsers(
                                      !locationService.shouldGetNearbyUsers);
                                }
                              },
                              color: Colors.transparent,
                              child: shouldGetNearbyUsers
                                  ? Text("Stop getting nearby cyclists.",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontFamily: 'Ubuntu'))
                                  : Text("get nearby cyclists.",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontFamily: 'Ubuntu')),
                            )
                          : Text('cannot get your device location.'),
                      SizedBox(height: 25),
                      shouldGetNearbyUsers
                          ? NearbyUsersList(
                              getNearbyUsers: getNearbyUsers,
                              userId: userService.userValue.id,
                              currentLocation: locationService.currentLocation)
                          : Text(""),
                    ])
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
        SizedBox(height: 25),
        RaisedButton(
            onPressed: () {
              userService.logOut();
            },
            color: Colors.transparent,
            child: Text("log out.",
                style: TextStyle(
                    color: Colors.red, fontSize: 20, fontFamily: 'Ubuntu')))
      ]),
    );
  }
}
