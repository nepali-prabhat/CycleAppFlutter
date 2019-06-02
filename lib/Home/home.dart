import 'package:cycle_app/Home/pages/MapPage/mapPage.dart';
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
          backgroundColor: Color.fromARGB(255,246,248,250),
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
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                MapPage(),
                Center(
                  child: RaisedButton(onPressed: (){
                      getIt.get<UserService>().logOut();
                  },child: Text("log out"),),
                ),
                Text("Third Screen")
              ],
            ),
          )),
    );
  }
}

