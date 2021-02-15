import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/mapConfig.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/mapRelated/scrollDetector.dart';
import 'package:map_controller/map_controller.dart';
import '../main.dart';
import '../onSelected.dart';

/// from: https://pub.dev/packages/map_controller

FlutterMap map = new FlutterMap();
MapConfig mapConfig = new MapConfig();
MapController mapController = new MapController();


class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  //final LatLng mapRefPoint = mapRefPoint;

  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  @override
  void initState() {
    statefulMapController = StatefulMapController(mapController: mapController);

    /// wait for the controller to be ready before using it
    statefulMapController.onReady.then((_) => (){
      mapConfig.mapCenter = map.options.center;
      mapConfig.mapZoom = map.options.zoom;
      print("The map controller is ready");
    });

    /// [Important] listen to the changefeed to rebuild the map on changes:
    /// this will rebuild the map when for example addMarker or any method
    /// that mutates the map assets is called
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDetector(
      onPointerScroll: processScroll,//processScroll,
      child: Scaffold(
        body: SafeArea(
            child: Stack(children: <Widget>[
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: mapRefPoint,
                  zoom: 14,
                  maxZoom: 17,
                  minZoom: 8,
                  //swPanBoundary: LatLng(45.1934, 19.6247),      //TODO: dbg only
                  // nePanBoundary: LatLng(45.2901, 20.0442),
                  onPositionChanged: onPosChange,
                  onTap: onTap,
                  interactive: true,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                    //urlTemplate: 'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
                    //urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    //urlTemplate: 'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    tileProvider: NonCachingNetworkTileProvider(),
                  ),

                ],
              )
            ])),
      ),
    );
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  Future<void> onTap(LatLng tapPos) async {
    print('taped at: ' + tapPos.latitude.toString() + ',' + tapPos.longitude.toString());
    //mapController.move(tapPos, mapController.zoom);

    selectClosest2Click(tapPos);
    onStationSelected();
  }

  static double scrollDist = 0;
  void processScroll(PointerScrollEvent details){
    final double scrollSensitivity = 30;

    //print(details.scrollDelta.dy);
    scrollDist += details.scrollDelta.dy;
    if(scrollDist >= scrollSensitivity || scrollDist <= -scrollSensitivity){
      print('scroll at:');
      print(details.localPosition.dx.toString());
      print(details.localPosition.dy.toString());
      double zoom = mapController.zoom;
      if(scrollDist >= scrollSensitivity){
        zoom--;
      }
      else{
        zoom++;
      }
      mapController.move(mapController.center, zoom);
      print(scrollDist);
      scrollDist = 0;
    }
  }

  void onPosChange(MapPosition mapPos, bool h){
    mapConfig.mapNW = mapPos.bounds.northWest;
    mapConfig.mapSE = mapPos.bounds.southEast;
    mapConfig.mapCenter = mapPos.center;
    mapConfig.mapZoom = mapPos.zoom;
  }

  void setCenter(LatLng center, double zoom){
    mapController.move(center, zoom);
  }
}
