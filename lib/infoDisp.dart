import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/infoBoardItem/infoItem.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/UIColors.dart';
import 'package:mapTest/navbar/statusbar.dart';
import 'dataClasses/Bus.dart';
import 'dataClasses/BusLine.dart';
import 'dataClasses/multiLang.dart';
import 'filters.dart';
import 'loadModules/stations.dart';
import 'location/locationTest.dart';

class Buletin extends StatefulWidget {
  BuletinState createState() => BuletinState();
}

class BuletinState extends State<Buletin> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {});
      /*if(user.locationEnabled){
        updatePos(); // TODO: For now but not suitable location!!!! DBG !!! FIX THIS PLS !!!
      }*/
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 370, height = 800;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
                color: ligthBlack,
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(4.0),
                  bottomRight: const Radius.circular(4.0),
                )),
            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
            //padding: EdgeInsets.only(left: 0.0, top: 0.0),
            height: isMobile ? 0.920 * screenHeight : height * hScaleFactor,
            width: isMobile ? screenWidth: width * wScaleFactor,

            //350
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isMobile ? Container() : StatusBar(),
                Container(
                  decoration: new BoxDecoration(
                    color: baseBlue,
                  ),
                  padding: EdgeInsets.all(6.0),
                  width: isMobile ? screenWidth : width * wScaleFactor,
                  //height: 100 * hScaleFactor,
                  child: Container(                 // *********************************
                    padding: EdgeInsets.all(6.0), // 6
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: lbl_station.print() + ': ',
                                style: infoBrdLabel,
                              ),
                              TextSpan(
                                  text: activeStation.getStationName(),
                                  style: infoBrdLabel),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 3.0,
                            bottom: 3.0,
                          ),
                          child: Row(
                            children: getStationLineLabels(),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
                Container(
                  color: baseBlue,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Container(
                          padding: EdgeInsets.all(6),
                          color: baseGray,
                          child: GestureDetector(
                            child:
                            Text('where am I?', style: infoBrdLabel),
                            onTap: () {
                              user.locTabOpen = !user.locTabOpen;
                            },
                          )
                      ),
                      Container(
                          padding: EdgeInsets.all(6),
                          color: baseBlack,
                          child: GestureDetector(
                            child:
                            Text(lbl_filters.print(), style: infoBrdLabel),
                            onTap: () {
                              user.filtTabOpen = !user.filtTabOpen;
                            },
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  child: drawLegend(context),
                ),
                Expanded(
                  child: getListView(context),
                ),
              ],
            )),
      ],
    );
  }
}

List<Widget> getStationLineLabels() {
  List<Widget> labelList = new List();
  for (var line in activeStation.servedLines) {
    var newText = new GestureDetector(
      child: Text(
        line,
        style: nsBusLinesContainsName(line)
            ? (busFilters.hideLine.contains(line) ? infoBrdSmallCrossedOut : infoBrdSmall) : infoBrdSmallSemiTransp,
        textAlign: TextAlign.left,
      ),
      onTap: () {
        if (busFilters.hideLine.contains(line)) {
          busFilters.hideLine.remove(line);
        } else {
          busFilters.hideLine.add(line);
        }
        applyFilters(busFilters);
      },
    );

    labelList.add(newText);
    labelList.add(Text(' ', style: infoBrdSmall,));
  }

  if (labelList.length > 12) {
    labelList.insert(12, Text('\n'));
  }
  return labelList;
}

Widget getListView(context) {
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
      return drawBuletinitem(context, displayedBusList[index], activeStation);
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}

Widget infoLegend() {
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
// TODO:
/*class MobSchedule extends StatefulWidget {
  MobScheduleState createState() => MobScheduleState();
}

class MobScheduleState extends State<MobSchedule> {
  @override
  void initState() {
    // TODO: only refresh when necessseary
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 370, height = 800;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
                color: ligthBlack,
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(4.0),
                  bottomRight: const Radius.circular(4.0),
                )),
            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
            padding: EdgeInsets.only(left: 0.0, top: 0.0),
            height: screenHeight,
            width: screenWidth,
            //350
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: StatusBar(),
                  width: screenWidth,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                        color: baseBlue,
                      ),
                      padding: EdgeInsets.all(6.0),
                      width: screenWidth,
                      //height: 100 * hScaleFactor,
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Station: ',
                                    style: infoBrdLabel,
                                  ),
                                  TextSpan(
                                      text: activeStation.getStationName(),
                                      style: infoBrdLabel),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 3.0,
                                bottom: 3.0,
                              ),
                              child: Row(
                                children: getStationLineLabels(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        color: baseBlack,
                        child: GestureDetector(
                          child: Text('#filters', style: infoBrdLabel),
                          onTap: () {
                            filtTabOpen = !filtTabOpen;
                          },
                        )),
                  ],
                ),
                Container(
                  child: infoLegend(),
                ),
                Expanded(
                  child: getListView(context),
                ),
              ],
            ))
      ],
    );
  }
}
*/