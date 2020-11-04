import 'package:latlong/latlong.dart';
import 'package:mapTest/loadModules/stations.dart';

import '../onSelected.dart';
import 'Bus.dart';

class Station{
  LatLng pos = initMapCenter;
  String name = "";
  String description = "";
  String stationGroup;
  List<String> servedLines = [];
  List<double> distFromLineStart = [];
  bool selected = false;
  int shade = 0;

  Station(LatLng pos){
    this.pos = pos;
  }
  Station.empty(){
  }
  Station.byName(String name){
    this.name = name;
  }
  Station.namePos(String name, LatLng pos){
    this.name = name;
    this.pos = pos;
  }
  void setPos( LatLng pos){
    this.pos = pos;
  }

  String getStationName(){
    return name;
  }
  String getStationInfo(){
    return description;
  }
  List<String>getServedLines(){
    return servedLines;
  }

  void dbgPrint(){
    print('_________________________-');
    print('Station: ' + name);
    print('descr. : ' + description);
    print(pos.toString() + ', shade: ' + shade.toString() + ' selected: ' + selected.toString());
    print('num of lines: ' + servedLines.length.toString() +'lines:' + servedLines.toString());
    print('dist from start: ' + distFromLineStart.toString());
  }

  String outString( List<Station> stations){
    String out = '';
    for(var station in stations){
      out += station.name + '\n';
    }
    return out;
  }
  Future<void> activeStationLoad( String rawData) async {
    if(rawData == null){
      print('[  WR  ] no cookie: station');
      return;
    }
    List<String> lines = rawData.split('\n');
    for(var line in lines){
      if(line.isEmpty){
        continue;
      }
      for(var station in stationList){
        if(station.name.contains(line)){
          print('line:' + line.toString());
          activeStation = station;
        }
      }
    }
    onStationSelected();
  }
}