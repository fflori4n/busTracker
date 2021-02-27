import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/loadModules/busLocator.dart';

import 'BusLine.dart';
import 'Time.dart';

final LatLng initMapCenter = new LatLng(0,0);

class Bus{
  //LatLng busPos = initMapCenter;
  Position busPos;
  Color color = Colors.white;
  Color lineColor = Colors.transparent;
  Time startTime = new Time(-1,-1,0);
  Time eTA = new Time(-1,-1,-1);
  Time expErMarg = new Time(0,0,0);                                             // expected margin of + error
  //String busLine = '';
  BusLine busLine;
  String nickName = '';
  String etcInfo = '';
  String lineDescr = '';

  int stationNumber = 0;
  int noPosUpdateTicks = 0;
  int noEtaUpdateTicks = 0;
  int twins = 0;

  bool displayedOnMap = false;
  bool displayedOnSchedule = true;
  bool isRampAccesible = false;
  bool isHighLighted = false;
  bool reported = false;


  Bus(LatLng busPos, Color color, Time startTime,BusLine busLine){
    this.busPos.busPoint = busPos;
    this.color = color;
    this.startTime = startTime;
    this.busLine = busLine;
  }
  Bus.empty();
  void setETA(Time eta){
    this.eTA = eta;
  }
  String printBasic(){
    return busLine.name.toString() + ' ' + startTime.hours.toString() + ':' + startTime.mins.toString() + ' ' + nickName;
  }
  void dbgPrint(){
    print(busLine.toString());
  }

  bool isIn(List<Bus>busList){
    for(var bus in busList){
      if(bus.startTime.inSex() == this.startTime.inSex() && bus.busLine.name == this.busLine.name && bus.stationNumber == this.stationNumber){
        return true;
      }
    }
    return false;
  }
  int findInBuslist(){
    for(int i=0; i < buslist.length; i++){
      /*if(buslist[i].busLine != this.busLine){
        continue;
      }
      if(buslist[i].startTime != this.startTime){
        continue;
      }
      return i;*/
      if(buslist[i].busLine == this.busLine && buslist[i].startTime != this.startTime){
        return i;
      }
    }
  }
}

class Position{
  LatLng busPoint = initMapCenter;
  double heading = -1;

  Position(LatLng pos, double hdg){
    busPoint = pos;
    heading = hdg;
  }
}