import 'dart:js';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mapTest/uiElements/desktopOnlyElements/desktopUI.dart';
import 'package:mapTest/uiElements/mobileOnlyElements/mobileUI.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/uiElements/responsive/ResponsiveWrapper.dart';
import 'dataClasses/DeviceInfo.dart';
import 'dataClasses/Show.dart';
import 'dataClasses/user.dart';
import 'mapRelated/map.dart';

final int mapRefreshPeriod = 1000;
BuildContext mainViewContext;

double screenWidth = 1920;
double screenHeight = 1080;
String deviceType = 'MOB';

User user = new User();  // new user to store position
Show busFilters = new Show();
Widget mainMapPage = MapPage(mapTileSwitchController.stream, callMapRefresh.stream);
StreamController<int> redrawLayoutController = StreamController<int>.broadcast();

void main() {
  //setPathUrlStrategy();
  update();                                                                     /// run bus locating functions paralel to main
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// This widget is the root of your application. Set title, theme and navigation routes
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiBus',
      theme: ThemeData(primarySwatch: Colors.blue,),
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

  if(page.contains('su')){
    user.setCity("subotica");
  }
  else if(page.contains('ns')){
    user.setCity("novi_sad");
  }
  buslist.clear();
  stationList.clear();
  selectedStations.clear();
  loadStationsFromJson(user.stationsFile);                                       /// LOAD STATIONS FROM FILE !!! I Know you;re looking for this all the time/// DBG
  return Scaffold(
    body: Index());
}

class Index extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //onLoad();
    // Full screen width and height
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

// Height (without SafeArea)
    var appPadding = MediaQuery.of(context).viewPadding;
    double height1 = screenHeight - appPadding.top - appPadding.bottom;

// Height (without status bar)
    double height2 = screenHeight - appPadding.top;

// Height (without status and toolbar)
    screenHeight = screenHeight - appPadding.top - kToolbarHeight;              /// use this for stuff?

    if(screenWidth > 1000){/// TODO: use some better criteria
      deviceType = 'DES';
      return DesktopUI(redrawLayoutController.stream);
    }
    else{
      deviceType = 'MOB';
      return MobileUI(redrawLayoutController.stream);
    }
  }
}

void update() async {
  while(true){
    await new Future.delayed(Duration(milliseconds: mapRefreshPeriod));
    calcBusPos();
  }
}

/*Future<void> onLoad() async {
  //await loadStationsFromFiles();
  //await writeCookie();
  //await readCookie();
}*/



