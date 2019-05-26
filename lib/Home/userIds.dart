import 'package:flutter/material.dart';
import '../Model/userIdModel.dart';
import '../Service/userIdService.dart';

class UsersIds extends StatelessWidget {
  final int currentId;
  final Function setId;

  UsersIds({this.currentId, this.setId});
  
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
          future: getUserIds(),
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