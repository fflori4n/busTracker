import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/uiElements/UIColors.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/mapRelated/map.dart';
import 'package:mapTest/uiElements/animatons/fadeInAnim.dart';
import 'package:mapTest/uiElements/arrivalsBrd/stationSign.dart';
import 'package:mapTest/uiElements/feedBackThumbs.dart';

import '../../main.dart';
import 'dart:js' as js;

import 'indicator.dart';



 
Widget infoWidget(BuildContext context, Bus bus, Size constraints) {
  //, //Station station){

  if (!bus.displayedOnSchedule) {
    return Container();
  }

  final TextStyle timeTextStyle = GoogleFonts.robotoCondensed(
      fontSize: autoSizeOneLine(
          stringLength: 9,
          maxWidth: 0.3 * 0.7 * constraints.width * 1.2),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);
  final TextStyle timeTextStyleSmol = GoogleFonts.robotoCondensed(
      fontSize: autoSizeOneLine(
          stringLength: 9,
          maxWidth: 0.3 * 0.7 * constraints.width * 1.2) * 0.8,
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  final TextStyle busDescrTextStyle = GoogleFonts.robotoCondensed(
      fontSize: autoSizeOneLine(
          stringLength: 40,
          maxWidth:  0.7 * constraints.width * 1),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  final TextStyle busSmallTextStyle = GoogleFonts.robotoCondensed(
      fontSize: autoSizeOneLine(
          stringLength: 12,
          maxWidth:  0.19 * constraints.width * 1.1),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);


  String lineName = bus.busLine.name.padRight(5, ' ');
  Color lineColor = bus.lineColor;

  String startHours = bus.startTime.hours.toString().padLeft(2, '0');
  String startMins = bus.startTime.mins.toString().padLeft(2, '0');

  String msgInsteadOfETA = '';
  if (bus.eTA.equals(-1, -1, -1)) {
    msgInsteadOfETA = '...';
  } else if (bus.eTA.equals(0, 0, -1)) {
    msgInsteadOfETA = lbl_arriving.print();
  } else if (bus.eTA.equals(0, 0, -2)) {
    msgInsteadOfETA = lbl_left.print();
  }

  String eTAhours = bus.eTA.hours.toString().padLeft(2, '0');
  String eTAmins = bus.eTA.mins.toString().padLeft(2, '0');
  String eTAsex;
  if (bus.eTA.mins > 10 || bus.eTA.hours != 0) {
    eTAsex = "00".padLeft(2, '0');
  } else {
    eTAsex = bus.eTA.sex.toString().toString().padLeft(2, '0');
  }

  String nickName = bus.nickName.toUpperCase();
  String erExp = '+' +
      bus.expErMarg.mins.toString().padLeft(2, '0') +
      ':' +
      bus.expErMarg.sex.toString().padLeft(2, '0');
  if(!bus.displayedOnMap){
    erExp = '+00:00';
  }

  String stationLet = (bus.stationNumber + 1).toString();

    return FadeIn(
        1.5,
        GestureDetector(
          onTap: () {
            bus.isHighLighted = !bus.isHighLighted;
            mapController.move(
                bus.busPos.busPoint, mapConfig.mapZoom); // TODO: test test test
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0.5, horizontal: constraints.width / 50),
            padding: EdgeInsets.zero,
            width: constraints.width * 0.85,
            decoration: BoxDecoration(
              border: bus.isHighLighted
                  ? Border.all(color: baseBlue, width: 1)
                  : Border.all(color: Colors.white70, width: 1),
              borderRadius: new BorderRadius.all(Radius.circular(2.0)),
            ),
            child: Column(
              children: [
                Container(
                  height: constraints.height,
                  child: Row(
                    children: [
                      Column(                                                         // 2:1 column
                        children: [
                          Container(
                              height: 2 * constraints.height/3,
                              width: 0.7 * constraints.width,
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 0.1 * 0.15 * 0.7 * constraints.width,),
                                    height: 2 * constraints.height/3,
                                    width: 0.15 * 0.7 * constraints.width,
                                    child: Text(lineName, style: timeTextStyle.apply(color: baseYellow), textAlign: TextAlign.start,),

                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 2 * constraints.height/3,
                                    width: 0.08 * 0.7 * constraints.width,
                                    child: stationLetter(timeTextStyle.fontSize * 0.9 ,stationLet),

                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 2 * constraints.height/3,
                                    width: 0.08 * 0.7 * constraints.width,
                                    child: indicator(timeTextStyle.fontSize * 0.9, lineColor.withOpacity(0.4), lineColor, Color.fromRGBO(16, 16, 19, 1), bus.displayedOnMap
                                        ? false
                                        : true),

                                  ),
                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 2 * constraints.height/3,
                                        // color: Colors.orange,
                                        child: Text((startHours + ':' + startMins).padRight(7, ' '), style: timeTextStyle,)

                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    height: 2 * constraints.height/3,
                                    width: 0.3 * 0.7 * constraints.width,
                                    child: msgInsteadOfETA.isEmpty
                                        ? Text(eTAhours + ':' + eTAmins + ':' + eTAsex, style: timeTextStyle.apply(color: baseYellow))
                                        : Text(msgInsteadOfETA,  style: timeTextStyleSmol),
                                  ),

                                ],
                              )

                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 0.1 * 0.15 * 0.7 * constraints.width),
                              width: 0.7 * constraints.width,
                              //height: constraints.height/3,
                              child:  Text( bus.lineDescr.toUpperCase(), style: busDescrTextStyle,),
                            ),
                          )
                        ],
                      ),
                      Row(// 1:1 column
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 0.1 * 0.15 * 0.7 * constraints.width),
                                alignment: Alignment.centerRight,
                                height: constraints.height/2,
                                width: 0.19 * constraints.width,
                                child: Text(erExp.padLeft(15, ' '), style: busSmallTextStyle,),
                              ),
                              Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 0.1 * 0.15 * 0.7 * constraints.width),
                                    alignment: Alignment.centerRight,
                                    height: constraints.height/2,
                                    width: 0.19 * constraints.width,
                                    child: Text(nickName.padLeft(15, ' '), style: busSmallTextStyle,),
                                  )
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: constraints.height/2,
                                width: 0.06 * constraints.width,
                                child: indicator(timeTextStyle.fontSize * 0.9, baseGray, baseYellow, Color.fromRGBO(16, 16, 19, 1), !bus.displayedOnMap),
                              ),
                              Expanded(
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    height: constraints.height/2,
                                    width: 0.06 * constraints.width,
                                    child: indicator(timeTextStyle.fontSize * 0.9, baseGray, baseWhite, Color.fromRGBO(16, 16, 19, 1), !bus.isRampAccesible),
                                  )
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                bus.isHighLighted ? extrainfo(bus, constraints) : Container(), // DBG
              ],
            ),
          )
        )
    );
}

Widget drawLegend(BuildContext context) {
  String lineName = lbl_lineName.print().padRight(5, ' ');
  Color lineColor = Colors.white70;

  String startTime = lbl_departsAt.print();
  String ETAtime = lbl_arrivesIn.print();
  String lineDescr = lbl_lineDescr.print();
  String nickName = lbl_nickName.print();
  String erExp = lbl_expError.print();


  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      //FilterTab(),
      //LocationMenu(),
      Container(
          // margin: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
          padding:
              EdgeInsets.only(left: 17.0, right: 17.0, top: 6.0, bottom: 4.0),
          color: baseBlack,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: AutoSizeText(
                                    lineName,
                                    style: infoBrdSmaller,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: AutoSizeText(
                                    ' ',
                                    style: TextStyle(
                                        color: lineColor,
                                        fontSize: 10 ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              startTime.padRight(7, ' '),
                              style: infoBrdSmaller,
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              ETAtime.padRight(10, ' '),
                              style: infoBrdSmaller,
                            ),
                          ),
                        ],
                      ),
                      AutoSizeText(
                        lineDescr,
                        style: busDescrSmall,
                        textAlign: TextAlign.left,
                        textScaleFactor: 0.8,
                      ),
                    ],
                  ) //Container(color: baseBlue, child: Text('hello world!'),),
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
                            AutoSizeText(
                              erExp.padLeft(15, ' '),
                              style: infoBrdSmaller,
                            ),
                            AutoSizeText(
                              nickName.padLeft(15, ' '),
                              style: infoBrdSmaller,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Center(
                            child: Icon(
                              Icons.near_me,
                              color: Colors.white,
                              size: infoBrdSmall.fontSize,
                              semanticLabel: 'navigation',
                              ),
                                /*indicator(Color.fromRGBO(16, 16, 19, 1),
                                  baseWhite, baseBlack, true),
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 1.5, left: 6.0, right: 3.0),*/

                              ),
                              height: infoBrdSmall.fontSize,
                            ),

                            Container(
                              child: Center(
                                child:Icon(
                                  Icons.accessible_forward,
                                  color: Colors.white,
                                  size: infoBrdSmall.fontSize,
                                  semanticLabel: 'accessibility',
                                ),
                              ),
                              /*indicator(Color.fromRGBO(16, 16, 19, 1),
                                  baseWhite, baseBlack, true),
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 1.5, left: 6.0, right: 3.0),*/
                              height: infoBrdSmall.fontSize,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    ],
  );
}

Widget extrainfo(Bus bus, Size constraints) {
  DateTime now = new DateTime.now();
  Time iStart = (Time(now.hour, now.minute, now.second) + bus.eTA);
  Time iEnd = (Time(now.hour, now.minute, now.second) + bus.eTA + bus.expErMarg);
  String intervStart = iStart.hours.toString().padLeft(2,'0') + ':' + iStart.mins.toString().padLeft(2,'0');
  String intervEnd = iEnd.hours.toString().padLeft(2,'0') + ':' + iEnd.mins.toString().padLeft(2,'0');

  final TextStyle busSmallTextStyle = GoogleFonts.robotoCondensed(
      fontSize: autoSizeOneLine(
          stringLength: 12,
          maxWidth:  0.19 * constraints.width * 1.1),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 0.1 * 0.15 * 0.7 * constraints.width, vertical: 0.05 * 0.15 * 0.7 * constraints.width),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stanica : ' + selectedStations.elementAt(bus.stationNumber).name,
              style: busSmallTextStyle,
              textAlign: TextAlign.left,
            ),
            Text(
              'Očekivani dolazak između ' + intervStart + ' i ' + intervEnd,
              style: busSmallTextStyle,
              textAlign: TextAlign.left,
            ),
            InkWell(
              child: Text(
                'pogledajte mesto na google maps',
                style: busDescrSmallLink,
                textAlign: TextAlign.left,
              ),
              onTap: () {
                js.context.callMethod('open', ['https://www.google.com/maps/search/?api=1&query=' + selectedStations.elementAt(bus.stationNumber).pos.latitude.toString() + ',' + selectedStations.elementAt(bus.stationNumber).pos.longitude.toString() + '&z=14']);
              },
            ),
          ],
        ),
        Spacer(),
        feedBackThumbs(bus,constraints.width),
      ],
    )
  );
}
