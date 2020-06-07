import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/stations.dart';
import '../geometryFuncts.dart';

final LatLng initMapCenter = new LatLng(0,0);
const double avrgBusSpeed = 17;

List<Bus> buslist=[];
List<LatLng> dbgMarkers = [];

void addDBGMarker(LatLng pos){
  if(!(dbgMarkers.contains(pos))){
    dbgMarkers.add(pos);
  }
}

void moveBus(){
  for(var bus in buslist){

    if(nsBusLines.isEmpty){
      print('[ ER ] no bus lines. cant calc position');
      return;
    }

    DateTime now = DateTime.now();
    DateTime startDateTime = new DateTime(now.year,now.month,now.day,bus.startTime.hours,bus.startTime.mins, bus.startTime.sex);
    int elapsedTime = now.difference(startDateTime).inSeconds;

    if(elapsedTime < 0){
      bus.displayedOnMap = false;
      //bus.noUpdateForTicks = elapsedTime.abs()*2;
    }  // do not show bus that has not departed

    if(bus.noUpdateForTicks == -1 || (bus.noUpdateForTicks != 0 && Time(-1,-1,0) != bus.eTA)){
      //print('skipping:' + bus.printBasic());
      continue;    
    }
    bus.noUpdateForTicks = max(0,bus.noUpdateForTicks-1);       // not very nice

    var line;
    double distPassed = getEstDistPassed(bus.startTime);
    for(line in nsBusLines){
      if(line.name == bus.busLine)
        break;
    }
    bus.busPos = getPOnPolyLineByDist(distPassed,line.points);

    for(int i=0; i<activeStation.servedLines.length; i++){ // optimise too many loops
      if(activeStation.servedLines[i] == bus.busLine){
        Time eta = new Time(0,0,0);
        if((activeStation.distFromLineStart[i] - distPassed) < 0){
          eta.sex = -1;
          bus.setETA(eta);
          bus.noUpdateForTicks = -1;  // never update this
          continue;
        }
        int newETAsecs = ((activeStation.distFromLineStart[i] - distPassed) / (0.2777 * avrgBusSpeed)).toInt();// m/km/h
        eta.hours = newETAsecs ~/ 3600;
        newETAsecs %= 3600;
        eta.mins = newETAsecs ~/ 60;
        if(eta.hours != 0 || eta.mins > 30)
          eta.sex = 0;
        else
          newETAsecs %= 60;
          eta.sex = newETAsecs;

        if(bus.eTA.hours >= 1){                                                 // do not update far away buses
          bus.noUpdateForTicks = 5*60*2;  // 5 mins
        }else if(bus.eTA.mins >= 15){
          bus.noUpdateForTicks = 60*2;  // 1 min
        }/*else if(bus.eTA.inSex() + bus.expErMarg.inSex() < 0){  // bus is arriving
          bus.eTA = Time(0,0,-2);
          bus.noUpdateForTicks = bus.expErMarg.inSex()*2;  // 1 min
        }
        else{
          bus.eTA = Time(0,0,-1);
          bus.noUpdateForTicks = -1;
        }*/
        bus.setETA(eta);
      }
    }
  }
}

void setBusETA(distPassed, distFromStart, bus){
  Time eta = new Time(0,0,0);

  if(distPassed > distFromStart){
    print('removed bus');
    //buslist.remove(bus);
    return;
  }

  eta.mins = (distFromStart - distPassed) / avrgBusSpeed;// m/km/h
  bus.setETA(eta);
  print('bus:' + bus.toString() + 'eta: ' + eta.toString());
  return;
}

double getEstDistPassed(Time startTime){ // basic estimation of pos for const speed

  DateTime now = DateTime.now();
  DateTime startDateTime = new DateTime(now.year,now.month,now.day,startTime.hours,startTime.mins, startTime.sex);
  int elapsedTime = now.difference(startDateTime).inSeconds;
  double distance = (elapsedTime)* 0.2777 * avrgBusSpeed;  //1000/3600
 // print('Est dist: ' + distance.round().toString() + ' m');
  return distance;
}

void addSelectedBuses(Station station, String line){
  Bus newBus = new Bus.empty();

  for(var bbusline in nsBusLines){
    if(bbusline.name == line){
      newBus.lineColor = bbusline.color;
      newBus.color = bbusline.color.withAlpha(200);
      newBus.busLine = bbusline.name;
      newBus.busPos = bbusline.points[0];
      DateTime now = DateTime.now();
      //print(now.hour.toString() + ':' + now.minute.toString());
      newBus.startTime = Time(now.hour, now.minute, 0);
      buslist.add(newBus);
    }
  }
}
List<Marker> getBusMarkers(){
    List<Marker> busMarkers = [];

    for(var bus in buslist) {
      /*if(!bus.displayedOnMap){
        continue;
      }*/
      busMarkers.add(new Marker(
          width: 10.0,
          height: 10.0,
          point: bus.busPos,
          builder: (ctx) =>
          new Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: bus.color,
            ),
          )));
    }
    if(dbgMarkers.isNotEmpty){
      for(var mark in dbgMarkers){
        print('oh hi mark');
        busMarkers.add(new Marker(
            width: 15.0,
            height: 15.0,
            point: mark,
            builder: (ctx) =>
            new Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            )));
      }
    }

  return busMarkers;
}