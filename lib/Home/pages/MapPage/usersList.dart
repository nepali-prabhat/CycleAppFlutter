import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';

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
    String leadingNum = "${number+1 < 10 ? "0" : ""}${number+1}";
    return Container(
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
                      boxShadow: [
                        // BoxShadow(
                        //     color: Color.fromARGB(255, 235, 250, 253),
                        //     blurRadius: 20,
                        //     offset: Offset(-5, 4))
                      ],
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
                                  "${nearby.user.username[0].toUpperCase()}"
                                  ,style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 30,
                                      color: Color(0xff2d386b)
                                    
                                  )
                                  ))),
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
    );
  }
}
