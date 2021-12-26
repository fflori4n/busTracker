import 'dart:convert';

import 'package:mapTest/dataClasses/FavStation.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<FavStation> favouriteStations = [];


Future<void> saveFavouritesToLocal() async {
  print("saving favstation to local");
  if(favouriteStations.isEmpty){  /// nothing to save, no favourites
    return;
  }
  String favStationsStr = "";
  for(var favstation in favouriteStations){
    favStationsStr += favstation.toString();
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fav_stat', favStationsStr);
}
Future<void> loadFavouritesFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String raw = prefs.getString('fav_stat');
  List favStatElements = raw.split(",");                                          /// TODO: ',' in name or nickname can break it FIX THIS!!
  for(int i=0; i<favStatElements.length; i+=3){
    try{
      favouriteStations.add(FavStation.fromString(favStatElements[i], favStatElements[i+1], favStatElements[i+2]));
    }
    catch(E){
      print('ERROR loading favourite');
    }
  }
}