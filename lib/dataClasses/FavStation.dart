import 'dart:convert';

import 'package:mapTest/loadModules/loadStations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Station.dart';

class FavStation{
  String stationStr = '';
  String nickName = '';
  Station station;
  double priority = 1;

  FavStation.empty();
  FavStation(this.station, this.nickName, this.stationStr, this.priority);

  /// stationStr,nickName,priority,
  factory FavStation.fromString(String stationStr, String nickname, String priority){
    FavStation newFavStation = FavStation.empty();

    newFavStation.nickName = nickname;
    newFavStation.stationStr = stationStr;
    newFavStation.station = stationList.firstWhere((station) => station.name == newFavStation.stationStr);
    try{
      newFavStation.priority = double.parse(priority);
    }
    catch(E){
      newFavStation.priority = 1;
    }
    return newFavStation;
  }
  String toString(){
    return (this.stationStr + "," + this.nickName + "," + this.priority.toString() + ",");
  }

}