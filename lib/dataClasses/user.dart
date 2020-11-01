
import 'package:latlong/latlong.dart';

class User{
  bool locationEnabled = false;
  bool cookiesEnabled = false;
  LatLng position = LatLng(-1,-1);
  double heading;  // not used
  double posAcc;
  DateTime posUpdated;

  String progStatusString = '';
  bool filtTabOpen = false;
  bool locTabOpen = false;

  String toString(){
    return locationEnabled.toString() + '|' + position.toString();
  }
}

// TODO: store preferences and favourites in cookie