import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/loadModules/busLocator.dart';

const bool verbose = true;

List<BusLine> nsBusLines = [];
List<BusLine> inactiveLines = [];

Future loadLinesFromFile(List<String> loadThis, bool loadInactive) async{
  buslist.clear();
  for(var busLine in nsBusLines){           // clear buslines that aren't active
    if(!(loadThis.contains(busLine.name))){
      nsBusLines.remove(busLine);
    }
  }
  try {
    if(verbose){print('---  Loading bus lines from file  ---');}  //DBG
    String rawFileContent = await rootBundle.loadString('assets/busLinesNS.txt');
    List<String> lines = rawFileContent.split('<>');
    for(int i=0; i < lines.length; i++){
      lines[i].trim();
      if(!(lines[i].isEmpty || lines[i][0] == '#')){
        try{
          List<String> data = lines[i].split('<.>');
          List<String> header = data[0].split(',');
          List<String> points = data[1].trim().split(',');
          List<LatLng> pointsFromFile =[];

          BusLine newBusline = new BusLine();
          newBusline.name = header[0];

          if(nsBusLinesContainsName(newBusline.name) || (loadThis.isNotEmpty && !(loadThis.contains(newBusline.name)))){
            if(verbose){print('skipping' + newBusline.name);}  //DBG
            continue;
          }

          if(verbose){print('loading: ' + newBusline.name);  //DBG
                      print('Header: [name][R][G][B][Descr.]' + header.toString() );}

          newBusline.color = Color.fromRGBO(int.parse(header[1]),int.parse(header[2]),int.parse(header[3]), 0.9);
          try{
            newBusline.description = header[4].toString();
          }
          catch(r){}

          if(points.length >= 2){
            for(int j=0; j<(points.length-1);j+=2){
              LatLng point = new LatLng(double.parse(points[j]), double.parse(points[j+1]));
              pointsFromFile.add(point);
            }
            newBusline.points = pointsFromFile;
            if(loadInactive){
              inactiveLines.add(newBusline);
            }
            else{
              nsBusLines.add(newBusline);
            }
          }
        }
        catch(e){
          print('[  Er  ] loadin Block ' + i.toString() + ' in file:' + e);
        }
      }
    }
    if(verbose){print('---  Loading completed  ---');}  //DBG
    return;
    }
  catch(e) {
    print('[  Er  ] laoding buslines: ' + e);
  }
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