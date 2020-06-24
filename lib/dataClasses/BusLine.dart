import 'dart:ui';

import 'package:latlong/latlong.dart';
import 'package:mapTest/loadModules/busLines.dart';

class BusLine{
  String name;
  String description = '';
  Color color;
  List<LatLng> points;

  void addPoint(LatLng point){
    this.points.add(point);
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