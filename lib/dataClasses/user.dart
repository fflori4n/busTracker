
import 'package:latlong/latlong.dart';

import 'FavStation.dart';
import 'Station.dart';

class User{
  String progStatusString = '';
  DateTime posUpdated;
  LatLng position = LatLng(-1,-1);
  double heading;  // not used
  double posAcc;

  bool locationEnabled = false;
  bool cookiesEnabled = false;

  bool showBusMarkers = true;
  bool showBusETAonMap = true;
  bool showBusLinesMap = true;

  int tabOpen = 0;
  
  List<FavStation> favourites =[];

  String toString(){
    return
      'LOC' + locationEnabled.toString() + '\n' +
      'COK' + cookiesEnabled.toString() + '\n';
  }

  void loadFromString(String rawData){
    if(rawData == null){
      print('[  WR  ] no cookie: user');
      return;
    }
    List<String> lines = rawData.split('\n');
    try{
      print(lines[0]);
      locationEnabled = extractBoolVal(lines[0]);
      cookiesEnabled = extractBoolVal(lines[1]);
    }
    catch(e){
      print('[  ER  ] loading user from cookie: ' + e.toString());
    }
    for( var line in lines){
      print(line);
    }
  }

  bool extractBoolVal(String str){
    if(str.contains('true')){
      return true;
    }
    else if(str.contains('false')){
      return false;
    }
    print('ER extractBoolVal' + str);
    return false;
  }

  void addFavourite(String nickName, List<Station> stations){
    if(stations.length <= 0){
      print('no selected stations ');
      return;
    }
    this.favourites.add(FavStation(nickName, stations));
    print('added ' + nickName);
  }

  void dbgPrintFavourites() {
    for (var favourite in this.favourites) {
      print(favourite.nickName);
    }
  }
}

// TODO: store preferences and favourites in cookie