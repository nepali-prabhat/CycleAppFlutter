import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Uid {
  int id;
  Uid({@required this.id});
}

String base_url = 'http://192.168.1.70:3000';

class UsersIds extends StatelessWidget {
  final int currentId;
  final Function setId;

  UsersIds({this.currentId, this.setId});
  
  Future<List<Uid>> _getUserIds() async {
    var url = base_url + '/users/allId';
    var response = await http.get(url);
    var userIdsJson = json.decode(response.body);
    List<Uid> userIds = [];
    for (var userId in userIdsJson) {
      Uid u = Uid(id: userId['id']);
      userIds.add(u);
    }
    return userIds;
  }


  Widget _buildSelectable(Uid uid) {
    return Container(
      height: 60,
      child: Row(
        children: <Widget>[
          Radio(
            onChanged: (e) => setId(e),
            groupValue: currentId,
            value: uid.id,
            activeColor: Colors.green,
          ),
          Text('${uid.id}', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Colors.white10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _getUserIds(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasError){
                    return 
                    Expanded(child: 
                      Text('Error occured.',
                      style: TextStyle(color: Colors.white))
                    ,);
                }
              List<Uid> users = snapshot.data;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int i) {
                  return _buildSelectable(users[i]);
                },
              );
            } else {
              return Row(
                children: <Widget>[
                  Text('loading Cyclists...',
                      style: TextStyle(color: Colors.white)),
                  Expanded(child: Container())
                ],
              );
            }
          },
        ),
      ),
    );
  }
}