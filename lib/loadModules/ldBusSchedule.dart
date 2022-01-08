import 'package:flutter/services.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/busLocator.dart';

import '../main.dart';
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
  String rawFileContent;
  String rawDayStr;

  try{
    rawFileContent= await rootBundle.loadString('schedules/' + user.cityString + '/' + bbusline.name + '.txt');
  }
  catch(e){
    print('[ ER ] LD SCH - No permission or missing file: ' + bbusline.name + '.txt in:' + user.cityString);
    return; // TODO some signaling would be nice...
  }
  if(rawFileContent.isEmpty){
    print('[ ER ] LD SCH - file is empty: ' + bbusline.name + '.txt in:' + user.cityString);
    return;
  }
  List<String> dayBlocks = rawFileContent.split('>');

  var unixDate = new DateTime(date.year, date.month, date.day).millisecondsSinceEpoch~/1000;
  unixDate -= (24*60*60);
  for( int i=0; i< 3; i++){
    DateTime loadDay = new DateTime.fromMillisecondsSinceEpoch(unixDate * 1000);

    if(loadDay.weekday == DateTime.sunday){                                          /// dayblocks 3 sunday, dayblocks 2 saturday, dayblocks 1 weekday
      rawDayStr = dayBlocks[3];
    }else if(loadDay.weekday == DateTime.saturday){
      rawDayStr = dayBlocks[2];
    }else{
      rawDayStr = dayBlocks[1];
    }

    //print(" loading " + loadDay.weekday.toString() + " for " + bbusline.name);
    loadBusDay(rawDayStr, bbusline, unixDate, statNumber, numOfTwins);
    unixDate += (24*60*60);
  }
  return;
}

Future<void> loadBusDay(String rawDayString, BusLine bbusline, var unixStartDT, [int statNumber = 0 , int numOfTwins = 0]) async {
  List<String> lines = rawDayString.trim().split('\n');
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
        newBus.unixStartDT = unixStartDT + (newBus.startTime.hours * 60 * 60) + (newBus.startTime.mins * 60);
        var nowTime = (DateTime.now().millisecondsSinceEpoch~/1000);
        /// >0 past bus
        /// <0 future bus
        if((newBus.unixStartDT >= (nowTime - (60*60*2))) && (newBus.unixStartDT <= (nowTime + (60*60*8)))){
         // print(newBus.unixStartDT  + " " + (nowTime));

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
        else{
          continue;
        }
      }catch(e){
        print('[ ER ] LD SCH - creating new bus:' + bbusline.name + ' '+ line.toString());
        print('[ ER ] LD SCH - $e');
      }
    }
  }
}

Future<String> loadScheduleAsText(String lineName) async{
  String rawFileContent;
  String rawDayStr;
  DateTime date = DateTime.now();
  try{
    rawFileContent= await rootBundle.loadString('schedules/' + user.cityString + '/' + lineName + '.txt');
  }
  catch(e){
    print('[ ER ] LD SCH TX - opening file: ' + lineName + '.txt');
    return ''; // TODO some signaling would be nice...
  }
  if(rawFileContent.isEmpty){
    print('[ ER ] LD SCH TX - file is empty: ' + lineName + '.txt');
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