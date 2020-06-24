import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/loadModules/ldBusSchedule.dart';
import 'package:mapTest/loadModules/stations.dart';
import 'busLines.dart';
import 'busLocator.dart';

Marker busTest;

void onPosChange(MapPosition mapPos, bool h){
  //print(mapPos.center);
  //print(mapPos.zoom);
}
Future<void> onTap(LatLng tapPos) async {
  //print(tapPos.latitude.toString() + "," + tapPos.longitude.toString());
  selectClosest2Click(tapPos);
  await loadLinesFromFile(activeStation.servedLines); // load only the active lines
  for(BusLine busLine in nsBusLines){
    LdLineSchedule(busLine, DateTime.now());
  }
  /*for(var line in activeStation.servedLines) {
    for(var busLine in nsBusLines){
      if(busLine.name == line){
        LdLineSchedule(busLine, DateTime.now());
      }
    }
  }*/
  //print(distToPprojection(activeStation.pos, nsBusLines[0].points));

  //addStation(tapPos); //add stations
}

FlutterMap drawOsmMap() {
  return new FlutterMap(
    options: MapOptions(
      center: LatLng(45.2603, 19.8260),
      zoom: 14,
      maxZoom: 17,
      minZoom: 12,
      swPanBoundary: LatLng(45.1934, 19.6247),
      nePanBoundary: LatLng(45.2901, 20.0442),
      onPositionChanged: onPosChange,
      onTap: onTap,
      interactive: true,
    ),
    layers: [
      TileLayerOptions(
       // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
        //urlTemplate: 'http://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png http://b.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
        subdomains: ['a', 'b', 'c'],
        // For example purposes. It is recommended to use
        // TileProvider with a caching and retry strategy, like
        // NetworkTileProvider or CachedNetworkTileProvider
        tileProvider: NonCachingNetworkTileProvider(),
      ),
      /*PolylineLayerOptions(
         // polylines: getBusLines(),
         polylines: getBusLines(),
      ),*/
      MarkerLayerOptions(
        markers: getStationMarkers(),
      ),
      MarkerLayerOptions(
        markers: getBusMarkers(),
      ),
    ],
  );
}

class mapView extends StatefulWidget {
  mapViewState createState() => mapViewState ();
}

class mapViewState extends State<mapView> {

  @override
  void initState(){

    loadStationsFromFiles();
    //loadLinesFromFile();

    Timer.periodic(Duration(milliseconds: 200 ), (v) {
      setState(() { drawOsmMap();});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: drawOsmMap(),
      ),
      );
  }
}