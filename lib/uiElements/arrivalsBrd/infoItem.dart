import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/uiElements/UIColors.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/mapRelated/map.dart';
import 'package:mapTest/uiElements/animatons/fadeInAnim.dart';
import 'package:mapTest/uiElements/arrivalsBrd/stationSign.dart';
import 'package:mapTest/uiElements/feedBackThumbs.dart';
import 'dart:js' as js;

import '../infoDisp.dart';
import 'indicator.dart';



 
Widget infoWidget(BuildContext context, Bus bus, int listIndex, Size constraints) {
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

  String dispBusDescript = bus.lineDescr;
  if(bus.lineDescr.length > 32){
    if(bus.descScrollPos >= (bus.lineDescr.length + 10)){                                /// shift description if too long
      bus.descScrollPos = 0;
    }
    dispBusDescript = (bus.lineDescr + "           " + bus.lineDescr).substring(bus.descScrollPos, bus.descScrollPos+32);
    bus.descScrollPos++;
  }

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
      (bus.expErMarg ~/ 60).toString().padLeft(2, '0') +
      ':' +
      (bus.expErMarg % 60).toInt().toString().padLeft(2, '0');
  if(!bus.displayedOnMap){
    erExp = '+00:00';
  }

  String stationLet = (bus.stationNumber + 1).toString();

    return FadeIn(                                                              /// TODO: convert item list to animated list for more control
      (listIndex * 150.0),
        InkWell(
              onTap: (){
                bus.isHighLighted = !bus.isHighLighted;
                redrawInfoBrd.add(1); /// test if laggy
                if(bus.displayedOnMap){
                  mapController.move(
                      bus.busPos.busPoint, mapConfig.mapZoom);
                }
              },
              onHover: (isHovering){
                if(isHovering){
                  bus.isTargMarkered = true;
                  redrawInfoBrd.add(1);
                }
                else{
                  bus.isTargMarkered = false;
                  redrawInfoBrd.add(1);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: constraints.width / 200, horizontal: constraints.width / 50),  // 0.5
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
                                  child:  Text( dispBusDescript.toUpperCase(), style: busDescrTextStyle,),
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
          ),
    );
}

Widget extrainfo(Bus bus, Size constraints) {

  double time2Station = getEstTime2Station(selectedStations.elementAt(bus.stationNumber).distFromLineStart[bus.stationNumber]).toDouble();
  DateTime intervStart = DateTime.fromMillisecondsSinceEpoch((bus.unixStartDT + time2Station) * 1000);
  DateTime intervEnd = intervStart.add(Duration(seconds: bus.expErMarg.toInt()));

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
              'Očekivani dolazak između ' + intervStart.hour.toString().padLeft(2, '0') + ':' + intervStart.minute.toString().padLeft(2, '0') + ' i ' + intervEnd.hour.toString().padLeft(2, '0') + ":" + intervEnd.minute.toString().padLeft(2, '0'),
              style: busSmallTextStyle,
              textAlign: TextAlign.left,
            ),
            InkWell(
              child: Text(
                'pogledajte mesto na google maps',
                style: busSmallTextStyle.apply(color: infoDispLiteBlue),
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
