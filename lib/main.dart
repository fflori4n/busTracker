import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/UIColors.dart';
import 'package:mapTest/infoDisp.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/navbar/mobileUI.dart';
import 'dart:async';
import 'dataClasses/Show.dart';
import 'infoBoardItem/indicator.dart';
import 'loadModules/mapViewOSM.dart';
import 'package:mapTest/loadModules/mapViewOSM.dart';

import 'mapOverlay/mapOverlay.dart';
import 'location/locationTest.dart';

const smTresh = 1000;
const mlTresh = 1000;
// TODO: figure out how to set dinamic size of elements
final int mapRefreshPeriod = 500;

Show busFilters = new Show();

/*bool isSmallScreen = false;
bool isMediumScreen = true;
bool isLargeScreen = false;*/
bool isMobile = true;
double screenWidth = 1920;
double screenHeight = 1080;
double wScaleFactor=1;
double hScaleFactor=1;

LatLng mapCenter;
LatLng mapNW;
LatLng mapSE;
final LatLng mapRefPoint = LatLng(45.2603, 19.8260);
double mapZoom;

String progStatusString = '';

bool filtTabOpen = false;

void main() {
  //getCurrentLocation();
  // 46.1013842,19.633794599999998
  update();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiBus',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: Index(),
    );
  }
}

class Index extends StatelessWidget {
  const Index({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    wScaleFactor = screenWidth / 1366;  // dev screen width
    hScaleFactor = screenHeight / 900;

    return LayoutBuilder(
      builder: (context,constraints){
          if(constraints.maxWidth < smTresh){                                   // MOBILE VIEW
            print('** MOBILE VIEW DBG **');
            isMobile = true;
            return Scaffold(
                body: MobileUI());
          }           // DESKTOP VIEW
          else{
            print('** DESKTOP VIEW DBG **');
            isMobile = false;
            return Scaffold(
                body: new Container(
                    child:new Stack(
                      children: <Widget>[
                        //navBar(),
                        mapView(),
                        drawMapOverlay(),
                        //SideNav(),
                        Buletin(),
                      ],
                    )
                ));
          }
      }
    );
  }
}

void update() async {
  while(true){
    await new Future.delayed(Duration(milliseconds: mapRefreshPeriod));
    //DateTime now = DateTime.now();
    calcBusPos();

  }
}



