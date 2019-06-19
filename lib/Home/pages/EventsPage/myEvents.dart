import 'package:cycle_app/Home/pages/Group/group.dart';
import 'package:cycle_app/Model/myEventsModel.dart';
import 'package:cycle_app/Service/groupService.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/StaticWidgets/sectionRuler.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cycle_app/Service/eventService.dart';
import 'package:toast/toast.dart';

class MyEventLayout extends StatefulWidget {
  final MyEventsModel event;
  final bool isMine;
  final Function changeActiveIndex;
  MyEventLayout(this.event, {this.isMine = true, this.changeActiveIndex});

  @override
  _MyEventLayoutState createState() => _MyEventLayoutState();
}

class _MyEventLayoutState extends State<MyEventLayout> {
  int changeForRender = 0;
  UserService userService = getIt.get<UserService>();
  getIfParticipated() {
    bool participated = false;
    widget.event.participants.forEach((participant) {
      if (participant['id'] == userService.userValue.id) {
        participated = true;
      }
    });
    return participated;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, blurRadius: 10, spreadRadius: -10)
              ],
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  //event name and description
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.event.name,
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 22,
                                color: Colors.purple[200]),
                            softWrap: true,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.event.description,
                            softWrap: true,
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 15,
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              //todo:
              //start date at time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Start",
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                          color: Colors.deepOrange[200])),
                  Text(widget.event.startDateTime.toString().split(' ')[0],
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 15,
                        color: Colors.indigo[300],
                      )),
                  Text(
                      " at ${widget.event.startDateTime.toString().split(' ')[1].substring(0, 5)}",
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 15,
                        color: Colors.indigo[300],
                      )),
                ],
              ),
              //end date at time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("End",
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                          color: Colors.deepOrange[200])),
                  Text(widget.event.endDateTime.toString().split(' ')[0],
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 15,
                        color: Colors.indigo[300],
                      )),
                  Text(
                      " at ${widget.event.endDateTime.toString().split(' ')[1].substring(0, 5)}",
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 15,
                        color: Colors.indigo[300],
                      )),
                ],
              ),
              SizedBox(height: 20),
              //completed or not
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      "Ongoing with ${widget.event.participants.length} participant",
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 15,
                          color: Colors.grey))),

              SizedBox(height: 20),
              changeForRender >= 0
                  ? Row(
                      mainAxisAlignment: widget.isMine
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                      children: <Widget>[
                        !widget.isMine
                            ? RaisedButton(
                                color: Colors.purple[200],
                                onPressed: () async {
                                  String response = await participateInEvent(
                                      widget.event.id,
                                      participated: getIfParticipated());
                                  Toast.show(response, context,
                                      duration: Toast.LENGTH_LONG);
                                  setState(() {
                                    changeForRender++;
                                  });
                                },
                                child: getIfParticipated()
                                    ? Text("Remove Participation")
                                    : Text("Participate"),
                              )
                            : SizedBox(),
                        RaisedButton(
                            color: Colors.blue[100],
                            onPressed: () {
                                Toast.show('comming soon',context);
                            //     GroupService groupService = getIt.get<GroupService>();
                            //     groupService.addEvent(widget.event);
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Group(event:widget.event))
                            //   );
                            },
                            child: Text('Group')),
                        widget.isMine
                            ? RaisedButton(
                                color: Colors.green[200],
                                onPressed: () {},
                                child: Text('Update'))
                            : SizedBox(),
                        widget.isMine
                            ? RaisedButton(
                                color: Colors.red[200],
                                onPressed: () async {
                                  String response =
                                      await deleteEvent(widget.event.id);
                                  Toast.show(response, context,
                                      duration: Toast.LENGTH_LONG);
                                  setState(() {
                                    changeForRender++;
                                  });
                                },
                                child: Text('Delete'))
                            : SizedBox(),
                      ],
                    )
                  : Container()
            ],
          ),
        ));
  }
}

class MyEvents extends StatelessWidget {
  final Function changeActiveIndex;
  MyEvents({this.changeActiveIndex});

  @override
  Widget build(BuildContext context) {
    print('my events rendered');
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          SectionRuler(section: "Your Events:", color: Colors.purple[200]),
          FutureBuilder(
            future: getMyEvents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.statusCode == 200) {
                  String body = snapshot.data.body;

                  List<MyEventsModel> myEvents = myEventsFromJson(body);
                  var evetsLayoutList = myEvents
                      .map((event) => (MyEventLayout(event,
                          changeActiveIndex: changeActiveIndex)))
                      .toList();
                  return Column(children: evetsLayoutList);
                } else {
                  return Center(
                      child: Text(
                          'server down. Be patient until we fix it back.'));
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          SectionRuler(
              section: "Participated Events:", color: Colors.purple[200]),
          FutureBuilder(
            future: getAllEvents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.statusCode == 200) {
                  String body = snapshot.data.body;
                  UserService userService = getIt.get<UserService>();
                  List<MyEventsModel> allEvents = myEventsFromJson(body);
                  List<MyEventsModel> participatedEvent = [];
                  allEvents.forEach((event) {
                    event.participants.forEach((participant) {
                      if (participant['id'] == userService.userValue.id) {
                        participatedEvent.insert(
                            participatedEvent.length, event);
                      }
                    });
                  });
                  var evetsLayoutList = participatedEvent
                      .map((event) => (MyEventLayout(event,
                          changeActiveIndex: changeActiveIndex,isMine: false,)))
                      .toList();
                  return Column(children: evetsLayoutList);
                } else {
                  return Center(
                      child: Text(
                          'server down. Be patient until we fix it back.'));
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
