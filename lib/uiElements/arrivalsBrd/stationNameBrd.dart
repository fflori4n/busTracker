import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import '../selectedStationsBrd.dart';


List<Widget> displaySelectedStations(Size constraints) {
  List<Widget> stationDispList = new List();

  if (selectedStations.length <= 0) {
    stationDispList.add(InfoBrdBanner(topText: "izaberi stanicu!", bottomText: "nađi i klikni stanicu polaska ( na kojem si trenutno  ) na mapi", constraints: constraints).show());
  }
  for ( Station station in selectedStations) {
    stationDispList.add(ActStation(station: station, constraints: constraints).show());
  }
  return stationDispList;
}
