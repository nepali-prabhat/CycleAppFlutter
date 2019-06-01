import 'package:cycle_app/Model/longLat.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class LocationService {
  BehaviorSubject<bool> _shouldPost;
  bool get shouldPost => _shouldPost.value;
  Observable<bool> get shouldPost$ => _shouldPost.stream;

  BehaviorSubject<bool> _shouldGetNearbyUsers;
  bool get shouldGetNearbyUsers => _shouldGetNearbyUsers.value;
  Observable<bool> get shouldGetNearbyUsers$ => _shouldGetNearbyUsers.stream;

  BehaviorSubject<LongLat> _currentLocation;
  LongLat get currentLocation => _currentLocation.value;
  Observable<LongLat> get currentLocation$ => _currentLocation.stream;

  Location _location = new Location();

  LocationService() {
    _shouldPost = new BehaviorSubject.seeded(false);
    _shouldGetNearbyUsers = new BehaviorSubject.seeded(false);
    _currentLocation = new BehaviorSubject<LongLat>.seeded(null);
    _location.onLocationChanged().listen((Map<String, double> value) {
      if (_shouldPost.value || true) {
        LongLat newLocation =
            LongLat(long: value['longitude'], lat: value['latitude']);
        _currentLocation.add(newLocation);
      }
    });
  }

  void setShouldPost(bool state) {
    _shouldPost.add(state);
  }

  void setGetNearbyUsers(bool state) {
    _shouldGetNearbyUsers.add(state);
  }

  void dispose() {
    _currentLocation.close();
    _shouldGetNearbyUsers.close();
    _shouldPost.close();
  }
}
