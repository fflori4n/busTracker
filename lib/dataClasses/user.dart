
import 'package:latlong/latlong.dart';

class User{
  bool locationEnabled = false;
  LatLng position = LatLng(-1,-1);
  double heading;  // not used
  double posAcc;
  DateTime posUpdated;
}

// TODO: store preferences and favourites in cookie