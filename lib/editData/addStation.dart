import 'dart:io';
import 'package:faker/faker.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/stations.dart';


void addStation(LatLng newClick) async {
  var faker = new Faker();


  Station newStation = new Station(newClick);
  newStation.name =  faker.person.firstName();
  newStation.shade = 1;
  stationList.add(newStation);
  String newStationString = newClick.latitude.toString() + ',' + newClick.longitude.toString() + ',' + newStation.name + ' - addname,0,none,00,00,00\n';
  print(newStationString);
  // Write the file
 /* final File file =  File('assets/userStations.txt');
  file.writeAsString(newStationString,mode: FileMode.append);*/
  return;
}
