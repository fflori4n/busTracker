import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/uiElements/desktopOnlyElements/desktopUI.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/session/shared_pref.dart';
import 'package:mapTest/uiElements/mobileOnlyElements/mobileUI.dart';
import 'package:mapTest/uiElements/responsive/ResponsiveWrapper.dart';
import 'dart:async';
import 'dataClasses/DeviceInfo.dart';
import 'dataClasses/Show.dart';
import 'dataClasses/StateMan.dart';
import 'dataClasses/user.dart';
import 'mapRelated/map.dart';

final LatLng nsMapRefPoint = LatLng(45.2603, 19.8260);
final LatLng suMapRefPoint = LatLng(46.100217,19.664413);

LatLng mapRefPoint = nsMapRefPoint;
String busLineCityStr = "nsCityBusLines";

final double smTresh = 1000;
final double mlTresh = 1000;
final int mapRefreshPeriod = 500;

String city = '';

BuildContext mainViewContext;

double screenWidth = 1920;
double screenHeight = 1080;
double wScaleFactor=1;
double hScaleFactor=1;
double maxTabWidth = 1920;
bool isMobile = true;

User user = new User();  // new user to store position
Show busFilters = new Show();

Widget mainMapPage = MapPage(mapTileSwitchController.stream);

StateMan globalStates = new StateMan();

void main() {
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
      //home: Index(),//Index(),
      initialRoute: '/ns',
      routes: {
        '/': (context) => router('x'),
        '/ns': (context) => router('ns'),
        '/su': (context) => router('su'),
      }
    );
  }
}

Widget router(String page){     // TODO: welp. whatever... at this point everything is spaghetti
  selectedStations = [];  // DBG !!!!!
  if(page.contains('su')){
    mapRefPoint = suMapRefPoint;
    print('** In subotica! **');
    loadStationsFromJson("suBusStops");
    busLineCityStr = "suCityBusLines";
  }
  else if(page.contains('ns')){
    mapRefPoint = nsMapRefPoint;
    print('** In novi sad! **');
    loadStationsFromJson("nsBusStops");
    busLineCityStr = "nsCityBusLines";
  }
  return Scaffold(
    body: RespWrap(
      builder: (context, deviceInfo){
        return Index(deviceInfo);
      },
    ),
  );
}

class Index extends StatelessWidget {
  DeviceInfo deviceInfo;
  Index(this.deviceInfo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    onLoad();
    if(deviceInfo.deviceType == DeviceType.desktop){
      return DesktopUI();
    }
    if(deviceInfo.deviceType == DeviceType.desktop){
      return DesktopUI();
    }
    return MobileUI();
  }
}

void update() async {
  while(true){
    await new Future.delayed(Duration(milliseconds: mapRefreshPeriod));
    calcBusPos();
  }
}

Future<void> onLoad() async {
  //await loadStationsFromFiles();
  //await writeCookie();
  await readCookie();
}



