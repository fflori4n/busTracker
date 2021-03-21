import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/loadStations.dart';

import 'UIColors.dart';
import '../filters.dart';
import '../main.dart';
import 'arrivalsBrd/stationSign.dart';

class StationLabelWidget {
  BuildContext context;
  Station stationDisp;
  String stationNumber;
  String displayMsg = '';
  Size constraints;

  StationLabelWidget(Station dispThisStation, String stationNumber, this.constraints, [String displayMsg = '']) {
    this.context = context;
    this.stationDisp = dispThisStation;
    this.stationNumber = stationNumber;
    this.displayMsg = displayMsg;
  }

  Widget show() {
    double totalWidth = constraints.width;
    double totalHeight = totalWidth * 0.15;

    return Column(
      children: <Widget>[
        Container(
          height: totalHeight,
          width: totalWidth + 10,
          decoration: BoxDecoration(
            color: infoDispDarkBlue,
          ),
          child: Container(
              padding: EdgeInsets.only(top: totalHeight * 0.01),
              alignment: Alignment.topLeft,
              height: totalHeight * 0.90,
              width: totalWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [infoDispLiteBlue, infoDispDarkBlue]),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(totalHeight * 0.2),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: totalWidth*0.1,
                        child: stationLetter(8,stationNumber),
                      ),
                      Container(
                        width: totalWidth*0.8,
                        child: Text(stationDisp.name, style: stationDisplay),
                      ),
                      Container(
                          width: totalWidth*0.1,
                          child: FlatButton(
                            onPressed: () {
                              selectedStations.remove(stationDisp);
                              removeUnusedBusLines();
                            },
                            child: Icon(
                              Icons.clear, //: Icon.place,
                              color: Colors.white,
                              size:  totalWidth*0.05,
                            ), //stationX(),
                          )),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: totalWidth*0.1),
                      child: displayMsg == ''
                          ? Container(
                              child: getStationLineLabels(stationDisp),
                            )
                          : Row(
                              children: <Widget>[
                                Text(
                                  displayMsg,
                                  style: infoBrdSmall,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                    ),
                ],
              )),
        ),
      ],
    );
  }
}

Widget getStationLineLabels(Station station) {
  List<Widget> rowList = [];
  List<Widget> labelList = [];
  int i = 0;
  for (String line in station.servedLines) {
    var newText = new GestureDetector(
      child: Text(
        line.padLeft(3),
        style: nsBusLinesContainsName(line)
            ? (busFilters.hideLine.contains(line)
                ? infoBrdSmallCrossedOut
                : infoBrdSmall)
            : infoBrdSmallSemiTransp,
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
    labelList.add(Text(
      ' ',
      style: infoBrdSmall,
    ));

    if (labelList.length > 24) {
      rowList.add(Row(children: labelList));
      labelList = [];
    }
  }
  rowList.add(Row(children: labelList));
  return new Column(
    children: rowList,
  );
}

List<Widget> displaySelectedStations(Size constraints) {
  List<Widget> stationDispList = new List();

  if (selectedStations.length <= 0) {
    stationDispList.add(new StationLabelWidget(
            new Station.byName(lbl_noSelected.print()),
            "0",
            constraints,
            lbl_clickMap.print())
        .show());
  }
  for (int i = 0; i < selectedStations.length; i++) {
    stationDispList.add(new StationLabelWidget(
            selectedStations[i], (i + 1).toString(), constraints)
        .show());
  }
  return stationDispList;
}
