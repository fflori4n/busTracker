import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/loadModules/busLocator.dart';

import 'nickNames.dart';

void LdLineSchedule(BusLine bbusline, DateTime Date) async {
  String lineName = bbusline.name;
  String rawFileContent;
  String rawDayStr;

  try{
    rawFileContent= await rootBundle.loadString('NsBusData/' + bbusline.name + '.txt');
  }
  catch(e){
    print('[ ER ] opening file: ' + lineName + '.txt');
    return; // some signaling would be nice...
  }
  if(rawFileContent.isEmpty){
    print('[ ER ] file is empty: ' + lineName + '.txt');
    return;
  }
  List<String> dayBlocks = rawFileContent.split('>');

  if(Date.weekday == DateTime.sunday){
    rawDayStr = dayBlocks[3];
  }else if(Date.weekday == DateTime.saturday){
    rawDayStr = dayBlocks[2];
  }else{
    rawDayStr = dayBlocks[1];
  }
  //print(rawDayStr);

  List<String> lines = rawDayStr.trim().split('\n');
  for(var line in lines){
    List<String> spaceSep = line.trim().split(' ');
    for(int i =1; i<spaceSep.length ; i++){
      if(spaceSep[i][0] == '#'){
        print('skip');
        continue;
      }
      Bus newBus = new Bus.empty();
      try{
        newBus.busLine = bbusline.name;
        newBus.lineColor = bbusline.color;
        newBus.color = bbusline.color.withAlpha(200);
        newBus.busPos = bbusline.points[0];

        if(spaceSep[i].contains('R')){
          newBus.isRampAccesible = true;
        }
        spaceSep[i] = spaceSep[i].replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
        print(spaceSep[0] + ':' + spaceSep[i]);
        newBus.startTime = Time(int.parse(spaceSep[0]),int.parse(spaceSep[i]),0);
        newBus.isDisplayedOnMap = true;
        DateTime now = DateTime.now();
        DateTime startDateTime = new DateTime(now.year,now.month,now.day,newBus.startTime.hours,newBus.startTime.mins, newBus.startTime.sex);
        int elapsedTime = now.difference(startDateTime).inMinutes;
        if(elapsedTime > 120) {
          print('bus gone!');
        }
        else{
          loadNickName(newBus);   // test only
          buslist.add(newBus);
        }
      }catch(e){
        print('[ ER ] creating new bus:' + lineName + ' '+ line.toString());
      }
    }
  }

  return;
}