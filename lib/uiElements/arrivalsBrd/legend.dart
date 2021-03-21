import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/dataClasses/multiLang.dart';

import '../UIColors.dart';

Widget legend(BuildContext context, Size constraints) {
  //, //Station station){




  String lineName = lbl_lineName.print().padRight(5, ' ');
  Color lineColor = Colors.white70;

  String startTime = lbl_departsAt.print();
  String ETAtime = lbl_arrivesIn.print();
  String lineDescr = lbl_lineDescr.print();
  String nickName = lbl_nickName.print();
  String erExp = lbl_expError.print();

  final TextStyle busSmallTextStyle = GoogleFonts.robotoCondensed(
      fontSize: autoSizeOneLine(
          stringLength: [lineName.length,startTime.length,ETAtime.length,nickName.length, erExp.length].reduce(max) + 2,
          maxWidth:  0.19 * constraints.width * 0.95),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  return Container(
    margin: EdgeInsets.only(bottom: constraints.width / 50),
    padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: constraints.width / 50),
    //padding: EdgeInsets.zero,
    width: constraints.width,
    color: baseBlack,
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
                            child: Text(lineName, style: busSmallTextStyle.apply(color: baseYellow), textAlign: TextAlign.start,),

                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 2 * constraints.height/3,
                            width: 0.08 * 0.7 * constraints.width,
                            //child: stationLetter(timeTextStyle.fontSize * 0.9 ,stationLet),

                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 2 * constraints.height/3,
                            width: 0.08 * 0.7 * constraints.width,
                            /*child: indicator(timeTextStyle.fontSize * 0.9, lineColor.withOpacity(0.4), lineColor, Color.fromRGBO(16, 16, 19, 1), bus.displayedOnMap
                                ? false
                                : true),*/

                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                height: 2 * constraints.height/3,
                                // color: Colors.orange,
                                child: Text((startTime).padRight(7, ' '), style: busSmallTextStyle,)

                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: 2 * constraints.height/3,
                            width: 0.3 * 0.7 * constraints.width,
                            child: Text(ETAtime, style: busSmallTextStyle.apply(color: baseYellow))

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
                      child:  Text( lineDescr.toUpperCase(), style: busSmallTextStyle,),
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
                        child: Center(
                          child:Icon(
                            Icons.near_me,
                            color: Colors.white,
                            size: 0.04 * constraints.width,
                            semanticLabel: 'accessibility',
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                              alignment: Alignment.topCenter,
                              height: constraints.height/2,
                              width: 0.06 * constraints.width,
                              child: Center(
                                child:Icon(
                                  Icons.accessible_forward,
                                  color: Colors.white,
                                  size: 0.04 * constraints.width,
                                  semanticLabel: 'accessibility',
                                ),
                              ),
                            ),
                          )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}