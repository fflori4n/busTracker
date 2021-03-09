import 'package:flutter/services.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/loadModules/busLocator.dart';

import 'nickNames.dart';


void loadBuses(List<Station> selectedStations){
  List<String> loadedLines = [];

  for(var selectedStation in selectedStations){
    for(var line in selectedStation.lines){
      ldLineSchedule(line,DateTime.now(),selectedStations.indexOf(selectedStation), loadedLines.where((e) => e == line.name).length);
      loadedLines.add(line.name);
    }
  }
}

Future ldLineSchedule(BusLine bbusline, DateTime date, [int statNumber = 0 , int numOfTwins = 0]) async {
  String lineName = bbusline.name;
  String rawFileContent;
  String rawDayStr;

  try{
    rawFileContent= await rootBundle.loadString('NsBusData/' + bbusline.name + '.txt');
  }
  catch(e){
    print('[ ER ] opening file: ' + lineName + '.txt');
    return; // TODO some signaling would be nice...
  }
  if(rawFileContent.isEmpty){
    print('[ ER ] file is empty: ' + lineName + '.txt');
    return;
  }
  List<String> dayBlocks = rawFileContent.split('>');

  if(date.weekday == DateTime.sunday){
    rawDayStr = dayBlocks[3];
  }else if(date.weekday == DateTime.saturday){
    rawDayStr = dayBlocks[2];
  }else{
    rawDayStr = dayBlocks[1];
  }

  List<String> lines = rawDayStr.trim().split('\n');
  for(var line in lines){
    List<String> spaceSep = line.trim().split(' ');
    for(int i =1; i<spaceSep.length ; i++){
      if(spaceSep[i][0] == '#'){
        //print('skip');
        continue;
      }
      Bus newBus = new Bus.empty();
      try{
        if(spaceSep[i].contains('R')){
          newBus.isRampAccesible = true;
        }
        spaceSep[i] = spaceSep[i].replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
        newBus.startTime = Time(int.parse(spaceSep[0]),int.parse(spaceSep[i]),0);
        DateTime now = DateTime.now();
        DateTime startDateTime = new DateTime(now.year,now.month,now.day,newBus.startTime.hours,newBus.startTime.mins, newBus.startTime.sex);

        if(now.difference(startDateTime).inMinutes > 120){
          //print('bus gone!'); // TODO test me and add max load limit
          continue;
        }
        else{
          newBus.displayedOnMap = false;
          newBus.busLine = bbusline;
          newBus.lineColor = bbusline.color;
          newBus.lineDescr = bbusline.description;
          newBus.color = bbusline.color.withAlpha(200);
          newBus.busPos = new Position(bbusline.points[0], -1);

          await loadNickName(newBus);   // test only
          /// *********************

          newBus.stationNumber = statNumber;
          newBus.twins = numOfTwins;

          buslist.add(newBus);

          ///*****************************
          //print(' added to buslist:' + newBus.busLine.name + ' ' + newBus.nickName);
        }
      }catch(e){
        print('[ ER ] creating new bus:' + lineName + ' '+ line.toString());
        print('[ ER ] $e');
      }
    }
  }

  return;
}

Future<String> loadScheduleAsText(String lineName) async{
  String rawFileContent;
  String rawDayStr;
  DateTime date = DateTime.now();
  try{
    rawFileContent= await rootBundle.loadString('NsBusData/' + lineName + '.txt');
  }
  catch(e){
    print('[ ER ] opening file: ' + lineName + '.txt');
    return ''; // TODO some signaling would be nice...
  }
  if(rawFileContent.isEmpty){
    print('[ ER ] file is empty: ' + lineName + '.txt');
    return '';
  }
  List<String> dayBlocks = rawFileContent.split('>');

  if(date.weekday == DateTime.sunday){
    rawDayStr = dayBlocks[3];
  }else if(date.weekday == DateTime.saturday){
    rawDayStr = dayBlocks[2];
  }else{
    rawDayStr = dayBlocks[1];
  }

  return rawDayStr.trim();
}