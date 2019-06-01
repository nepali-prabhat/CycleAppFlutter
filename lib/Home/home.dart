import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/userLocationService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/configs.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: Container(
                color: Colors.transparent,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      TabBar(
                          indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                  color: Color(0xffff0863), width: 4.0),
                              insets: EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 0)),
                          indicatorWeight: 15,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Color(0xff2d386b),
                          labelStyle: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.3,
                              fontWeight: FontWeight.w500),
                          unselectedLabelColor: Colors.black26,
                          tabs: [
                            Tab(
                              text: "Cyclists",
                              icon: Icon(Icons.disc_full, size: 40),
                            ),
                            Tab(
                              text: "MyProfile",
                              icon:
                                  Icon(Icons.supervised_user_circle, size: 40),
                            ),
                            Tab(
                              text: "Settings",
                              icon: Icon(Icons.settings, size: 40),
                            ),
                          ]),
                    ],
                    
                  ),
                ),
              ),
            ),
          ),
          body: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                NearbyUsersList(),
                Center(
                  child: Text("Secon Screen"),
                ),
                Text("Third Screen")
              ],
            ),
          )),
    );
  }
}

class NearbyUsersList extends StatelessWidget {
  final UserService userService = getIt.get<UserService>();
  final LocationService locationService = getIt.get<LocationService>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Container(
                height: MediaQuery.of(context).size.height * .6,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 8, color: Colors.black45, spreadRadius: 2),
                ]),
                child: MyMap()),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 8, color: Colors.black45, spreadRadius: 2),
              ]),
              child: StreamBuilder(
                  stream: locationService.shouldGetNearbyUsers$,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data != null) {
                        bool shouldGetNearbyUsers = snapshot.data;
                        if (shouldGetNearbyUsers) {
                          return FutureBuilder(
                            future:
                                getNearbyUsers(locationService.currentLocation),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                List<NearbyUsers> nearbyUsers = snapshot.data;
                                if (nearbyUsers.length >= 1) {
                                  return ListView.builder(
                                    itemCount: nearbyUsers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          child: Text(nearbyUsers[index]
                                              .user
                                              .username[0]
                                              .toUpperCase()),
                                        ),
                                        title: Text(
                                            nearbyUsers[index].user.username),
                                        subtitle:
                                            Text(nearbyUsers[index].user.bio),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                      child: Text("no cyclist nearby"));
                                }
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: RaisedButton(
                              onPressed: () {
                                locationService.setGetNearbyUsers(true);
                              },
                              child: Text('get nearby users.'),
                            ),
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class MyMap extends StatelessWidget {
  final LocationService locationService = getIt.get<LocationService>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: locationService.currentLocation$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            LongLat current = snapshot.data;
            if (current != null) {
              return FlutterMap(
                options: MapOptions(
                    center: LatLng(current.lat, current.long), zoom: 13),
                layers: [
                  new TileLayerOptions(
                    urlTemplate: "https://api.tiles.mapbox.com/v4/"
                        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                    additionalOptions: {
                      'accessToken': getIt.get<Configs>().mapToken,
                      'id': 'mapbox.streets',
                    },
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 80.0,
                        height: 80.0,
                        point: new LatLng(current.lat, current.long),
                        builder: (ctx) => new Container(
                              child: Icon(Icons.location_on,
                                  color: Colors.blueAccent),
                            ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                  child: Text("Sorry, cannot get your mobile location."));
            }
          }
        });
  }
}
