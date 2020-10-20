import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';

//import 'loadModules/mapViewOSM.dart';
import 'dataClasses/BusLine.dart';
import 'geometryFuncts.dart';
import 'loadModules/busLines.dart';
import 'loadModules/ldBusSchedule.dart';
import 'loadModules/stations.dart';
import 'main.dart';

// from: https://pub.dev/packages/map_controller
FlutterMap map = new FlutterMap();

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {
  //MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

   void setCenter(LatLng center){
    mapController.move(center, mapController.zoom);
  }

  @override
  void initState() {
    // intialize the controllers
    //mapController = mapController;
    statefulMapController = StatefulMapController(mapController: mapController);

    // wait for the controller to be ready before using it
    statefulMapController.onReady.then((_) => (){
      mapCenter = map.options.center;
      mapZoom = map.options.zoom;
      print("The map controller is ready");
    });

    loadStationsFromFiles();  // TODO: Fix me -- move to better location

    /// [Important] listen to the changefeed to rebuild the map on changes:
    /// this will rebuild the map when for example addMarker or any method
    /// that mutates the map assets is called
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(children: <Widget>[
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: mapRefPoint,
                zoom: 14,
                maxZoom: 17,
                minZoom: 12,
                //swPanBoundary: LatLng(45.1934, 19.6247),      //TODO: dbg only
                //nePanBoundary: LatLng(45.2901, 20.0442),
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
            )
          ])),
    );
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

void onPosChange(MapPosition mapPos, bool h){
  //print(mapPos.center);
  //print(mapPos.zoom);
  mapNW = mapPos.bounds.northWest;
  mapSE = mapPos.bounds.southEast;

  mapCenter = mapPos.center;
  mapZoom = mapPos.zoom;
  //print('MAP: ' + mapCenter.toString() + ',' + mapZoom.toString());
}

Future<void> onTap(LatLng tapPos) async {
  //print('taped at:' + tapPos.toString());
  //mapController.move(tapPos, mapController.zoom);

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