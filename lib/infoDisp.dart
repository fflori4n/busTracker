import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/infoBoardItem/infoItem.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/UIColors.dart';

import 'dataClasses/BusLine.dart';
import 'infoBoardItem/infoListView.dart';
import 'loadModules/stations.dart';
import 'navbar/navBar.dart';

class buletin extends StatefulWidget {
  buletinState createState() => buletinState();
}

class buletinState extends State<buletin> {

  @override
  void initState(){
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
                color: ligthBlack,
                borderRadius: new BorderRadius.only(
                  topRight: const Radius.circular(4.0),
                  bottomRight: const Radius.circular(4.0),
                )
          ),
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
          padding: EdgeInsets.only(left: 0.0, top: 0.0),
          height: 800 * hScaleFactor,
          width: 370 * wScaleFactor,  //350
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                color: baseBlue,
                ),
                padding: EdgeInsets.all(6.0),
                width: 370 * wScaleFactor,
                //height: 100 * hScaleFactor,
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Station:',
                        style: infoBrdLabel,
                        textAlign: TextAlign.left,
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 3.0, bottom: 6.0,),
                        child: Text(
                          activeStation.getStationName(),
                          style: infoBrdLarge,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        'Lines:',
                        style: infoBrdLabel,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3.0, bottom: 4.0,),
                        child: Row(
                          children: getStationLineLabels(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              /*Container(
                decoration: new BoxDecoration(
                  color: baseWhite,
                ),
                height: 3,
                margin: EdgeInsets.only(bottom: 5.0),
              ),*/
              Container(
                child: infoLegend(),
              ),
              Expanded(
                child: getListView(context),
              ),
            ],
          )
    )],
    );
  }
}

List<Widget> getStationLineLabels(){
  List<Widget> labelList = new List();
  for(var line in activeStation.servedLines){
    Text newText;
    if(nsBusLinesContainsName(line)){
      newText = new Text(
        line + ' ',
        style: infoBrdSmall,
        textAlign: TextAlign.left,);
    }
    else{
      newText = new Text(
        line + ' ',
        style: infoBrdSmallSemiTransp,
        textAlign: TextAlign.left,);
    }
    labelList.add(newText);
  }
  //labelList.add(Text('hello world', style: infoBrdSmall,));
  return labelList;
}

Widget getListView(context){
  return ListView.separated(  // lazy listview do not render stuff that isn't visible
    //padding: const EdgeInsets.all(8),
    itemCount: buslist.length,
    itemBuilder: (BuildContext context, int index) {
      //return infoItem(context, index);
      return drawBuletinitem(context, buslist[index], activeStation);
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}

Widget infoLegend(){
  return Container(
    margin: EdgeInsets.only(top: 0.0, bottom: 4.0, left: 0.0, right: 0.0),
    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
    color: baseBlack,
    child: Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Text('Num', style: infoBrdSmall,),
          ],
        ),
        Text( ('Departs at').padRight(7,' '), style: infoBrdSmall,),
        Expanded(child: SizedBox()),
        Text('Arrives in'.padRight(10,' '), style: infoBrdSmall,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Error'.padLeft(15,' '), style: infoBrdSmall,),
            Text('Nick name', style: infoBrdSmall,),
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
              margin: EdgeInsets.only(top: 0, bottom: 1.5, left: 6.0, right: 3.0),
              width: infoBrdSmall.fontSize,
              height: infoBrdSmall.fontSize,
            ),
            Container(
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: baseYellow, width: 1.0),
                borderRadius: new BorderRadius.all(Radius.circular(1.0)),
              ),
              margin: EdgeInsets.only(top: 1.5, bottom: 0, left: 6.0, right: 3.0),
              width: infoBrdSmall.fontSize,
              height: infoBrdSmall.fontSize,
            ),
          ],
        ),
      ],
    ),
  );

}