import 'dart:ui';

import 'package:mapTest/mapRelated/map.dart';

import '../main.dart';
import 'Station.dart';

class MapCanvas{
  static bool isPointVisible(){
  }

  static Offset getOverlayOffset(Station station, Size size){
    double y = size.height * (station.pos.latitude - mapController.bounds.northWest.latitude)/(mapController.bounds.southEast.latitude - mapController.bounds.northWest.latitude);
    if(y < 0 || y> size.height){
      return Offset(-1,0);
    }
    double x = size.width * (station.pos.longitude - mapController.bounds.northWest.longitude)/(mapController.bounds.southEast.longitude - mapController.bounds.northWest.longitude);
    if(x < 0 || x> size.width){
      return Offset(-1,0);
    }
    return Offset(x,y);
  }

}