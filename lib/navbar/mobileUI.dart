import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/UIColors.dart';
import 'package:mapTest/loadModules/mapViewOSM.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/mapOverlay/mapOverlay.dart';
import '../OSMapLayer.dart';
import '../infoDisp.dart';
import 'package:mapTest/dataClasses/multiLang.dart';

bool isScheduleView = true;

class MobileUI extends StatefulWidget {
  MobileUIState createState() => MobileUIState();
}

class MobileUIState extends State<MobileUI> {
  Widget mobileMainView = Buletin();

  _update() {
    setState(() {
      if (isScheduleView) {
        mobileMainView = Buletin();
      } else {
        mobileMainView = new Stack(
          children: <Widget>[
            MapPage(),
            drawMapOverlay(),
          ],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height;

    return new Container(
        child: new Column(
      children: <Widget>[
        Container(
          child: mobileMainView,
          height: 0.95 * screenHight,
        ), // in infodisp
        Stack(
          children: <Widget>[
            SizedBox(
              height: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: isScheduleView ? Colors.white : Colors.white60,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      //print('You tapped on map');
                      isScheduleView = true;
                      _update();
                    },
                    child: Container(
                      transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                      margin: EdgeInsets.only(left: 10, right: 5,), //top: 0),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      width: screenWidth / 2.5,
                      //height: screenHeight * 0.1,
                      decoration: BoxDecoration(
                        color: baseBlack,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(5)),
                      ),
                      child: Text(lbl_schedule.print(), style: infoBrdLarge, textAlign: TextAlign.center,),
                    ),

                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      //print('You tapped on map');
                      isScheduleView = false;
                      _update();
                    },
                    child: Container(
                      transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                      margin: EdgeInsets.only(left: 5, right: 10,),
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      width: screenWidth / 2.5,
                      //height: screenHeight * 0.1,
                      decoration: BoxDecoration(
                        color: baseBlack,
                        borderRadius:
                        BorderRadius.all(const Radius.circular(5)),
                      ),
                      child: Text(lbl_map.print(), style: infoBrdLarge, textAlign: TextAlign.center,),
                    ),

                  ),
                ),



              ],
            ),
          ],
        ),

        /*Row(children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: screenWidth / 2,
                      height: screenHeight * 0.005,
                      color: isScheduleView ? baseBlue : baseBlack,
                    ),
                    Container(
                      width: screenWidth / 2,
                      height: screenHeight * 0.07,
                      color: baseBlack,
                      child: FlatButton( child: Text(lbl_schedule.print(), style: infoBrdLarge,),
                        onPressed: (){
                          print('You tapped on Shedule');
                          isScheduleView = true;
                          _update();
                        },),
                    )
                  ],),),

              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: screenWidth / 2,
                      height: screenHeight * 0.005,
                      color: isScheduleView ? baseBlack : baseBlue,
                    ),
                    Container(
                      width: screenWidth / 2,
                      height: screenHeight * 0.07,
                      color: baseBlack,
                      child: FlatButton( child: Text(lbl_map.print(), style: infoBrdLarge,),
                        onPressed: (){
                          print('You tapped on map');
                          isScheduleView = false;
                          _update();
                        },),
                    )
                  ],),)

            ],
            ),*/
        // Text('hello world'),
      ],
    ));
  }
}
