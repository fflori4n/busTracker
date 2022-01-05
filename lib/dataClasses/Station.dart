import 'dart:convert';

import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/loadModules/loadStations.dart';

import '../onSelected.dart';
import 'Bus.dart';

class Station{
  LatLng pos = initMapCenter;
  String name = "";
  String description = "";
  String stationGroup;
  List<String> servedLines = [];
  List<BusLine> lines = [];       // TODO: use always this insted of servedLines
  List<double> distFromLineStart = [];
  bool selected = false;
  bool isActiveFocused = false;
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
      if(station.name != "Paper Station"){
        out += station.name + '\n';
      }
    }
    return out;
  }

  bool doesServedLinesContain(String key){
    if(this.servedLines.indexOf(key) >= 0)
      return true;
    return false;
  }

  void setActiveFocused(){
    for(Station station in selectedStations){
      station.isActiveFocused = false;
    }
    this.isActiveFocused = true;
  }
  void clearActiveFocused(){
    this.isActiveFocused = false;
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
        if(station.name.contains(line) && !selectedStations.contains(station)){
          print('line:' + line.toString());
          selectedStations.add(station);

          //activeStation = station;
        }
      }
    }
    onStationSelected();
  }
  
  factory Station.fromJson(dynamic json) {
    try{
      Station newStation = Station.empty();
      newStation.name = json['name'] as String;
      newStation.pos = LatLng(json['lon'],json['lat']);
      newStation.stationGroup = json['zone'] as String;

      var lineList = json['served_lines'];
      newStation.servedLines = lineList != null ? List.from(lineList) : null;

      //newStation.dbgPrint();
      return newStation;
    }
    catch(e){
      print(e);
      throw "[  Er  ] laoding station w uid:" + json['uid'];
    }
  }
}

