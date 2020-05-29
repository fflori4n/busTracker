import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/BusLine.dart';

List<BusLine> nsBusLines = [];

void loadLinesFromFile() async{
  try {
    print('bus line load');
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

          //print(header[0]);
          //print('('+header[1]+','+header[2]+','+header[3]+')');
          BusLine newBusline = new BusLine();
          newBusline.name = header[0];
          newBusline.color = Color.fromRGBO(int.parse(header[1]),int.parse(header[2]),int.parse(header[3]), 0.9);

          if(points.length >= 2){
            for(int j=0; j<(points.length-1);j+=2){
              //print('<' + points[j].trim() + '><' + points[j+1].trim() +'>\n');
              LatLng point = new LatLng(double.parse(points[j]), double.parse(points[j+1]));
              pointsFromFile.add(point);
              //print('added point:' + point.toString());
            }
            newBusline.points = pointsFromFile;
            nsBusLines.add(newBusline);
          }
        }
        catch(e){
          print('[  Er  ] loadin Block ' + i.toString() + ' in file:' + e);
        }
      }
    }
    print('busline EOF');
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