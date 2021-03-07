import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/loadModules/busLines.dart';

class BusLine{
  String name;
  String description = '';
  Color color = Colors.lightBlue;
  List<LatLng> points = [];

  BusLine();
  void addPoint(LatLng point){
    this.points.add(point);
  }

  factory BusLine.fromJson(dynamic json){
    try{
      BusLine newLine = BusLine();
      newLine.name = json['name'] as String;
      newLine.description = json['descr'] as String;
      newLine.color = getLineColor(newLine.name);

      List pathPoints = json['points'] as List;
      for(String coords in pathPoints){
        List strCoords = coords.split(',');
        newLine.points.add(new LatLng(double.parse(strCoords[1]), double.parse(strCoords[0])));
      }

      return newLine;
    }
    catch(e){
      print(e);
      throw "[  Er  ] laoding station w uid:" + json['uid'];
    }
    return new BusLine();
  }
}
// *******************
bool nsBusLinesContainsName(String searchName){
  for(var busLine in nsBusLines){
    if(busLine.name == searchName){
      return true;
    }
  }
  return false;
}