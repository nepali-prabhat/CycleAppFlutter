import 'package:cycle_app/Model/NearbyUsers.dart';
import 'package:cycle_app/Model/longLat.dart';
import 'package:cycle_app/Service/locationService.dart';
import 'package:cycle_app/Service/mapService.dart';
import 'package:cycle_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:cycle_app/configs.dart';

class MyMap extends StatefulWidget {
  final Function toggleExpandMap;
  final bool expandedState;
  MyMap({Key key, this.toggleExpandMap, this.expandedState}) : super(key: key); 

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final LocationService locationService = getIt.get<LocationService>();

  final MapService mapService = getIt.get<MapService>();
  double zoom = 15;
  zoomIn(){
      if(zoom<20){
        this.setState((){
            zoom += 3;
            print(zoom);
        });
      }
  }
  zoomOut(){
      if(zoom>10){
        this.setState((){
            zoom -= 3;
            print(zoom);
        });
      }
  }
  List<Marker> _makeMarkers() {
    List<Marker> markers = new List<Marker>();
    markers.add(Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(locationService.currentLocation.lat,
          locationService.currentLocation.long),
      builder: (ctx) => Icon(Icons.location_on, color: Colors.blue),
    ));
    if (mapService.shouldGetNearbyUsers == true) {
      if (mapService.nearbyUsersHasValue) {
        List<NearbyUsers> nearby = mapService.nearbyUsers;
        for (NearbyUsers user in nearby) {
          markers.add(Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(user.lat, user.long),
              builder: (ctx) => Icon(Icons.location_on, color: Colors.red)));
        }
      }
    }
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
                      if (shouldUpdate) {
                        //return map
                        return StreamBuilder(
                            stream: mapService.updater$,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Stack(
                                  children: <Widget>[
                                    FlutterMap(
                                      options: MapOptions(
                                          center: LatLng(
                                              locationService.currentLocation.lat,
                                              locationService.currentLocation.long),
                                          zoom: zoom),
                                      layers: [
                                        new TileLayerOptions(
                                          urlTemplate:
                                              "https://api.tiles.mapbox.com/v4/"
                                              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                                          additionalOptions: {
                                            'accessToken':
                                                getIt.get<Configs>().mapToken,
                                            'id': 'mapbox.streets',
                                          },
                                        ),
                                        new MarkerLayerOptions(
                                            markers: _makeMarkers()),
                                      ],
                                    ),
                                    Positioned(
                                        bottom: 20,
                                        right: 20,
                                        child: OutlineButton(color: Colors.blueGrey[100],child: Icon( widget.expandedState? Icons.fullscreen_exit:Icons.zoom_out_map,color:Colors.black,size:30),onPressed: (){widget.toggleExpandMap();}),
                                    ),
                                    Positioned(
                                        bottom: 20,
                                        left: 20,
                                        child: OutlineButton(color: Colors.blueGrey[100],child: Icon(Icons.zoom_out,color:Colors.black,size:40),onPressed: (){zoomOut();}),
                                    ),
                                    Positioned(
                                        bottom: 60,
                                        left: 20,
                                        child: OutlineButton(color: Colors.blueGrey[100],child: Icon(Icons.zoom_in,color:Colors.black,size:40),onPressed: (){zoomIn();}),
                                    )
                                  ],
                                );
                              }
                            });
                      } else {
                        //return button to make should update true
                        return RaisedButton(
                            onPressed: () {
                              mapService.setShouldUpdate(true);
                            },
                            child: Text("load Map :)"));
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
        });
  }
}
