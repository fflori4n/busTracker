import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';

import '../main.dart';
import 'loadStations.dart';

const bool verbose = false;

List<BusLine> nsBusLines = [];
List<BusLine> inactiveLines = [];

Future loadLinesFromJson(List<Station> selectedStation, final String loadCityStr) async{
  user.progStatusString = 'Loading bus lines.';
  print('loading bus lines');
  try {
    String rawBLineData = await rootBundle.loadString("assets/busLines.json");
    var stationObjsJson = jsonDecode(rawBLineData)[loadCityStr] as List;

    for(Station selectedStation in selectedStations){
      selectedStation.lines.clear();

      for(var objJson in stationObjsJson) {
        //print(objJson);
        try{
          final String busLineName = objJson['name'] as String;
          if(!(selectedStation.servedLines.contains(busLineName))){
            if(verbose){print('skipping' + busLineName);}  //DBG
            continue;
          }

          BusLine newBusLine = BusLine.fromJson(objJson);

          nsBusLines.add(newBusLine);
          selectedStation.lines.add(newBusLine);
        }
        catch(e){
          print(e);
          continue;
        }
      }
    }

   /* for (var busline in nsBusLines){
      print(busline.name + ' ' + busline.description);
    }*/

    user.progStatusString = '';
    return;
  }
  catch(e) {
    print('[  Er  ] laoding bus lines: ' + e);
  }
}

Color getLineColor(BusLine newBusline){
  String digest = sha1.convert(utf8.encode(newBusline.name.replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';}))).toString().replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
  String digest2 = sha1.convert(utf8.encode(newBusline.name)).toString().replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
  var rand = new Random(int.parse(digest));
  var rand2 = new Random(int.parse(digest2));
  // #458BFA
  double hue = 303; //new Random(int.parse(digest));
  double hueVariation = 25 * rand2.nextInt(5).toDouble();
  double satVariation = 0.1 * rand2.nextInt(5).toDouble() - 0.5;
  double sat = 110;
  double light = 0.5; // const
  //r = min + rnd.nextInt(max - min);
  sat = (sat -50 + rand.nextInt(70+50) + satVariation)/255;
  hue = 303 - 108 + rand2.nextInt(300).toDouble();//rand2.nextInt(216).toDouble();
  hue = hue % 360;//(hue + hueVariation) % 360;

  if(verbose){print(hue.toString() + sat.toString() + light.toString());}
  HSLColor newColor = new HSLColor.fromAHSL(1, hue, sat, light);
  return newColor.toColor();
}

List<Polyline> getBusLines(){
  List<Polyline> dispPolyLines = [];

  for(int i=0; i < nsBusLines.length; i++){
    dispPolyLines.add(new Polyline(
      points: nsBusLines[i].points,
      strokeWidth: 10,
      color: nsBusLines[i].color.withOpacity(0.2)
    ));
  }
  return dispPolyLines;
}

void removeUnusedBusLines(){                                                    // TODO: test this, very sus
  for(BusLine busLine in nsBusLines){
    bool containsFlg = false;
    for(Station station in selectedStations){
      if(station.doesServedLinesContain(busLine.name)){
        containsFlg = true;
        break;
      }
    }
    if(! containsFlg){
      nsBusLines.remove(busLine);
    }
  }
}