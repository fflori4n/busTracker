import 'dart:js';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/main.dart';

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
  mapController.move(LatLng(pos.coords.latitude,pos.coords.longitude), mapController.zoom); // DBG not sure if useful

  user.position = LatLng(pos.coords.latitude,pos.coords.longitude);
  user.posAcc = pos.coords.accuracy;
  user.posUpdated = DateTime.now();
}
getCurrentLocation() {
    getCurrentPosition(allowInterop((pos) => success(pos)));
}

void updatePos(){
  int elapsedTime = DateTime.now().difference(user.posUpdated).inSeconds;
  print('location updated: ' + elapsedTime.toString());

  if(elapsedTime > 60){
    getCurrentLocation();
    print('location updated [  OK  ]');
  }
}