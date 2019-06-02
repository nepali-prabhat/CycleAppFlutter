import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/main.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

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
    }

    void setShouldPost(bool state){
        _shouldPost.add(state);
    }
    void dispose(){
        _currentLocation.close();
        _shouldPost.close();
    }
}