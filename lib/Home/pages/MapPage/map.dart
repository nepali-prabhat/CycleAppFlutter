import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/Service/userLocationService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:cycle_app/configs.dart';

class MyMap extends StatelessWidget {
  final LocationService locationService = getIt.get<LocationService>();
  final MapService mapService = getIt.get<MapService>();

  List<Marker> _makeMarkers(){
      List<Marker> markers = new List<Marker>();
      markers.add(Marker(
           width: 80.0,
            height: 80.0,
            point: new LatLng(locationService.currentLocation.lat,locationService.currentLocation.long),
            builder: (ctx) =>
                    Icon(Icons.location_on, color: Colors.blue),
      ));
      
      return markers;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: mapService.shouldUpdate$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == true) {
              //return map
              return StreamBuilder(
                  stream: mapService.shouldUpdate$,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                        bool shouldUpdate = snapshot.data;
                        if(shouldUpdate){
                            //return map
                            return StreamBuilder(
                                stream: mapService.updater$,
                                builder:(context, snapshot){
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                    } else {
                                        return FlutterMap(
                                            options: MapOptions(
                                                center: LatLng(locationService.currentLocation.lat,locationService.currentLocation.long),
                                                zoom: 13
                                            ),
                                            layers: [
                                                new TileLayerOptions(
                                                    urlTemplate: "https://api.tiles.mapbox.com/v4/"
                                                        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                                                    additionalOptions: {
                                                        'accessToken': getIt.get<Configs>().mapToken,
                                                        'id': 'mapbox.streets',
                                                    },
                                                ),
                                                new MarkerLayerOptions(
                                                    markers: _makeMarkers()
                                                ),
                                            ],
                                        );
                                    }
                                }
                            );
                        }else{
                            //return button to make should update true
                            return RaisedButton(
                                onPressed: () {
                                    mapService.setShouldUpdate(true);
                                },
                                child: Text("load Map :)")
                            );
                        }
                    }
                  });
            } else {
              return Center(
                  child: RaisedButton(
                      onPressed: () {
                        mapService.setShouldUpdate(true);
                      },
                      child: Text("load Map :)")));
            }
          }
        }
    );
  }
}
