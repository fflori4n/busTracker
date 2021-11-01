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

User user = new User();  // new user to store position
Show busFilters = new Show();
Widget mainMapPage = MapPage(mapTileSwitchController.stream);
StreamController<int> redrawLayoutController = StreamController<int>.broadcast();

void main() {
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
  loadStationsFromJson(user.stationsFile);
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
    //onLoad();
    if(deviceInfo.deviceType == DeviceType.desktop){
      return DesktopUI(redrawLayoutController.stream);
    }
    else{
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



