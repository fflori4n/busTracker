import 'dart:js';
import 'package:latlong/latlong.dart';
import 'package:mapTest/geometryFuncts.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/mapRelated/map.dart';

import 'location.dart';

success(pos) {
  try {
    print('lat, lon: ' + pos.coords.latitude.toString() + ',' + pos.coords.longitude.toString());
    print('accuracy:' + pos.coords.accuracy.toString());
    print('altitude:' + pos.coords.altitude.toString());
    print('altitudeAccuracy:' + pos.coords.altitudeAccuracy.toString());
    print('heading:' + pos.coords.heading.toString());
    print('speed:' + pos.coords.speed.toString());

  } catch (ex) {
    print("Exception thrown : " + ex.toString());
  }
  user.position = LatLng(pos.coords.latitude,pos.coords.longitude);
  user.posAcc = pos.coords.accuracy;
  user.posUpdated = DateTime.now();

  if(normLoc(mapController.center, LatLng(pos.coords.latitude,pos.coords.longitude)) < 10000){
    mapController.move(LatLng(pos.coords.latitude,pos.coords.longitude), mapController.zoom); // DBG not sure if useful
  }
  else{
    print('user position out of bounds - not moving map [  Wr  ]');
  }
}
getCurrentLocation() {
    getCurrentPosition(allowInterop((pos) => success(pos)));
}

void updatePos() async{ // call this only on user.locationEnabled rising edge // may leak !!!!
  while(user.locationEnabled){
    getCurrentLocation();
    await Future.delayed(Duration(seconds: 60));
    //print('location updated [  OK  ]');
    /*int elapsedTime = DateTime.now().difference(user.posUpdated).inSeconds;
    print('location updated: ' + elapsedTime.toString());

    if(elapsedTime > 60){
      getCurrentLocation();
      print('location updated [  OK  ]');
    }*/
  }
}