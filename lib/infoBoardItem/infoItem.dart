import 'dart:js';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapTest/animatons/fadeInAnim.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/infoBoardItem/indicator.dart';
import 'package:mapTest/infoBoardItem/stationSign.dart';
import 'package:mapTest/UIColors.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/mapRelated/map.dart';

import '../main.dart';
import 'dart:js' as js;

Widget drawBuletinitem(BuildContext context, Bus bus) {
  //, //Station station){

  if (!bus.displayedOnSchedule) {
    return Container();
  }

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

  String ETAhours = bus.eTA.hours.toString().padLeft(2, '0');
  String ETAmins = bus.eTA.mins.toString().padLeft(2, '0');
  String ETAsex;
  if (bus.eTA.mins > 10 || bus.eTA.hours != 0) {
    ETAsex = "00".padLeft(2, '0');
  } else {
    ETAsex = bus.eTA.sex.toString().toString().padLeft(2, '0');
  }

  String nickName = bus.nickName.toUpperCase();
  String erExp = '+' +
      bus.expErMarg.mins.toString().padLeft(2, '0') +
      ':' +
      bus.expErMarg.sex.toString().padLeft(2, '0');

  String stationLet = bus.stationNumber.toString();

  return FadeIn(
    1.5,
    GestureDetector(
      onTap: () {
        bus.isHighLighted = !bus.isHighLighted;
        mapController.move(
            bus.busPos.busPoint, mapConfig.mapZoom); // TODO: test test test
      },
      //opacity: _visible ? 1.0 : 0.0,
      //           duration: Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
            padding:
                EdgeInsets.only(left: 7.0, right: 7.0, top: 5.0, bottom: 3.0),
            decoration: BoxDecoration(
              border: bus.isHighLighted
                  ? Border.all(color: baseBlue, width: 1)
                  : Border.all(color: Colors.white70, width: 1),
              borderRadius: new BorderRadius.all(Radius.circular(2.0)),
            ),
            child: Column(children: [
              Row(
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
                                        style: infoBrdYellow,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          stationLetter(stationLet),
                                          indicator(
                                              lineColor.withOpacity(0.4),
                                              lineColor,
                                              Color.fromRGBO(16, 16, 19, 1),
                                              bus.displayedOnMap
                                                  ? false
                                                  : true),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  (startHours + ':' + startMins)
                                      .padRight(7, ' '),
                                  style: infoBrdLarge,
                                ),
                              ),
                              Expanded(
                                child: msgInsteadOfETA.isEmpty
                                    ? AutoSizeText(
                                        (ETAhours +
                                                ':' +
                                                ETAmins +
                                                ':' +
                                                ETAsex)
                                            .padRight(10, ' '),
                                        style: infoBrdYellow,
                                      )
                                    : AutoSizeText(
                                        msgInsteadOfETA.padRight(10, ' '),
                                        style: infoBrdSmall,
                                      ),
                              ),
                            ],
                          ),
                          AutoSizeText(
                            bus.lineDescr.toUpperCase(),
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
                                  style: infoBrdSmall,
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
                                  child: indicator(
                                      baseGray,
                                      baseYellow,
                                      Color.fromRGBO(16, 16, 19, 1),
                                      !bus.displayedOnMap),
                                  margin: EdgeInsets.only(
                                      top: 0,
                                      bottom: 1.5,
                                      left: 6.0,
                                      right: 3.0),
                                  height: infoBrdSmall.fontSize,
                                ),
                                Container(
                                  child: indicator(
                                      baseGray,
                                      baseWhite,
                                      Color.fromRGBO(16, 16, 19, 1),
                                      !bus.isRampAccesible),
                                  margin: EdgeInsets.only(
                                      top: 0,
                                      bottom: 1.5,
                                      left: 6.0,
                                      right: 3.0),
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
              ),
              bus.isHighLighted ? extrainfo(bus) : Container(), // DBG
            ]),
          ),
        ],
      ),
    ),
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
                                        fontSize: 10 * wScaleFactor),
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
                              child: indicator(Color.fromRGBO(16, 16, 19, 1),
                                  baseWhite, baseBlack, true),
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 1.5, left: 6.0, right: 3.0),
                              height: infoBrdSmall.fontSize,
                            ),
                            Container(
                              child: indicator(Color.fromRGBO(16, 16, 19, 1),
                                  baseWhite, baseBlack, true),
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 1.5, left: 6.0, right: 3.0),
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

Widget extrainfo(Bus bus) {
  DateTime now = new DateTime.now();
  String intervStart = (now.hour + bus.eTA.hours).toString() +
      ':' +
      (now.minute + bus.eTA.mins).toString();
  String intervEnd =
      (now.hour + bus.eTA.hours + bus.expErMarg.hours).toString() +
          ':' +
          (now.minute + bus.eTA.mins + bus.expErMarg.mins).toString();
  return Container(
    padding: EdgeInsets.only(top: 5, bottom: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stanica : ' + selectedStations.elementAt(bus.stationNumber).name,
          style: busDescrSmall,
          textAlign: TextAlign.left,
        ),
        Text(
          'Očekivani dolazak između ' + intervStart + ' i ' + intervEnd,
          style: busDescrSmall,
          textAlign: TextAlign.left,
        ),
        /*IconButton(
            icon: SvgPicture.asset(
              'svg/filledHeartIcon2.svg',
               color: Colors.black,
               semanticsLabel: 'Acme Logo',
            ),
            onPressed: (){} //do something,
        ),*/ // TODO: renderer crashes for svg?
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
        bus.reported ? Text(
          'Poslata je Vasa prijava. Hvala.',
          style: busDescrSmall,
          textAlign: TextAlign.left,
        ) : Container(),
        bus.displayedOnMap && !bus.reported ? Row(
          children: [
            TextButton(
              onPressed: () {
                bus.reported =  true;
                // TODO: implement feedback POST
              },
              child: Container(
                margin: EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: new BorderRadius.all(Radius.circular(2.0)),
                ),
                child: Text(
                  'Stigao je Bus!',
                  style: busDescrSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                bus.reported =  true;
                // TODO: implement feedback POST
              },
              child: Container(
                margin: EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 5),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: new BorderRadius.all(Radius.circular(2.0)),
                ),
                child: Text(
                  'Prijavi grešku!',
                  style: busDescrSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ) : Container(),
      ],
    ),
  );
}
