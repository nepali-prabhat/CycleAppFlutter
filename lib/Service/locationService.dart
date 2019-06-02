import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/main.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
    BehaviorSubject<bool> _shouldPost;
    bool get shouldPost => _shouldPost.value;
    Observable<bool> get shouldPost$ => _shouldPost.stream;

    BehaviorSubject<LongLat> _currentLocation;
    LongLat get currentLocation => _currentLocation.value;
    Observable<LongLat> get currentLocation$ => _currentLocation.stream;

    Location _location = new Location();

    LocationService(){
        _shouldPost = new BehaviorSubject.seeded(false);
        _currentLocation = new BehaviorSubject<LongLat>.seeded(null);
        _location.onLocationChanged().listen((Map<String, double> value) {
            //for now wil always get device location
            if(_shouldPost.value || true){
                LongLat newLocation =
                LongLat(long: value['longitude'], lat: value['latitude']);
                _currentLocation.add(newLocation);
            }
        });
        _readSettingsFromLocalStore();
    }

    void setShouldPost(bool value){
        _shouldPost.add(value);
        _saveSettingsToLocalStore();
        //todo: post current location in database

    }

    void _saveSettingsToLocalStore(){
    SharedPreferences.getInstance().then((pref){
        pref.setBool("shouldPost",shouldPost);
    });
  }
  void _readSettingsFromLocalStore(){
    SharedPreferences.getInstance().then((pref){
        if(pref.containsKey('shouldPost')){
            _shouldPost.add(pref.getBool("shouldPost"));
        }
    });
  }
  void _deleteSettingsFromLocalStore(){
      SharedPreferences.getInstance().then((pref){
        pref.remove('shouldPost');
      });
  }

    void dispose(){
        _currentLocation.close();
        _shouldPost.close();
    }
}