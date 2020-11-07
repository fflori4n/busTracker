import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/loadModules/stations.dart';

import '../main.dart';

const bool verbose = true;

List<BusLine> nsBusLines = [];
List<BusLine> inactiveLines = [];

Future loadLinesFromFile(List<Station> selectedStation,bool loadInactive) async{  //List<String> loadThis
  user.progStatusString = 'Loading bus lines.';
  buslist.clear();
  nsBusLines.clear();

  for(Station selectedStation in selectedStations){
    selectedStation.lines.clear();
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

            print(selectedStations.toString());
            print(selectedStation.servedLines);
            if(!(selectedStation.servedLines.contains(newBusline.name))){
              if(verbose){print('skipping' + newBusline.name);}  //DBG
              continue;
            }

            if(verbose){print('loading: ' + newBusline.name);  //DBG
            print('Header: [name][R][G][B][Descr.]' + header.toString() );}

            //newBusline.color = Color.fromRGBO(int.parse(header[1]),int.parse(header[2]),int.parse(header[3]), 0.9);
            //newBusline.color = giveMeColor(newBusline.name);
            //print(giveMeColor(newBusline.name));


            // debug*********************
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
            newBusline.color = newColor.toColor();
            //**************************

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
                selectedStation.lines.add(newBusline);
              }
            }
          }
          catch(e){
            print('[  Er  ] loadin Block ' + i.toString() + ' in file:' + e);
          }
        }
      }
    }
    catch(e) {
      print('[  Er  ] laoding buslines: ' + e);
    }
  }
  if(verbose){print('---  Loading completed  ---');}  //DBG
  user.progStatusString = '';
  return;
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