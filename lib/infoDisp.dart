import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/infoBoardItem/infoItem.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/UIColors.dart';

import 'infoBoardItem/infoListView.dart';
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
                color: buletinBCG,
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(4.0),
                  bottomRight: const Radius.circular(4.0),
                )
          ),
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
          padding: EdgeInsets.only(left: 0.0, top: 0.0),
          height: 800 * hScaleFactor,
          width: 370 * wScaleFactor,  //350
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                color: buletinHeader,
                ),
                padding: EdgeInsets.all(6.0),
                width: 370 * wScaleFactor,
                //height: 100 * hScaleFactor,
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Station:',
                        style: infoBrdLabel,
                        textAlign: TextAlign.left,
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 3.0, bottom: 6.0,),
                        child: Text(
                          activeStation.getStationName(),
                          style: infoBrdLarge,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        'Lines:',
                        style: infoBrdLabel,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3.0, bottom: 4.0,),
                        child: Text(
                          activeStation.getServedLines().toString(),
                          style: infoBrdSmall,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  color: baseWhite,
                ),
                height: 3,
                margin: EdgeInsets.only(bottom: 5.0),
              ),
              Container(
                child: infoLegend(),
              ),
             /* Row(
                children: <Widget>[
                  Text('Num', style: legendText),
                  Text('Departures at'.padRight(7,' '), style: legendText),
                  Expanded(child: SizedBox()),
                  Text('Arrives in', style: legendText),
                  Expanded(child: SizedBox()),
                ],
              ),*/
              /*Column(
                  children:dispInfo(context),
              ),*/
              Expanded(
                child: ListView(              // use listView Builder, do not render invisible widgets
                  children: dispInfo(context),
                ),
              ),
            ],
          )
    )],
    );
  }
}

Widget infoLegend(){
  return Container(
    margin: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 10.0, right: 10.0),
    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 1.0, bottom: 1.0),
    child: Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Text('Num', style: infoBrdSmall,),
          ],
        ),
        Text( ('Departs at').padRight(7,' '), style: infoBrdSmall,),
        Expanded(child: SizedBox()),
        Text('Arrives in'.padRight(10,' '), style: infoBrdSmall,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Error'.padLeft(15,' '), style: infoBrdSmall,),
            Text('Nick name', style: infoBrdSmall,),
          ],
        ),
        Column(
          children: [
            Container(
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: baseWhite, width: 1.0),
                borderRadius: new BorderRadius.all(Radius.circular(1.0)),
              ),
              margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
              width: infoBrdSmall.fontSize,
              height: infoBrdSmall.fontSize,
            ),
            Container(
              decoration: new BoxDecoration(
                color: Colors.transparent,
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