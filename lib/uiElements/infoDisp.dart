import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/DeviceInfo.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/uiElements/UIColors.dart';
import 'package:mapTest/uiElements/responsive/ResponsiveWrapper.dart';
import 'package:mapTest/uiElements/tabs.dart';
import 'package:mapTest/uiElements/dispStation.dart';
import 'package:mapTest/uiElements/tabIconRow.dart';
import '../dataClasses/Bus.dart';
import '../filters.dart';
import 'arrivalsBrd/infoItem.dart';
import 'arrivalsBrd/legend.dart';

class Buletin extends StatefulWidget {
  BuletinState createState() => BuletinState();
}

class BuletinState extends State<Buletin> {

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {});
      //globalStates.reDrawInfoBrd;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 480;
    double height = 600;

    return RespWrap(
          builder: (context, deviceInfo){
            if(deviceInfo.deviceType == DeviceType.desktop){
              width = max(deviceInfo.widgetSize.width * 0.25, 480);
              height = deviceInfo.widgetSize.height*0.9;
            }
            else{
              width = deviceInfo.widgetSize.width;
              height = deviceInfo.widgetSize.height*0.9;
            }
            infoBrdWidth = width;
            return Column(
              children: <Widget>[
                Container(
                    decoration: new BoxDecoration(
                        color: Color.fromRGBO(16, 16, 16, 1),
                        borderRadius: new BorderRadius.only(
                          topRight: const Radius.circular(4.0),
                          bottomRight: const Radius.circular(4.0),
                        )),

                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.symmetric(vertical: 6.0),
                    height: height,
                    width: width,

                    child: Column(
                      children: <Widget>[
                        //deviceInfo.isMobile ? Container() : StatusBar(),            // TODO: responsive status bar
                        Column(
                          children: displaySelectedStations(Size(width, height)),
                        ),
                        showTabIconRow(width),
                        showTabs(context,user,width),
                        (user.tabOpen != 5) ? Container(
                          child: legend(context,Size(width,width/10)),
                        ) : Container(),
                        (user.tabOpen != 5) ? Expanded(
                          child: getListView(context, width),
                        ) : Container(),
                      ],
                    )),
              ],
            );
          });
  }
}

Widget getListView(context, double maxWidth) {
  // TODO: this is slow, temp fix
  List<Bus> displayedBusList = [];
  if(busFilters.refreshFlg){
    applyFilters(busFilters); // this also slow, but easy to implement, maybe worth it?
    busFilters.refreshFlg = false;
  }
  for (var bus in buslist){
    if(bus.displayedOnSchedule){
      if(busFilters.next10only && displayedBusList.length >= 10){
        break;
      }
      displayedBusList.add(bus);
    }
  }
  return ListView.separated(// lazy listview do not render stuff that isn't visible
    itemCount: displayedBusList.length,
    itemBuilder: (BuildContext context, int index) {
      return infoWidget(context, displayedBusList[index], Size(maxWidth, maxWidth/10));
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}