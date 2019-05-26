import 'package:cycle_app/Model/userIdModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../Model/userLocationModel.dart';
import '../globals.dart';

  Future<http.Response> postUserLocation(int userId,ULocation currentLocation) async {
    var url = base_url + '/locations/$userId';
    var body = {
      'long': currentLocation.long.toString(),
      'lat': currentLocation.lat.toString()
    };
    final response = await http.post(url, body: body);
    return response;
  }

  Future<List<LocationGet>> getNearbyUsers( int userId, ULocation currentLocation) async {
    var url = base_url+'/locations/nearby/' + '$userId';
    var urlWithQuery =
        _makeQueryURL(url, {'long': currentLocation.long, 'lat': currentLocation.lat});
    final response = await http.get(urlWithQuery);
    List<LocationGet> nearbyUsers = locationGetFromJson(response.body);
    return nearbyUsers;
  }

  String _makeQueryURL(String url, Map<String,dynamic> queryParams){
    String returnURL = url+"?";
    for(var paramKey in queryParams.keys){
        returnURL = '${returnURL + paramKey}=${queryParams[paramKey]}&';
    }
    returnURL=returnURL.substring(0,returnURL.length-1);
    return returnURL;
  }
