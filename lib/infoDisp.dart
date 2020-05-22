import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/infoBoardItem/infoItem.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/UIColors.dart';

import 'loadModules/stations.dart';
import 'navbar/navBar.dart';

class buletin extends StatefulWidget {
  buletinState createState() => buletinState();
}

class buletinState extends State<buletin> {

  @override
  void initState(){
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
                color: gray,
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(4.0),
                  bottomRight: const Radius.circular(4.0),
                )
          ),
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
          padding: EdgeInsets.only(left: 0.0, top: 0.0),
          height: screenHeight/1.5,
          width:  (screenWidth/4.5) + 10,
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                color: baseBlack,
                ),
                padding: EdgeInsets.all(6.0),
                width:  (screenWidth/4.5) + 10,
                height: 45,
                child: getStationHeadline(),
              ),
              Container(
                decoration: new BoxDecoration(
                  color: baseWhite.withOpacity(0.8),
                ),
                width:  (screenWidth/4.5) + 10,
                height: 6,
                margin: EdgeInsets.only(bottom: 5.0),
              ),
              Row(
                children: <Widget>[
                  Expanded(child: SizedBox(width: 10,)),
                  Text('Number', style: legendText),
                  Expanded(child: SizedBox()),
                  Text('Departure time', style: legendText),
                  Expanded(child: SizedBox()),
                  Text('Arrives in', style: legendText),
                  Expanded(child: SizedBox()),
                ],
              ),
              Column(
                  children:dispInfo(context)
              )
            ],
          )
    )],
    );
  }
}