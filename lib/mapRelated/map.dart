import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/mapConfig.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/mapRelated/drawoverlay.dart';
import 'package:mapTest/mapRelated/scrollDetector.dart';
import 'package:mapTest/uiElements/legacySchedule.dart';
import 'package:map_controller/map_controller.dart';
import '../main.dart';
import '../onSelected.dart';

/// from: https://pub.dev/packages/map_controller

FlutterMap map = new FlutterMap();
MapConfig mapConfig = new MapConfig();
MapController mapController = new MapController();

StreamController<int> mapTileSwitchController = new StreamController<int>.broadcast();

MapPageState displayedMap;
int activeMapTile = 0;
String mapProviderName = 'Google classic';
List<String> mapProviderNames = ['Google classic','OSM classic','Google hybrid','Google terrain','OSM white','Google satelite'];

class MapPage extends StatefulWidget {
  final Stream<int>stream;
  MapPage(this.stream);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {

  String maptileUrl = 'http://{s}.google.com/vt/lyrs=r&x={x}&y={y}&z={z}';
  List<String> subdomains = ['mt0', 'mt1', 'mt2','mt3'];

  static StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  @override
  void initState() {
    widget.stream.listen((num) { switchTileUrl(num); });
    mapController = new MapController();
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
    this.switchTileUrl(activeMapTile);

    var displayedMap = ScrollDetector(
        onPointerScroll: processScroll, //processScroll,
        child: Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
          ),
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
                      rotationThreshold: 60,
                      //swPanBoundary: LatLng(45.1934, 19.6247),      //TODO: dbg only
                      // nePanBoundary: LatLng(45.2901, 20.0442),
                      interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      onPositionChanged: onPosChange,
                      onTap: onTap,
                      interactive: true,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: maptileUrl, //google maps normal
                        subdomains: subdomains,
                        tileProvider: NonCachingNetworkTileProvider(),
                      ),

                    ],
                  )
                ])),
          ),
        )
    );
    return displayedMap;
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  void switchTileUrl(int tyleUrlNum){
   /// h = roads only
   /// m = standard roadmap
   /// p = terrain
   /// r = somehow altered roadmap
   /// s = satellite only
   /// t = terrain only
   /// y = hybrid

    setState(() {
      switch(tyleUrlNum){
        case 0:
          maptileUrl = 'http://{s}.google.com/vt/lyrs=r&x={x}&y={y}&z={z}';     // Normal Google
          subdomains = ['mt0', 'mt1', 'mt2','mt3'];
          break;
        case 5:
          maptileUrl = 'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}';     // Satelite Google
          subdomains = ['mt0', 'mt1', 'mt2','mt3'];
          break;
        case 2:
          maptileUrl = 'http://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}';   // hybrid Google
          subdomains = ['mt0', 'mt1', 'mt2','mt3'];
          break;
        case 3:
          maptileUrl = 'http://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}';     // terrain Google
          subdomains = ['mt0', 'mt1', 'mt2','mt3'];
          break;
        case 4:
          maptileUrl = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png';     // OSM white
          subdomains = ['a','b','c'];
          break;
        case 6:   // TODO: figure out how to use this
          maptileUrl = 'https://suboticagis.rs/map/tile?map=2_karta&g=383_ortofoto_2008&i=JPEG&t={x}&l={y}&s={z}';
          break;
        case 1:
          maptileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';    // OSM classic
          subdomains = ['a','b','c'];
          break;
      }
    });
  }

  Future<void> onTap(LatLng tapPos) async {
    print('taped at: ' + tapPos.latitude.toString() + ',' + tapPos.longitude.toString());
    //mapController.move(tapPos, mapController.zoom);
    print('"lat" : ' + tapPos.longitude.toString() + ',\n"lon" : ' + tapPos.latitude.toString() + ',');

    if(user.tabOpen == 5){
      selectedStations.clear();
      selectClosest2Click(tapPos,selectedLine);
      user.tabOpen = 0;
    }
    else{
      selectClosest2Click(tapPos,'');
    }
    onStationSelected();
    redrawOverlayController.add(tapPos.latitude.toInt());                               // stram - add any data
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

  /*void setCenter(LatLng center, double zoom){
    mapController.move(center, zoom);
  }*/
}
