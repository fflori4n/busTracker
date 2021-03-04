
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/user.dart';
import 'package:mapTest/loadModules/loadStations.dart';

void postBusFeedBack(bool isOK, Bus bus,User user){
  print('feedBack: sent these thing to server');
  print('busline   \t' + bus.busLine.name.toString());
  print('bus ETA   \t' + bus.eTA.inSex().toString());
  print('bus ExpEr \t' + bus.expErMarg.inSex().toString());
  print('startTime \t' + bus.startTime.inSex().toString());
  print('station   \t' + selectedStations[bus.stationNumber].name);
  print('stationPOS\t' + selectedStations[bus.stationNumber].pos.toString());
  print('isOK      \t' + isOK.toString());
  print('userPos   \t' + user.position.toString());
  print('bus       \t' + bus.nickName);
}