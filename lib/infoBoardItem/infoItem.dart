

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/loadModules/stations.dart';
import 'package:mapTest/UIColors.dart';

List<Widget> dispInfo(context){
  List<Widget> displayedBuses = new List();
  for(var bus in buslist) {
    //displayedBuses.add(drawInfoItem(bus,activeStation));
    displayedBuses.add(drawBuletinitem(context,bus,activeStation));
  }
  return displayedBuses;
}

Widget drawBuletinitem(BuildContext context, Bus bus, Station station){

  String lineName = bus.busLine.padRight(5, ' ');
  Color lineColor = bus.lineColor;

  String startHours = bus.startTime.hours.toString().padLeft(2, '0');
  String startMins = bus.startTime.mins.toString().padLeft(2, '0');

  String msgInsteadOfETA = '';
  if(bus.eTA.equals(0, 0, -2)){
    msgInsteadOfETA = 'ARRIVING';
  }
  if(bus.eTA.equals(0, 0, -1)){
    msgInsteadOfETA = 'LEFT';
  }

  String ETAhours = bus.eTA.hours.toString().padLeft(2, '0');
  String ETAmins = bus.eTA.mins.toString().padLeft(2, '0');
  String ETAsex;
  if(bus.eTA.mins > 10 || bus.eTA.hours != 0){
    ETAsex = "00".padLeft(2, '0');
  } else{
    ETAsex = bus.eTA.sex.toString().toString().padLeft(2, '0');
  }

  String nickName = bus.nickName;
  String erExp = '+' + bus.expErMarg.mins.toString().padLeft(2, '0') + ':' + bus.expErMarg.sex.toString().padLeft(2, '0');

  return Container(
    margin: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
    //width: (screenWidth/4.5),                                                   // global
    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white70, width: 2.0),
      borderRadius: new BorderRadius.all(Radius.circular(2.0)),
    ),
    child: Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Text(lineName, style: infoBrdYellow,),
          ],
        ),
        Text( (startHours + ':' + startMins).padRight(7,' '), style: infoBrdLarge,),
        Expanded(child: SizedBox()),
        msgInsteadOfETA.isEmpty ? Text( (ETAhours + ':' + ETAmins + ':' + ETAsex).padRight(10,' '), style: infoBrdYellow,) : Text(msgInsteadOfETA.padRight(10,' '), style: infoBrdSmall,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(erExp.padLeft(15,' '), style: infoBrdSmall,),
            Text(nickName, style: infoBrdSmall,),
          ],
        ),
        Column(
          children: [
            Container(
              decoration: new BoxDecoration(
                color: bus.displayedOnMap ? baseWhite : Colors.transparent,
                border: Border.all(color: baseWhite, width: 1.0),
                borderRadius: new BorderRadius.all(Radius.circular(1.0)),
              ),
              margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
              width: infoBrdSmall.fontSize,
              height: infoBrdSmall.fontSize,
            ),
            Container(
              decoration: new BoxDecoration(
                color: bus.isRampAccesible ? baseYellow : Colors.transparent,
                border: Border.all(color: baseYellow, width: 1.0),
                borderRadius: new BorderRadius.all(Radius.circular(1.0)),
              ),
              margin: EdgeInsets.only(top: 1.5, bottom: 0, left: 6.0, right: 3.0),
              width: infoBrdSmall.fontSize,
              height: infoBrdSmall.fontSize,
            ),
          ],
        ),
      ],
    ),
  );
}
