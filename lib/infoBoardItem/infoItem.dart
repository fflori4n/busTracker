

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/filters.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/loadModules/stations.dart';
import 'package:mapTest/UIColors.dart';

import '../main.dart';

Widget drawBuletinitem(BuildContext context, Bus bus, Station station){

  String lineName = bus.busLine.name.padRight(5, ' ');
  Color lineColor = bus.lineColor;

  String startHours = bus.startTime.hours.toString().padLeft(2, '0');
  String startMins = bus.startTime.mins.toString().padLeft(2, '0');

  String msgInsteadOfETA = '';
  if(bus.eTA.equals(0, 0, -1)){
    msgInsteadOfETA = 'ARRIVING';
  }
  if(bus.eTA.equals(0, 0, -2)){
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

  String nickName = bus.nickName.toUpperCase();
  String erExp = '+' + bus.expErMarg.mins.toString().padLeft(2, '0') + ':' + bus.expErMarg.sex.toString().padLeft(2, '0');

  return new GestureDetector(
    onTap: (){ bus.isHighLighted = !bus.isHighLighted; },
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
                                child: AutoSizeText('⠿', style: TextStyle(color: lineColor, fontSize: 15 * wScaleFactor),),
                              ),
                            ],
                          ),
                          //Text(lineName, style: infoBrdYellow,),)
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
                              decoration: new BoxDecoration(
                                color: bus.displayedOnMap ? baseWhite : Colors.transparent,
                                border: Border.all(color: baseWhite, width: 1.0),
                                borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                              ),
                              margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
                              width: infoBrdSmall.fontSize,
                              height: infoBrdSmall.fontSize,
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                color: bus.isRampAccesible ? baseYellow : Colors.transparent,
                                border: Border.all(color: baseYellow, width: 1.0),
                                borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                              ),
                              margin: EdgeInsets.only(top: 1.5, bottom: 0, left: 6.0, right: 3.0),
                              width: infoBrdSmall.fontSize,
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

  String lineName = 'NAME'.padRight(5, ' ');
  Color lineColor = Colors.white70;

  String startTime = 'DEPARTS AT';
  String ETAtime= 'ARRIVES IN';
  String lineDescr = 'LINE WAYPOINTS - MAIN STATIONS';
  String nickName = 'NICKNAME';
  String erExp = 'EXP.ERROR';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      FilterTab(),
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
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: baseWhite, width: 1.0),
                              borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                            ),
                            margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
                            width: infoBrdSmall.fontSize,
                            height: infoBrdSmall.fontSize,
                          ),
                          Container(
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: baseYellow, width: 1.0),
                              borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                            ),
                            margin: EdgeInsets.only(top: 1.5, bottom: 0, left: 6.0, right: 3.0),
                            width: infoBrdSmall.fontSize,
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

Widget FilterTab(){
  if(!filtTabOpen){
    return Container();
  }
  return Column(
    children: <Widget>[
      Container(
        // margin: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
          padding: EdgeInsets.only(left: 17.0, right: 17.0, top: 6.0, bottom: 4.0),
          color: baseBlack,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('left buses',style: infoBrdSmall,),
                  GestureDetector(
                    onTap: (){
                      busFilters.left = !busFilters.left;
                      applyFilters(busFilters);
                      },
                    child: Container(
                      decoration: new BoxDecoration(
                        color: busFilters.left ? baseYellow : Colors.transparent,
                        border: Border.all(color: baseYellow, width: 1.0),
                        borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      ),
                      margin: EdgeInsets.only(top: 1.5, bottom: 0, left: 6.0, right: 3.0),
                      width: infoBrdSmall.fontSize,
                      height: infoBrdSmall.fontSize,
                    ),
                  )
                ],
              )
            ],
          ),
        /* Row( children: <Widget>[
            Expanded( child:  Text('hello world', style: infoBrdSmall,),)
          ],)
  //hideLeft(Show filters)*/
      ),
      Container(
        decoration: new BoxDecoration(
          color: baseWhite,
        ),
        height: 1,
        //margin: EdgeInsets.only(bottom: 5.0),
      ),
    ],
  );
}
