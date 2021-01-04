import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/loadModules/stations.dart';

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
    double totalHeight = 60;//screenHeight * 0.08;

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
                  height: totalHeight,
                  decoration: BoxDecoration(
                    color:  Color.fromRGBO(23, 67, 108, 1),
                  ),
                ),

                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      height: totalHeight * 0.96,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color.fromRGBO(0, 90, 152, 1),Color.fromRGBO(23, 67, 108, 1)]
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(totalHeight * 0.1),
                          bottomLeft: Radius.circular(totalHeight * 0.1),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                stationNumber == "0" ? Container(
                                  width: totalHeight * 0.3,
                                  child: Text(" "),                             // oh yeah.. very nice. good job me!
                                ) : Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  width: totalHeight * 0.3,
                                  height: totalHeight * 0.3,
                                  child: Center(child:Text(stationNumber, style: GoogleFonts.ptMono(color: Colors.white),))//TextStyle(color: Colors.white, fontFamily: ),)),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(stationDisp.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),// decoration: TextDecoration.lineThrough, decorationColor: Colors.red)),
                                ),
                                stationNumber == "0" ? Container() : GestureDetector(
                                  onTap: () {
                                    selectedStations.remove(stationDisp);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(totalHeight * 0.05),),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0,
                                      ),
                                    ),
                                    width: totalHeight * 0.3,
                                    height: totalHeight * 0.3,
                                    child: Center(child:Text("x", style: TextStyle(color: Colors.white),)),
                                  ),
                                )
                              ],
                            )
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10 + totalHeight * 0.4),
                              child: displayMsg == '' ? Row(
                                children: getStationLineLabels(stationDisp),
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

List<Widget> getStationLineLabels(Station station) {
  List<Widget> labelList = new List();
  //for (var line in activeStation.servedLines) {
  for (var line in station.servedLines) {
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

List<Widget> displaySelectedStations(){
  List<Widget> stationDispList = new List();

  if(selectedStations.length <= 1){
    stationDispList.add(new StationLabelWidget(new Station.byName(lbl_noSelected.print()), "0", lbl_clickMap.print()).show());
  }
  for(int i =1; i < selectedStations.length; i++){
    stationDispList.add(new StationLabelWidget(selectedStations[i], i.toString()).show());
  }
  return stationDispList;
}
