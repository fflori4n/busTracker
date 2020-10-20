
import 'package:latlong/latlong.dart';

class User{
  bool locationEnabled = true;
  LatLng position = LatLng(-1,-1);
  int heading;  // not used
  DateTime posUpdated;
}

// TODO: store preferences and favourites in cookie