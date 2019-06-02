import 'package:cycle_app/Home/pages/MapPage/mapPage.dart';
// import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/mapService.dart';
// import 'package:cycle_app/Service/userLocationService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/configs.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

final backColor = Color.fromARGB(255, 117, 152, 247);
bool _isCollapsed = true;
double screenwidth, screenheight;

class Layout extends StatefulWidget {
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with SingleTickerProviderStateMixin {
  final Duration duration = Duration(milliseconds: 100);
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  UserService userService = getIt.get<UserService>();
  LocationService locationService = getIt.get<LocationService>();
  MapService mapService = getIt.get<MapService>();
  bool showSettings;
  @override
  void initState() {
    super.initState();
    showSettings = false;
    _controller = AnimationController(vsync: this, duration: duration);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.reverse();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          menu(context),
          home(context),
          showSettings ? settings(context) : Container()
        ],
      ),
    );
  }
  // Widget buildInfoBars(Icon icon, String title, String subtitle){
  //     return Row(
  //             children: <Widget>[
  //               icon,
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Text(
  //                         title,
  //                         style: TextStyle(
  //                             fontSize: 22,

  //                             fontFamily: 'Ubuntu'
  //                             ),
  //                     ),
  //                     Text(
  //                         subtitle,
  //                         style: TextStyle(
  //                             fontSize: 15,
  //                             fontFamily: 'Ubuntu'
  //                             ),
  //                     )
  //               ],)

  //             ],
  //           );
  // }
  Widget settings(context) {
    double width = MediaQuery.of(context).size.width;
    bool permission = userService.userValue.permission == 1 ? true : false;
    bool post = locationService.shouldPost;
    return PreferredSize(
      preferredSize: Size.fromHeight(width - 100),
      child: SafeArea(
        child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 15, spreadRadius: 100)
                ]),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.settings,
                                  color: Colors.deepPurple[300]),
                              SizedBox(width: 10),
                              Text("Settings",
                                  style: TextStyle(
                                      color: Colors.deepPurple[300],
                                      fontFamily: "Titil",
                                      fontSize: 20))
                            ],
                          )),
                    ),
                    Container(
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                            onPressed: () {
                              setState(() {
                                showSettings = false;
                              });
                            },
                            child:
                                Icon(Icons.close, color: Colors.red[300]))),
                  ],
                ),
                SizedBox(height: 30),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Public Location",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Titil",
                              color: Color.fromARGB(130, 0, 0, 0))),
                      Switch(
                          value: post,
                          onChanged: (value) {
                            //change in database
                            locationService.setShouldPost(value);
                          })
                    ],
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Get Nearby Cyclists",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Titil",
                              color: Color.fromARGB(130, 0, 0, 0))),
                      Switch(
                          value: mapService.shouldGetNearbyUsers,
                          onChanged: (value) {
                            //change in database
                            mapService.setGetNearbyUsers(value);
                          })
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Public Info",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Titil",
                              color: Color.fromARGB(130, 0, 0, 0))),
                      Switch(
                          value: permission,
                          onChanged: (value) {
                            //change in database
                            userService.changePermission(value);
                          })
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal:25),
                    child: FlatButton(
                        color: Colors.red[300],
                        onPressed:(){
                            userService.logOut();
                    },child: Center(child: Text("Log Out", style: TextStyle(color:Colors.white, fontFamily: "Titil", fontSize: 20))),)
                ),
                SizedBox(height: 30),
              ],
            )),
      ),
    );
  }

  Widget menu(context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 40,
                  backgroundColor: Color.fromARGB(255, 235, 250, 253),
                  child: Text(
                    userService.userValue.username
                        .substring(0, 1)
                        .toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 35,
                        color: Color(0xff2d386b)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  userService.userValue.username.toLowerCase(),
                  style: TextStyle(
                      color: Colors.black, fontSize: 30, fontFamily: 'Titil'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    userService.userValue.bio,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: 'Catamaran'),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () {},
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.directions_bike, color: Colors.blue),
                            SizedBox(width: 10),
                            Text("Cyclists",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Titil",
                                    fontSize: 20))
                          ],
                        )),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () {},
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.portrait, color: Colors.indigo[300],size: 25),
                            SizedBox(width: 10),
                            Text("Profile",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Titil",
                                    fontSize: 21))
                          ],
                        )),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        if (showSettings == false) {
                          showSettings = true;
                        }
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.settings, color: Colors.deepPurple[300]),
                            SizedBox(width: 10),
                            Text("Settings",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Titil",
                                    fontSize: 20))
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  Widget home(context) {
    Size size = MediaQuery.of(context).size;
    screenheight = size.height;
    screenwidth = size.width;

    return AnimatedPositioned(
      duration: duration,
      top: _isCollapsed ? 0 : 0.2 * screenheight,
      bottom: _isCollapsed ? 0 : 0.2 * screenwidth,
      left: _isCollapsed ? 0 : 0.6 * screenwidth,
      right: _isCollapsed ? 0 : -0.4 * screenwidth,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        elevation: 8.0,
        color: backColor,
        child: DefaultTabController(
          length: 3,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (!_isCollapsed) {
                  _controller.reverse();
                  _isCollapsed = true;
                }
              });
            },
            child: Scaffold(
                // backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.restaurant_menu,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_isCollapsed) {
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }
                        _isCollapsed = !_isCollapsed;
                      });
                    },
                  ),
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
                                    insets: EdgeInsets.fromLTRB(
                                        40.0, 20.0, 40.0, 0)),
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
                                    icon: Icon(Icons.supervised_user_circle,
                                        size: 40),
                                  ),
                                  Tab(
                                    text: "Posts",
                                    icon: Icon(Icons.plus_one, size: 40),
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
                    // physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      MapPage(),
                      Center(
                        child: RaisedButton(
                          onPressed: () {
                            getIt.get<UserService>().logOut();
                          },
                          child: Text("log out"),
                        ),
                      ),
                      Text("Third Screen"),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
