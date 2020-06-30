import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/infoDisp.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'dart:async';
import 'loadModules/mapViewOSM.dart';
import 'package:mapTest/loadModules/mapViewOSM.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mapOverlay/mapOverlay.dart';

const smTresh = 400;
const mlTresh = 1200;
const mapRefreshPeriod = 500;
bool isSmallScreen = false;
bool isMediumScreen = true;
bool isLargeScreen = false;
double screenWidth = 1920;
double screenHeight = 1080;
double wScaleFactor=1;
double hScaleFactor=1;

LatLng mapCenter;
LatLng mapNW;
LatLng mapSE;
final LatLng mapRefPoint = LatLng(45.2603, 19.8260);
double mapZoom;

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

    wScaleFactor = screenWidth / 1366;  // dev screen width
    hScaleFactor = screenHeight / 900;

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
           drawMapOverlay(),
           //SideNav(),
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
    await new Future.delayed(const Duration(milliseconds: mapRefreshPeriod));
    moveBus();
    //readConsole();
   // mapViewState.setState(() {});
    //print(map.center.toString() + " " + map.zoom.toString());
    //print(mapPos.toString());
  }
}



