import 'dart:async';
import 'package:cycle_app/Model/groupModel.dart';
import 'package:cycle_app/globals.dart';
import 'package:cycle_app/main.dart';
import 'package:http/http.dart'as http;
import 'package:cycle_app/Model/UserModel.dart';
import 'package:cycle_app/Model/messageModel.dart';
import 'package:cycle_app/Model/myEventsModel.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:cycle_app/Service/userService.dart';
class GroupService{

    BehaviorSubject<MyEventsModel> _event;
    MyEventsModel get event =>_event.value;
    Observable<MyEventsModel> get event$ => _event.stream;
    
    BehaviorSubject<GroupModel> _group;
    GroupModel get group =>_group.value;
    Observable<GroupModel> get group$ => _group.stream;

    BehaviorSubject<List<MessageModel>> _message;
    List<MessageModel> get message => _message.value;
    Observable<List<MessageModel>> get message$ => _message.stream;

    BehaviorSubject<List<UserModel>> _participants;
    List<UserModel> get participants => _participants.value;
    Observable<List<UserModel>> get participants$ => _participants.stream;

    BehaviorSubject<int> _updater;
    int get updater => _updater.value;
    Observable<int> get updater$ => _updater.stream;

    Timer _updateTimer;
    
    GroupService(){
        _event = new BehaviorSubject<MyEventsModel>();
        _message = new BehaviorSubject<List<MessageModel>>.seeded([]);
        _updater = new BehaviorSubject<int>.seeded(1);
        _group = new BehaviorSubject<GroupModel>();
        _participants = new BehaviorSubject();
        
        _updateTimer = new Timer.periodic(Duration(seconds:5), (Timer timer){
                _updater.add(updater+1);
        });
    }
    void addEvent(MyEventsModel event)async{
        _event.add(event);
        http.Response response = await http.get('$base_url/groups/of/${event.id}',headers:  {"Authorization":"Bearer ${getIt.get<UserService>().tokenValue}"});
        if(response.statusCode==200){
            //success
            GroupModel group = groupModelFromJson(response.body);
            _addGroup(group);
            _addParticipant();
            addMessageByFetching(group.id);
        }else{
        }
    }
    _addParticipant(){
        List<UserModel> tempParticipants;
        event.participants.forEach((participant) {
        tempParticipants.insert(0, UserModel.fromJson(json.encode(participant)));
        _participants.add(tempParticipants);
    });
    }
    void addMessageByFetching(int groupId) async{
        print('addMessage by fetching');
        http.Response response = await http.get('$base_url/messages/${groupId}',headers:  {"Authorization":"Bearer ${getIt.get<UserService>().tokenValue}"});
        if(response.statusCode == 200){
            print('200');
            List<MessageModel> msg = messageModelFromJson(response.body);
            _message.add(msg);
        }
    }
    void _addGroup(GroupModel group){
        _group.add(group);
    }
    void update(){
        _updater.add(updater+1);
    }
}