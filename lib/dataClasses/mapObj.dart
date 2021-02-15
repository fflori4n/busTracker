
import 'package:latlong/latlong.dart';

class MapObj {
  LatLng pos;
  bool selected = false;

  MapObj.empty();

  MapObj(LatLng pos){
    this.pos = pos;
  }
}