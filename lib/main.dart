import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/OSMapLayer.dart';
import 'package:mapTest/dataClasses/mapConfig.dart';
import 'package:mapTest/infoDisp.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/navbar/mobileUI.dart';
import 'package:mapTest/session/shared_pref.dart';
import 'dart:async';
import 'dataClasses/Show.dart';
import 'dataClasses/user.dart';
import 'loadModules/stations.dart';
import 'mapOverlay/mapOverlay.dart';

final LatLng nsMapRefPoint = LatLng(45.2603, 19.8260);
final LatLng suMapRefPoint = LatLng(46.100217,19.664413);
final double smTresh = 1000;
final double mlTresh = 1000;
final int mapRefreshPeriod = 500;

String city = '';

double screenWidth = 1920;
double screenHeight = 1080;
double wScaleFactor=1;
double hScaleFactor=1;
bool isMobile = true;

User user = new User();  // new user to store position
Show busFilters = new Show();
MapConfig mapConfig = new MapConfig();
MapController mapController = MapController();

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
  city = page;
  return Index();
}

class Index extends StatelessWidget {
  const Index({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    wScaleFactor = screenWidth / 1366;  // dev screen width
    hScaleFactor = screenHeight / 900;

    onLoad();

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
                        //mapView(),
                        MapPage(),        // TODO: Test this.
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

Future<void> onLoad() async {
  await loadStationsFromFiles();
  //await writeCookie();
  await readCookie();
}



