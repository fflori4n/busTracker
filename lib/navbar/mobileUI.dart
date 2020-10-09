import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/UIColors.dart';
import 'package:mapTest/loadModules/mapViewOSM.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/mapOverlay/mapOverlay.dart';
import '../infoDisp.dart';

bool isScheduleView = true;

class MobileUI extends StatefulWidget {
  MobileUIState createState() => MobileUIState();
}

class MobileUIState extends State<MobileUI> {
  Widget mobileMainView = Buletin();

  _update(){
    setState(() {
      if(isScheduleView){
        mobileMainView = Buletin();
      }
      else{
        mobileMainView = new Stack(
          children: <Widget>[
            mapView(),
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
        child:new Column(
          children: <Widget>[
            Container(
              child: mobileMainView,
              height: 0.925 * screenHight,
            ),    // in infodisp
            Row(children: <Widget>[
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
                      child: FlatButton( child: Text('Shedule', style: infoBrdLarge,),
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
                      child: FlatButton( child: Text('Map', style: infoBrdLarge,),
                        onPressed: (){
                          print('You tapped on map');
                          isScheduleView = false;
                          _update();
                        },),
                    )
                  ],),)

            ],
            ),
            // Text('hello world'),
          ],
        )
    );
  }
}