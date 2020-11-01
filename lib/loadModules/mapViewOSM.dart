import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/loadModules/ldBusSchedule.dart';
import 'package:mapTest/loadModules/stations.dart';
import '../filters.dart';
import '../geometryFuncts.dart';
import '../main.dart';
import 'busLines.dart';
import 'busLocator.dart';

Marker busTest;
FlutterMap map = new FlutterMap();
void onPosChange(MapPosition mapPos, bool h){
  //print(mapPos.center);
  //print(mapPos.zoom);
  mapConfig.mapNW = mapPos.bounds.northWest;
  mapConfig.mapSE = mapPos.bounds.southEast;

  mapConfig.mapCenter = mapPos.center;
  mapConfig.mapZoom = mapPos.zoom;
  print('MAP: ' + mapConfig.mapCenter.toString() + ',' + mapConfig.mapZoom.toString());
}
Future<void> onTap(LatLng tapPos) async {
  //print('taped at:' + tapPos.toString());
  selectClosest2Click(tapPos);
  await loadLinesFromFile(activeStation.servedLines,false);
  calcDistFromLineStart();
  for(BusLine busLine in nsBusLines){
    ldLineSchedule(busLine, DateTime.now());
  }

  for(var busline in nsBusLines){
    returnStationOnLine(busline);
  }

}

FlutterMap drawOsmMap() {
   map = new FlutterMap(
    options: MapOptions(
      center: mapRefPoint,
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
        tileProvider: NonCachingNetworkTileProvider(),
      ),
    ],
  );
  mapConfig.mapCenter = map.options.center;
  mapConfig.mapZoom = map.options.zoom;
  return map;
}

class mapView extends StatefulWidget {
  mapViewState createState() => mapViewState ();
}

class mapViewState extends State<mapView> {

  @override
  void initState(){
    loadStationsFromFiles();  // TODO: Fix me -- move to better location
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: Listener(
            onPointerSignal: (pointerSignal){
              if(pointerSignal is PointerScrollEvent){
                // do something when scrolled
                print('Scrolled' + pointerSignal.position.toString());
              }
            },
            child: drawOsmMap(),
      )
      ),);
  }
}