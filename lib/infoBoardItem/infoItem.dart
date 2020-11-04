

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/filters.dart';
import 'package:mapTest/infoBoardItem/indicator.dart';
import 'package:mapTest/infoBoardItem/stationSign.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/loadModules/stations.dart';
import 'package:mapTest/UIColors.dart';

import '../infoDisp.dart';
import '../main.dart';
import 'filterItem.dart';
import 'locMenu.dart';

Widget drawBuletinitem(BuildContext context, Bus bus, Station station){

  if(!bus.displayedOnSchedule) {
    return Container();
  }

  String lineName = bus.busLine.name.padRight(5, ' ');
  Color lineColor = bus.lineColor;

  String startHours = bus.startTime.hours.toString().padLeft(2, '0');
  String startMins = bus.startTime.mins.toString().padLeft(2, '0');

  String msgInsteadOfETA = '';
  if(bus.eTA.equals(-1, -1, -1)){
    msgInsteadOfETA = '...';
  }
  else if(bus.eTA.equals(0, 0, -1)){
    msgInsteadOfETA = lbl_arriving.print();
  }
  else if(bus.eTA.equals(0, 0, -2)){
    msgInsteadOfETA = lbl_left.print();
  }

  String ETAhours = bus.eTA.hours.toString().padLeft(2, '0');
  String ETAmins = bus.eTA.mins.toString().padLeft(2, '0');
  String ETAsex;
  if(bus.eTA.mins > 10 || bus.eTA.hours != 0){
    ETAsex = "00".padLeft(2, '0');
  } else{
    ETAsex = bus.eTA.sex.toString().toString().padLeft(2, '0');
  }

  String nickName = bus.nickName.toUpperCase();
  String erExp = '+' + bus.expErMarg.mins.toString().padLeft(2, '0') + ':' + bus.expErMarg.sex.toString().padLeft(2, '0');

  String stationLet = bus.stationLetter;

  return new GestureDetector(
    onTap: (){
      bus.isHighLighted = !bus.isHighLighted;
      mapController.move(bus.busPos.busPoint, mapConfig.mapZoom);      // TODO: test test test
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
            padding: EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0, bottom: 3.0),
            decoration: BoxDecoration(
              border: bus.isHighLighted ? Border.all(color: baseBlue, width: 1.5) : Border.all(color: Colors.white70, width: 1.5),
              borderRadius: new BorderRadius.all(Radius.circular(2.0)),
            ),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          child:  Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: AutoSizeText(lineName, style: infoBrdYellow,),
                              ),
                              Expanded(
                                flex: 1,
                                  child: Row(
                                    children: <Widget>[
                                      stationLetter(stationLet),
                                      indicator( lineColor.withOpacity(0.4), lineColor, ligthBlack, bus.displayedOnMap ? false : true),
                                    ],
                                  ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText((startHours + ':' + startMins).padRight(7,' '), style: infoBrdLarge,),
                        ),
                        Expanded(
                          child: msgInsteadOfETA.isEmpty ? AutoSizeText( (ETAhours + ':' + ETAmins + ':' + ETAsex).padRight(10,' '), style: infoBrdYellow,) : AutoSizeText(msgInsteadOfETA.padRight(10,' '), style: infoBrdSmall,),
                        ),
                      ],),
                      AutoSizeText(bus.lineDescr, style: busDescrSmall, textAlign: TextAlign.left, textScaleFactor: 0.8,),
                      bus.isHighLighted ? Text('item clicked!',style: busDescrSmall) : Container(),     // DBG
                    ],
                  )//Container(color: baseBlue, child: Text('hello world!'),),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  //margin: EdgeInsets.only(top: 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            AutoSizeText(erExp.padLeft(15,' '), style: infoBrdSmall,),
                            AutoSizeText(nickName.padLeft(15,' '), style: infoBrdSmaller,),
                          ],),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: indicator(baseGray, baseYellow, ligthBlack, !bus.displayedOnMap),
                              margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
                              height: infoBrdSmall.fontSize,
                            ),
                            Container(
                              child: indicator(baseGray, baseWhite, ligthBlack, !bus.isRampAccesible),
                              margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
                              height: infoBrdSmall.fontSize,
                            ),
                          ],),
                      ),
                    ],
                  ),
                ),
              ),

            ],)
        ),
      ],
    ),
  );
}

Widget drawLegend(BuildContext context){

  String lineName = lbl_lineName.print().padRight(5, ' ');
  Color lineColor = Colors.white70;

  String startTime = lbl_departsAt.print();
  String ETAtime= lbl_arrivesIn.print();
  String lineDescr = lbl_lineDescr.print();
  String nickName = lbl_nickName.print();
  String erExp = lbl_expError.print();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      FilterTab(),
      LocationMenu(),
      Container(
         // margin: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
          padding: EdgeInsets.only(left: 17.0, right: 17.0, top: 6.0, bottom: 4.0),
          color: baseBlack,
          child: Row(children: <Widget>[
            Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(lineName, style: infoBrdSmaller,),
                            ),
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(' ', style: TextStyle(color: lineColor, fontSize: 10 * wScaleFactor),),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AutoSizeText(startTime.padRight(7,' '), style: infoBrdSmaller,),
                      ),
                      Expanded(
                        child: AutoSizeText(ETAtime.padRight(10,' '), style: infoBrdSmaller,),
                      ),
                    ],),
                    AutoSizeText(lineDescr, style: busDescrSmall, textAlign: TextAlign.left, textScaleFactor: 0.8,),
                  ],
                )//Container(color: baseBlue, child: Text('hello world!'),),
            ),
            Expanded(
              flex: 3,
              child: Container(
                //margin: EdgeInsets.only(top: 2),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          AutoSizeText(erExp.padLeft(15,' '), style: infoBrdSmaller,),
                          AutoSizeText(nickName.padLeft(15,' '), style: infoBrdSmaller,),
                        ],),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: indicator(baseGray, baseWhite, baseBlack, true),
                            margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
                            height: infoBrdSmall.fontSize,
                          ),
                          Container(
                            child: indicator(baseGray, baseWhite, baseBlack, true),
                            margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
                            height: infoBrdSmall.fontSize,
                          ),
                        ],),
                    ),
                  ],
                ),
              ),
            ),
          ],)
      ),
    ],
  );
}

