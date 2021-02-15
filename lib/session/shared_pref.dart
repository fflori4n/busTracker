import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/mapRelated/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart'; // rememeber to import shared_preferences: ^0.5.4+8

/// from https://stackoverflow.com/questions/56417667/how-to-save-to-web-local-storage-in-flutter-web
/// slamarseillebg

Future<void> writeCookie() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('user', user.toString());
  await prefs.setString('mapConfig', mapConfig.toString());
  await prefs.setString('activeStations', new Station.empty().outString(selectedStations));
  //await prefs.setString('filters', busFilters.toString());
  print('write succesfull');
}
Future<void> readCookie() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  user.loadFromString(prefs.getString('user'));
  mapConfig.loadFromString(prefs.getString('mapConfig'));
  //new Station.empty().activeStationLoad(prefs.getString('activeStations'));  // TODO: figure out how static works in dart
  //print(prefs.getString('filters'));
  print('read all!');
}