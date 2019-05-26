import 'package:flutter/material.dart';
import '../Model/userLocationModel.dart';
import '../Model/userIdModel.dart';
class NearbyUsers extends StatelessWidget {
  final Function getNearbyUsers;
  final int userId;
  final ULocation currentLocation;
  NearbyUsers({@required this.getNearbyUsers, @required this.userId, @required this.currentLocation});

  Widget _buildUsersList(List<LocationGet>locationGet){
      return SizedBox(
        height: 200,
        child: ListView.builder(
            itemCount: locationGet.length,
            itemBuilder: (BuildContext context, int i) {
                return ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.cyan,child:Text(locationGet[i].user.fName[0].toUpperCase(), style: TextStyle(color:Colors.black38))),
                    title: Text(locationGet[i].user.fName+' '+locationGet[i].user.lName, style: TextStyle(color:Colors.white)),
                    subtitle: Text("long:" + locationGet[i].long.toString() +" , lat:"+ locationGet[i].lat.toString(),style: TextStyle(color:Colors.white)),
                );
            },
          ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNearbyUsers(userId,currentLocation),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
                return Text('Couldn\'t get nearby cyclists.',
                        style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontFamily: 'Ubuntu'));
            }
            List<LocationGet>data = snapshot.data;
            if(data.length ==0){
              return Text('No nearby Cyclists',
                        style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontFamily: 'Ubuntu'));
            }
            return _buildUsersList(data);
        }
        if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
        }
      },
    );
  }
}
