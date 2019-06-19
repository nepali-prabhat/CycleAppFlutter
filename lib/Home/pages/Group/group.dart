import 'package:cycle_app/Model/UserModel.dart';
import 'package:cycle_app/Model/messageModel.dart';
import 'package:cycle_app/Model/myEventsModel.dart';
import 'package:cycle_app/Service/groupService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Group extends StatefulWidget {
  final MyEventsModel event;
  Group({this.event});

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  GroupService groupService = getIt.get<GroupService>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('# ${groupService.group.id}:${groupService.group.name}')),
        body: Container(
          child: Column(
          children: <Widget>[
              //messages
          Expanded(
            child: Container( child: 
                StreamBuilder(
                    stream: groupService.updater$,
                    builder: (cnxt, snapshot){
                        if(snapshot.connectionState==ConnectionState.done){
                            //return messages
                            return StreamBuilder(
                                stream: groupService.message$,
                                builder:(cnxt, snapshot){
                                    if(snapshot.connectionState==ConnectionState.done){
                                        if(!snapshot.hasError){
                                            List<MessageModel> data = snapshot.data;
                                            return Text('msg here');
                                        }else{
                                            return Center(child: Text('Something wrong.'));
                                        }
                                    }else{
                                        return Center(child:CircularProgressIndicator());
                                    }
                                }
                            );
                        }else{
                            return Center(child:CircularProgressIndicator());
                        }
                    },)
            ),
          ),
          Container(
              height:30,
              child:Row(
                  children: <Widget>[
                      Text('message box here')
                  ],
              )
          )
          ],
        ),
        ));
  }
}
