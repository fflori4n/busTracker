

import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/loadModules/stations.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/UIColors.dart';

Widget drawInfoItem(Bus bus, Station station){
  String lineNum = bus.busLine.padLeft(5, ' ');
  Color lineColor = bus.lineColor;
  bool displayMsg = false;
  String messege = '';
  if(bus.eTA.equals(0, 0, -1)){
    messege = ' LEFT '.padLeft(8,' ');
    displayMsg = true;
  }
  String ETAhours = bus.eTA.hours.toString().toString().padLeft(2, '0');
  String ETAmins = bus.eTA.mins.toString().toString().padLeft(2, '0');
  String ETAsex = bus.eTA.sex.toString().toString().padLeft(2, '0');
  String startHours = bus.startTime.hours.toString().padLeft(2, '0');
  String startMins = bus.startTime.mins.toString().padLeft(2, '0');
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
          height: 30,
          width: (screenWidth/4.5),
          //padding: EdgeInsets.all(5.0),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(250, 250, 250, 0.1),
              borderRadius: new BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Row(
            children: <Widget>[
              Text(
                lineNum,
                style: listText,
              ),
              Expanded(child: SizedBox()),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                    color: displayMsg ? Colors.transparent : lineColor,
                    borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                    border: Border.all(color: lineColor.withOpacity(0.5),width: 2.0),
                ),
              ),
              Expanded(child: SizedBox()),
              Text(
                startHours + ':' + startMins,
                style: listText,
              ),
              Expanded(child: SizedBox()),
              Text(
                  displayMsg ? messege : ETAhours + ':' + ETAmins + ':' + ETAsex,
                  style: listText
              ),
              Expanded(child: SizedBox()),
              Column(
                children: <Widget>[
                  Text('+ 5:22'),
                  Text('- 2:00'),
                ],
              ),
            ],
          ))],
  );
}

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
  if(bus.eTA.equals(0, 0, -1)){
    msgInsteadOfETA = 'Left.';
  }

  String ETAhours = bus.eTA.hours.toString().padLeft(2, '0');
  String ETAmins = bus.eTA.mins.toString().padLeft(2, '0');
  String ETAsex = bus.eTA.sex.toString().padLeft(2, '0');

  String nickName = bus.nickName;
  String erExp = '+' + bus.expErMarg.mins.toString().padLeft(2, '0') + ':' + bus.expErMarg.sex.toString().padLeft(2, '0');

  return Container(
    margin: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 6.0, right: 6.0),
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
            Text(lineName, style: infoBrdLarge,),
          ],
        ),
        Text( (startHours + ':' + startMins).padRight(7,' '), style: infoBrdLarge,),
        Expanded(child: SizedBox()),
        msgInsteadOfETA.isEmpty ? Text( (ETAhours + ':' + ETAmins + ':' + ETAsex).padRight(10,' '), style: infoBrdLarge,) : Text(msgInsteadOfETA.padRight(10,' '), style: infoBrdLarge,),
        Column(
          children: <Widget>[
            Text(erExp.padLeft(15,' '), style: infoBrdSmall),
            Text(nickName, style: infoBrdSmall, textAlign: TextAlign.right,),
          ],
        )
      ],
    ),
  );
}