import 'dart:ui';

import 'package:latlong/latlong.dart';

class BusLine{
  String name;
  Color color;
  List<LatLng> points;

  void addPoint(LatLng point){
    this.points.add(point);
  }
}