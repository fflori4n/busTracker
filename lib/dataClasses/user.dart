
import 'package:latlong/latlong.dart';

class User{
  String progStatusString = '';
  DateTime posUpdated;
  LatLng position = LatLng(-1,-1);
  double heading;  // not used
  double posAcc;

  bool locationEnabled = false;
  bool cookiesEnabled = false;
  //bool filtTabOpen = false;
  //bool locTabOpen = false;

  bool showBusMarkers = true;
  bool showBusETAonMap = true;
  bool showBusLinesMap = true;

  int tabOpen = 0;

  String toString(){
    return
      'LOC' + locationEnabled.toString() + '\n' +
      'COK' + cookiesEnabled.toString() + '\n';
      //'FILT' + filtTabOpen.toString() + '\n' +
     // 'LOCT' + locTabOpen.toString() + '\n';
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
      //filtTabOpen = extractBoolVal(lines[2]);
      //locTabOpen = extractBoolVal(lines[3]);
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
}

// TODO: store preferences and favourites in cookie