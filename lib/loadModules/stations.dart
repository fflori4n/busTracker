import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/UIColors.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/busLines.dart';
import '../geometryFuncts.dart';
import 'busLines.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'busLocator.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Station paperStation = new Station(LatLng(45.237330061975,19.80649497604369));

List<Station> stationList = [paperStation];
Station activeStation = new Station.byName('No selected station!');

Future<String> loadAsset() async {

}
Future<void> loadStationsFromFiles() async {
  try {
    print('stations load');
    String rawFileContent = await rootBundle.loadString('assets/nsStations.txt');
    List<String> lines = rawFileContent.split('\n');
    for(int i=0; i<lines.length;i++){
      lines[i].trim();
      if(!(lines[i].isEmpty || lines[i][0] == '#')){
        List<String> csvList = lines[i].split('|');
        List<String> coords = csvList[1].split(',');
        List<String> servedLines = csvList[3].split(',');
        if(coords.length != 2){
          print('[  Er  ] incorrect latlng ' + lines[i]);
          continue;}
        Station newStation = new Station(LatLng(double.parse(coords[1]),double.parse(coords[0])));
        newStation.name = csvList[0];
        newStation.stationGroup = csvList[2];
        if(newStation.stationGroup != 'I'){ // skip everithing not area I for now DBG
          continue;
        }
        newStation.servedLines = servedLines;
        newStation.shade = 1;
        newStation.description = '';

        //newStation.dbgPrint();
        stationList.add(newStation);
      }
      print(stationList.length);
    }
    //dbgPrintStationList();
    return;
  }
  catch(e) {
    print('[  Er  ] laoding stations: ' + e);
  }
}

List<Marker> getStationMarkers(){
  List<Marker> stationMarkers = [];

  for(int i=0; i < stationList.length; i++) {
    Color inactiveColor = inactiveStationCol;

    //print(stationList[i].shade);
    if(stationList[i].shade == 1){
      inactiveColor = inactiveStationCol2;
    }
    //print('adding' + stationList[i].name);
    stationMarkers.add(new Marker(
        width: stationList[i].selected ? 25.0 : 12.0,
        height: stationList[i].selected ? 25.0 : 12.0,
        point: stationList[i].pos,
        builder: (ctx) =>
        new Container(
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border:Border.all(
              width: stationList[i].selected ? 4.0 : 2.0,
              color: stationList[i].selected ?  baseBlack.withOpacity(0.8) : baseBlack.withOpacity(0.4),
            ) ,
            color: Colors.transparent,
          ),
        )));
  }

  return stationMarkers;
}

selectClosest2Click(LatLng click){
  Station closestStation;
  double closestDist = 50000;   // fix this. 50 km for test
  for(int i =0; i < stationList.length; i++){
    if(stationList[i].selected)
      stationList[i].selected = false;
    double dist = normLoc(click, stationList[i].pos);
    if(dist < closestDist){
      closestDist = dist;
      closestStation = stationList[i];
    }
  }
  closestStation.selected = true;
  activeStation = closestStation;

  /*for(var bus in buslist){
    if(!(activeStation.servedLines.contains(bus.busLine))){
      buslist.remove(bus);
    }
  }*/
  buslist.clear();
  activeStation.distFromLineStart.clear();
  for(int i=0; i< activeStation.servedLines.length; i++){   // init line from dist to be safe
    activeStation.distFromLineStart.add(0.0);
  }

  for(var servedLine in activeStation.servedLines){
    for(var line in nsBusLines){
      if(line.name == servedLine){
        addSelectedBuses(activeStation, servedLine);
        int i = activeStation.servedLines.indexOf(servedLine);
        activeStation.distFromLineStart.insert(i, distToPprojection(activeStation.pos, line.points));
        activeStation.distFromLineStart.removeAt(i+1);
      }
    }
  }
}

double getDistFromLineStart(LatLng target, BusLine line){
  double avrgDist = 3000;
  for(int i = 0; i < (line.points.length - 1);i++){
    double dist = normLoc(target, line.points[i]) + normLoc(target, line.points[i + 1]);
    if(dist < avrgDist){
      avrgDist = dist;
    }
  }
}

void dbgPrintStationList(){
  print('** DBG stationList **');
  print('length:' + stationList.length.toString());
  for(var station in stationList){
    station.dbgPrint();
  }
}