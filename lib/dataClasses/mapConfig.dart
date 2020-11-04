import 'package:latlong/latlong.dart';

import '../main.dart';

class MapConfig{
  LatLng mapCenter;
  LatLng mapNW;
  LatLng mapSE;

  double mapZoom;

  String toString(){
    return

      mapController.center.latitude.toString() + '\n' +
      mapController.center.longitude.toString() + '\n' +
      mapController.zoom.toString();
  }
  Future<void> loadFromString(String rawData) async {
    if(rawData == null){
      print('[  WR  ] no cookie: mapConfig');
      return;
    }
    List<String> lines = rawData.split('\n');
    for(var line in lines){
      print(line);
    }
    try{
      mapCenter = LatLng(double.parse(lines[0]),double.parse(lines[1]));
      mapZoom = double.parse(lines[2].toString());
      //print(mapCenter.toString() + ',' + mapZoom.toString());
    }
    catch(e){
      print('[  ER  ] loading mapConfig from cookie: ' + e.toString());
    }
    //mapController.move(mapCenter, mapZoom); // TODO: move map somehow
  }
}