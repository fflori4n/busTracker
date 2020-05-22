import 'package:flutter/material.dart';
import 'package:mapTest/infoDisp.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/navbar/navSideBar.dart';
import 'dart:async';
import 'loadModules/mapViewOSM.dart';
import 'package:mapTest/loadModules/mapViewOSM.dart';

import 'navbar/navBar.dart';

//StreamSubscription periodicSub;

const smTresh = 400;
const mlTresh = 1200;
bool isSmallScreen = false;
bool isMediumScreen = true;
bool isLargeScreen = false;
double screenWidth = 1920;
double screenHeight = 1080;

void main() {
  update();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'busTrack',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: index(),
    );
  }
}

class index extends StatelessWidget {
  const index({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    if(screenWidth < smTresh ){
      isSmallScreen = true;
      isMediumScreen = false;
      isLargeScreen = false;
    }else if(screenWidth >= mlTresh){
      isSmallScreen = false;
      isMediumScreen = false;
      isLargeScreen = true;
    }else{
      // init values, save time.
    }

    return Scaffold(
        body: new Container(
        child:new Stack(
          children: <Widget>[
           /*Container(   // navBar
             child:  isSmallScreen ? Text('small') : navBar(),
           ),*/
           //navBar(),
           mapView(),
           SideNav(),
           buletin(),
          ],
        )
    ));
    /*return EnvWidget(
      largeScreen: Text("large screen"),
      mediumScreen: Text("mediumScreen"),
      smallScreen: Text("smallScreen"),
    );*/
  }
}

void update() async {
  while(true){
    await new Future.delayed(const Duration(milliseconds: 500));
    moveBus();
    //readConsole();
   // mapViewState.setState(() {});
    //print(map.center.toString() + " " + map.zoom.toString());
    //print(mapPos.toString());
  }
}



