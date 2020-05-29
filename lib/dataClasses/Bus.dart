import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import 'Time.dart';

final LatLng initMapCenter = new LatLng(0,0);

class Bus{
  LatLng busPos = initMapCenter;
  Color color = Colors.white;
  Color lineColor = Colors.transparent;
  Time startTime = new Time(-1,-1,0);
  Time eTA = new Time(-1,-1,-1);
  Time expErMarg = new Time(0,0,0);                                             // expected margin of + error
  String busLine = '';
  String nickName = '';
  String etcInfo = '';
  int noUpdateForTicks = 0;
  bool displayedOnMap = false;
  bool isRampAccesible = false;


  Bus(LatLng busPos, Color color, Time startTime,String busLine){
    this.busPos = busPos;
    this.color = color;
    this.startTime = startTime;
    this.busLine = busLine;
  }
  Bus.empty(){
  }
  void setETA(Time eta){
    this.eTA = eta;
  }
  String printBasic(){
    return busLine + ' ' + startTime.hours.toString() + ':' + startTime.mins.toString() + ' ' + nickName;
  }
  void dbgPrint(){
    print(busLine.toString());
  }
}