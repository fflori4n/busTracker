import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/infoBoardItem/stationSign.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/loadStations.dart';

import '../UIColors.dart';
import '../filters.dart';
import '../main.dart';

class StationLabelWidget {
  BuildContext context;
  Station stationDisp;
  String stationNumber;
  String displayMsg = '';


  StationLabelWidget(Station dispThisStation, String stationNumber, [String displayMsg = '']) {
    this.context = context;
    this.stationDisp = dispThisStation;
    this.stationNumber = stationNumber;
    this.displayMsg = displayMsg;
  }

  Widget show() {
    double totalWidth = screenWidth;
    double totalHeight = 55 + (stationDisp.servedLines.length / 12) * 25.0;//screenHeight * 0.08;

    if(!isMobile){
      totalWidth = screenWidth * 0.3;
    }
    return Column(
      children: <Widget>[
        SizedBox(
            width: totalWidth,
            child: Stack(
              children: <Widget>[
                Container(
                  height: totalHeight + 3.0,
                  decoration: BoxDecoration(
                    color:  Color.fromRGBO(23, 67, 108, 1),
                  ),
                ),

                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      height: totalHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color.fromRGBO(0, 90, 152, 1),Color.fromRGBO(23, 67, 108, 1)]
                        ),
                        borderRadius: BorderRadius.only(
                          //topLeft: Radius.circular(totalHeight * 0.1),
                          bottomLeft: Radius.circular(totalHeight * 0.1),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                stationLetter(stationNumber),
                                Expanded(
                                  flex: 3,
                                  child: Text(stationDisp.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),// decoration: TextDecoration.lineThrough, decorationColor: Colors.red)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 2),
                                  child: FlatButton(
                                    onPressed: () {
                                      print('station number was' + selectedStations.indexOf(stationDisp).toString());
                                      selectedStations.remove(stationDisp);
                                      removeUnusedBusLines();
                                    },
                                    child: Icon(
                                      Icons.clear, //: Icon.place,
                                      color:Colors.white,
                                      size: screenWidth/100,
                                      semanticLabel: 'location',
                                    ),//stationX(),
                                  )
                                ),
                              ],
                            )
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10 + totalHeight * 0.4),
                              child: displayMsg == '' ? Container(
                                child: getStationLineLabels(stationDisp),
                              ) : Row( children: <Widget>[Text(displayMsg, style: infoBrdSmall, textAlign: TextAlign.left,),],),
                            ),
                          ),
                        ],
                      )
                    ),
              ],
            )
           ),
      ],
    );
  }
}

Widget getStationLineLabels(Station station) {
  List<Widget> rowList = [];
  List<Widget> labelList = [];
  int i=0;
  for(String line in station.servedLines){
    var newText = new GestureDetector(
      child: Text(
        line.padLeft(3),
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

    if(labelList.length > 24){
      rowList.add(Row( children: labelList));
      labelList = [];
    }
  }
  rowList.add(Row( children: labelList));
  return new Column(children: rowList, );
}

List<Widget> displaySelectedStations(){
  List<Widget> stationDispList = new List();

  if(selectedStations.length <= 0){
    stationDispList.add(new StationLabelWidget(new Station.byName(lbl_noSelected.print()), "0", lbl_clickMap.print()).show());
  }
  for(int i =0; i < selectedStations.length; i++){
    stationDispList.add(new StationLabelWidget(selectedStations[i], (i+1).toString()).show());
  }
  return stationDispList;
}
