import 'dart:convert';

import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/busLines.dart';
import '../geometryFuncts.dart';
import '../main.dart';
import 'busLines.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

final String paperStationName = 'Paper Station';
Station paperStation = new Station.namePos(paperStationName,LatLng(45.230727,19.823666));

List<Station> stationList = [];//paperStation
final String stationLetters = 'ABCDEFGHIJK';
List<Station> selectedStations = [new Station.namePos(paperStationName,LatLng(45.230727,19.823666))];

Future<void> loadStationsFromJson( final String loadCityStr) async {
  user.progStatusString = 'Loading stations.';
  try {
    String rawStationsData = await rootBundle.loadString("assets/stations.json");

    var stationObjsJson = jsonDecode(rawStationsData)[loadCityStr] as List;
    for(var objJson in stationObjsJson) {
      try{
        stationList.add(Station.fromJson(objJson));
      }
      catch(e){
        print(e);
        continue;
      }
    }

    user.progStatusString = '';
    return;
  }
  catch(e) {
    print('[  Er  ] laoding stations: ' + e);
  }
}

selectClosest2Click(LatLng click,String name){
  Station closestStation;
  double closestDist = 50000;   // fix this. 50 km for test
  for(int i =0; i < stationList.length; i++){
    if(stationList[i].selected)
      stationList[i].selected = false;
    double dist = normLoc(click, stationList[i].pos);
    if(dist < closestDist){
      closestDist = dist;
      if(name != ''){
        if(stationList[i].servedLines.contains(name)){
          closestStation = stationList[i];
        }
      }
      else{
        closestStation = stationList[i];
      }
    }
  }
  if(closestStation == null){
    return;
  }

  closestStation.selected = !closestStation.selected; // = true;
  if(!selectedStations.contains(closestStation)){
    selectedStations.add(closestStation);
  }
  else{
    selectedStations.remove(closestStation);
  }
}

void calcDistFromLineStart(){ // calculates distace from lineStart for active station

  /// calculate distance from line start for each served line and add them to [selectedStation.distFromLineStart] list
  for(Station selectedStation in selectedStations){
    for(String servedLine in selectedStation.servedLines){
      for(BusLine line in nsBusLines){
        if(line.name == servedLine){
          int i = selectedStation.servedLines.indexOf(servedLine);
          try{
            selectedStation.distFromLineStart.insert(i, distToPprojection(selectedStation.pos, line.points));
            selectedStation.distFromLineStart.removeAt(i+1);
          }
          catch(e){
            print(e);
          }
        }
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