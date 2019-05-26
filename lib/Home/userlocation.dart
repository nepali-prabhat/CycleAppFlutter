import 'package:flutter/material.dart';
import 'package:location/location.dart';
import './nearbyUsers.dart';
import '../StaticWidgets/sectionRuler.dart';
import '../Model/userIdModel.dart';
import '../Service/userLocationService.dart';

class UserLocation extends StatefulWidget {
  final int userId;
  UserLocation({Key key, this.userId}) : super(key: key);
  @override
  _UserLocationState createState() {
    return _UserLocationState();
  }
}

class _UserLocationState extends State<UserLocation> {
  var location = new Location();
  ULocation currentLocation;
  bool shouldPost = true;
  bool shouldGetNearbyUsers = false;

  @override
  void initState() {
    super.initState();
    location.onLocationChanged().listen((Map<String, double> value) {
      ULocation newLocation =
          ULocation(long: value['longitude'], lat: value['latitude']);
            setState(() {
                currentLocation = newLocation;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: <Widget>[
        currentLocation != null
            ? RaisedButton(
                onPressed: () {
                  setState(() {
                    if(shouldPost){
                        print("true");
                        shouldGetNearbyUsers = false;
                    }
                    shouldPost = !shouldPost;

                  });
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
              )
            : Text('cannot get your device location.'),
        SizedBox(height: 25),
        shouldPost && currentLocation != null
            ? FutureBuilder(
                future: postUserLocation(widget.userId,currentLocation),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error in posting cyclist location to database',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Ubuntu'));
                    }
                    return Text(
                        "your location  for cyclist ${widget.userId}:(lat: ${currentLocation.lat}, long: ${currentLocation.long}) is posted.",
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
        currentLocation != null
            ? RaisedButton(
                onPressed: () {
                  setState(() {
                      if(shouldPost){
                        shouldGetNearbyUsers = !shouldGetNearbyUsers;
                      }
                  });
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
        SizedBox(height:25),
        shouldGetNearbyUsers?
            NearbyUsers(getNearbyUsers: getNearbyUsers, userId: widget.userId, currentLocation:currentLocation)
            :
            Text(""),
      ]),
    );
  }
}
