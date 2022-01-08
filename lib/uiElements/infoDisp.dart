import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/busLocator.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/uiElements/tabs.dart';
import 'package:mapTest/uiElements/arrivalsBrd/stationNameBrd.dart';
import 'package:mapTest/uiElements/tabIconRow.dart';
import '../filters.dart';
import 'arrivalsBrd/listItem.dart';


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

    if(deviceType == 'DES'){
      width = max(screenWidth * 0.25, 480);
      height = screenHeight*0.9;
    }
    else{
      width = screenWidth;
      height = screenHeight;
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
            /*(user.tabOpen != 5) ? Container(
                          child: legend(context,Size(width,width/10)),
                        ) : Container(),*/
            (user.tabOpen != 5) ? getListView(context, width) : Container(),
          ],
        ));
  }
}

Widget getListView(context, double maxWidth) {
  if(busFilters.refreshFlg){
    applyFilters(busFilters);                                                 /// this also slow, but easy to implement, maybe worth it?
    busFilters.refreshFlg = false;
  }
  displayedBusList.clear();
  for (var bus in buslist){                                                   /// Double iteration, find a soulution to loop only once over buslist...
    if(bus.displayedOnSchedule){
      if(busFilters.next10only && displayedBusList.length >= 10){
        break;
      }
      displayedBusList.add(bus);
    }
  }
  if(displayedBusList.length <= 0){
    return SizedBox.shrink();
  }
  return Expanded(child: ListView.builder(
    itemCount: displayedBusList.length,
    itemBuilder: (BuildContext context, int index) {
     try{
        return busListItem(context, displayedBusList[index], Size(maxWidth, maxWidth/10), index);
      }
      catch(E){
        print("[  ER  ] "+ E.toString());
        print(displayedBusList[index].nickName);
        print(displayedBusList.length);
        return SizedBox.shrink();
      }
      },

  ));
}