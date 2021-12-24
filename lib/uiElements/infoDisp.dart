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
import 'package:mapTest/uiElements/arrivalsBrd/stationNameBrd.dart';
import 'package:mapTest/uiElements/tabIconRow.dart';
import '../dataClasses/Bus.dart';
import '../filters.dart';
import 'arrivalsBrd/infoItem.dart';
import 'arrivalsBrd/legend.dart';


StreamController<int> redrawInfoBrd = StreamController<int>.broadcast();

class Buletin extends StatefulWidget {
  final Stream<int>stream;
  Buletin(this.stream);

  BuletinState createState() => BuletinState();
}

class BuletinState extends State<Buletin> {

  @override
  void initState() {

    widget.stream.listen((num) {
      if(mounted){
        setState(() {});
      }
    });
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
              height = deviceInfo.widgetSize.height;
              print('mobile layout!');
            }
            return Container(
                    decoration: new BoxDecoration(
                        color: Color.fromRGBO(16, 16, 16, 1),
                        borderRadius: new BorderRadius.only(
                          topRight: const Radius.circular(4.0),
                          bottomRight: const Radius.circular(4.0),
                        )),
                    alignment: Alignment.topLeft,
                    height: height,
                    width: width,
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: displaySelectedStations(Size(width, (width/10)*2/3)),
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
                    ));
          });
  }
}

Widget getListView(context, double maxWidth) {
  // TODO: this is slow, temp fix
  List<Bus> displayedBusList = [];
  if(busFilters.refreshFlg){
    applyFilters(busFilters); /// this also slow, but easy to implement, maybe worth it?
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
  return ListView.separated(/// lazy listview do not render stuff that isn't visible
    itemCount: displayedBusList.length,
    itemBuilder: (BuildContext context, int index) {
      return infoWidget(context, displayedBusList[index], index, Size(maxWidth, maxWidth/10));
    },
    separatorBuilder: (BuildContext context, int index) =>  const Divider( height: 0,),
  );
}