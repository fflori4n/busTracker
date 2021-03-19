import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/DeviceInfo.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/uiElements/UIColors.dart';
import 'package:mapTest/uiElements/responsive/ResponsiveWrapper.dart';
import 'package:mapTest/uiElements/statusbar.dart';
import 'package:mapTest/uiElements/tabs.dart';
import 'package:mapTest/uiElements/dispStation.dart';
import 'package:mapTest/uiElements/tabIconRow.dart';
import '../dataClasses/Bus.dart';
import '../filters.dart';
import 'infoBoardItem/infoItem.dart';

class Buletin extends StatefulWidget {
  BuletinState createState() => BuletinState();
}

class BuletinState extends State<Buletin> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {});
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
          height = deviceInfo.widgetSize.height*0.8;
        }
        return Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
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
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //deviceInfo.isMobile ? Container() : StatusBar(),            // TODO: responsive status bar
                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: displaySelectedStations(Size(width,0.08 * height)),
                    ),
                    Stack(
                        children: <Widget>[
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(16, 16, 19, 1),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only( left: 10, right: 10),//right: isMobile ? screenWidth/30 : 0.3 * screenWidth/30),
                            //margin: EdgeInsets.only(left: 8, right: 8),
                            child: showTabIconRow(width),
                          ),]
                    ),
                    showTabs(context,user,width),
                    (user.tabOpen != 5) ? Container(
                      child: drawLegend(context),
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
      return drawBuletinitem(context, displayedBusList[index], maxWidth);//, activeStation);
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}

Widget infoLegend(double maxWidth) {                                            // TODO: this not used?
  // TODO: fix ui alignment
  return Container(
    margin: EdgeInsets.only(top: 0.0, bottom: 4.0, left: 0.0, right: 0.0),
    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
    color: baseBlack,
    child: Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Text(
              'Num',
              style: infoBrdSmall,
            ),
          ],
        ),
        Text(
          ('Departs at').padRight(7, ' '),
          style: infoBrdSmall,
        ),
        Expanded(child: SizedBox()),
        Text(
          'Arrives in'.padRight(10, ' '),
          style: infoBrdSmall,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Error'.padLeft(15, ' '),
              style: infoBrdSmall,
            ),
            Text(
              'Nick name',
              style: infoBrdSmall,
            ),
          ],
        ),
        Column(
          children: [
            Container(
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: baseWhite, width: 1.0),
                borderRadius: new BorderRadius.all(Radius.circular(1.0)),
              ),
              margin:
                  EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
              width: infoBrdSmall.fontSize,
              height: infoBrdSmall.fontSize,
            ),
            Container(
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: baseYellow, width: 1.0),
                borderRadius: new BorderRadius.all(Radius.circular(1.0)),
              ),
              margin:
                  EdgeInsets.only(top: 1.5, bottom: 0, left: 6.0, right: 3.0),
              width: infoBrdSmall.fontSize,
              height: infoBrdSmall.fontSize,
            ),
          ],
        ),
      ],
    ),
  );
}