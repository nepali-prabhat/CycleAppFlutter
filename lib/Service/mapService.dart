import 'dart:async';
import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/userLocationService.dart';
import 'package:cycle_app/main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class MapService{
    BehaviorSubject<List<NearbyUsers>> _nearbyUsers;
    BehaviorSubject<bool> _shouldUpdate;
    BehaviorSubject<int> _updater;
    BehaviorSubject<bool> _shouldGetNearbyUsers;
    Timer _updateTimer;
    MapService(){
        _nearbyUsers = new BehaviorSubject();
        _shouldUpdate = new BehaviorSubject.seeded(false);
        _shouldGetNearbyUsers = new BehaviorSubject.seeded(false);
        _updater = new BehaviorSubject.seeded(0);
        _updateTimer = new Timer.periodic(Duration(seconds:1), (Timer timer){
            if(_shouldUpdate.value){
                _updater.add(updater+1);
            }
        });
    }
    //getters for stream and value:
    Observable<List<NearbyUsers>> get nearbyUsers$ => _nearbyUsers.stream;
    List<NearbyUsers> get nearbyUsers => _nearbyUsers.value;

    Observable<int> get updater$ => _updater.stream;
    bool get shouldUpdate => _shouldUpdate.value;

    Observable<bool> get shouldUpdate$ => _shouldUpdate.stream;
    int get updater => _updater.value;

    bool get shouldGetNearbyUsers => _shouldGetNearbyUsers.value;
    Observable<bool> get shouldGetNearbyUsers$ => _shouldGetNearbyUsers.stream;

    void getNearbyUsersFromService() async{
        try{
            http.Response response = await getNearbyUsers(getIt.get<LocationService>().currentLocation);
            if(response.statusCode != 200){
                _nearbyUsers.addError({"msg":"Sorry, couldnt get nearby cyclists."});
            }else{
                var body = response.body;
                List<NearbyUsers> nearbyUsersResponse = nearbyUsersFromJson(body);
                _nearbyUsers.add(nearbyUsersResponse);
            }   
        }catch(exception){
            _nearbyUsers.addError({"msg":"Sorry, couldnt get nearby cyclists."});
        }
        
    }
    void setGetNearbyUsers(bool value){
        _shouldGetNearbyUsers.add(value);
        if(value == true){
            getNearbyUsersFromService();
        }
    }
    void setShouldUpdate(bool value){
        _shouldUpdate.add(value);
    }
    void dispose(){
        _nearbyUsers.close();
        _shouldUpdate.close();
        _updater.close();
        _shouldGetNearbyUsers.close();
        _updateTimer.cancel();
    }
}