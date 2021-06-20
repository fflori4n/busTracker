import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/mapRelated/map.dart';
import 'package:mapTest/uiElements/UIColors.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/mapRelated/drawoverlay.dart';
import 'package:mapTest/uiElements/responsive/ResponsiveWrapper.dart';
import 'package:swipedetector/swipedetector.dart';
import '../infoDisp.dart';

bool isScheduleView = true;
//StreamController<int> redrawMobLayoutController = StreamController<int>.broadcast(); // moved to main

class MobileUI extends StatefulWidget {
  final Stream<int>stream;
  MobileUI(this.stream);
  
  MobileUIState createState() => MobileUIState();
}

class MobileUIState extends State<MobileUI> {
  Widget mobileMainView = Buletin();

  @override
  void initState(){
    widget.stream.listen((num) { _update(); });
  }

  _update() {
    setState(() {
      if (isScheduleView) {
        mobileMainView = SwipeDetector(
          child: Buletin(),
          onSwipeUp: () {

          },
          onSwipeRight: () {
            isScheduleView = false;
            print("swipe right!");
            setState(() {
              _update();
            });
          },
          swipeConfiguration: SwipeConfiguration(
              verticalSwipeMinVelocity: 100.0,
              verticalSwipeMinDisplacement: 50.0,
              verticalSwipeMaxWidthThreshold:100.0,
              horizontalSwipeMaxHeightThreshold: 50.0,
              horizontalSwipeMinDisplacement:50.0,
              horizontalSwipeMinVelocity: 200.0),
        );
      } else {
        mobileMainView = new Stack(
          children: <Widget>[
            mainMapPage,
            MapOverlay(redrawOverlayController.stream),
          ],
        );
      }
    });
  }

  Widget showMobileBottomNav(Size constraints){

    final TextStyle buttonTextSty = GoogleFonts.robotoCondensed(
        fontSize: autoSizeOneLine(
            stringLength: max("Red Vožnje".length, '#filteri'.length),
            maxWidth: constraints.width*0.85 / 3.8),
        fontWeight: FontWeight.normal,
        color: baseWhite,
        letterSpacing: 1.1);

    return Stack(
      children: [
        Container(
          color: isScheduleView ? Color.fromRGBO(46, 46, 46, 1) : Color.fromRGBO(46, 46, 46, 1).withOpacity(0.8),
          height: constraints.height,
          width: constraints.width,
        ),
        Container(
            height: constraints.height,
            width: constraints.width,
            transform: Matrix4.translationValues(0.0, constraints.height * -0.2, 0.0),
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: constraints.width/50),
                    height: constraints.height,
                    width: 23.5*constraints.width/50,
                    decoration: BoxDecoration(
                      color: baseBlack,
                      borderRadius: BorderRadius.all(const Radius.circular(5)),
                    ),
                    child: Tooltip(
                      message: 'schedule',
                      child: FlatButton(
                        onPressed: (){
                          isScheduleView = true;
                          _update();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(height: constraints.height*0.2,),
                            Text("Dolazci".toUpperCase(), style: buttonTextSty,),
                            Container(
                              transform: Matrix4.translationValues(0.0, constraints.height * 0.15, 0.0),
                              decoration: BoxDecoration(
                                color: isScheduleView ? infoDispDarkBlue : Colors.black45 ,
                                borderRadius: BorderRadius.all(const Radius.circular(2),),
                              ),
                              width: 5*constraints.width/50,
                              height: constraints.height*0.2,
                            )
                          ],
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(right: constraints.width/50),
                  height: constraints.height,
                  width: 23.5*constraints.width/50,
                  decoration: BoxDecoration(
                    color: baseBlack,
                    borderRadius: BorderRadius.all(const Radius.circular(5)),
                  ),
                  child: Tooltip(
                    message: 'mapa',
                    child: FlatButton(
                      onPressed: (){
                        isScheduleView = false;
                        _update();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(height: constraints.height*0.2,),
                          Text("mapa".toUpperCase(), style: buttonTextSty,),
                          Container(
                            transform: Matrix4.translationValues(0.0, constraints.height * 0.15, 0.0),
                            decoration: BoxDecoration(
                              color: isScheduleView ? Colors.black45 : infoDispDarkBlue,
                              borderRadius: BorderRadius.all(const Radius.circular(2),),
                            ),
                            width: 5*constraints.width/50,
                            height: constraints.height*0.2,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    return RespWrap(
        builder: (context, deviceInfo){
        width = deviceInfo.widgetSize.width;
        height = deviceInfo.widgetSize.height;
      return Container(
        child: new Column(
      children: <Widget>[
        Container(
          child: mobileMainView,
          height: 0.94 * height,
        ), // in infodisp
        showMobileBottomNav(Size(width, height*0.05)),
      ],
    ));});
  }
}
