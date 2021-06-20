import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/uiElements/mobileOnlyElements/mobileUI.dart';

import '../UIColors.dart';
import '../../filters.dart';
import '../../main.dart';
import 'stationSign.dart';

class StationLabelWidget {
  BuildContext context;
  Station stationDisp;
  String stationNumber;
  String displayMsg = '';
  Size constraints;
  TextStyle stationNameStyle;

  double spaceUnit;
  bool clickable = false;

  StationLabelWidget(Station dispThisStation, String stationNumber, this.constraints, this.clickable, [String displayMsg = '']) {
    this.context = context;
    this.stationDisp = dispThisStation;
    this.stationNumber = stationNumber;
    this.displayMsg = displayMsg;

    stationNameStyle = TextStyle( //GoogleFonts.robotoCondensed
    fontSize: autoSizeOneLine(
    stringLength: 30,
    maxWidth: 16* constraints.width / 25),
    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1);

    this.spaceUnit = constraints.width / 25;
  }

  Widget show() {
    double totalWidth = constraints.width;
    double totalHeight = constraints.width * 0.15;
    final double overFlowHeight = stationNameStyle.fontSize * (stationDisp.servedLines.length~/13).toDouble();

    return Container(
      child: Stack(
        children: [
          Container(
            height: totalHeight + overFlowHeight,
            width: totalWidth,
            color: infoDispDarkBlue,
          ),
          Container(
            alignment: Alignment.topCenter,
            height: (totalHeight * 0.94) + overFlowHeight,
            width: totalWidth,
            padding: EdgeInsets.symmetric(vertical: 0.5 * spaceUnit, horizontal: 0.5 * spaceUnit),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [infoDispLiteBlue, infoDispDarkBlue]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(totalHeight * 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    clickable ? Container() : Container(
                      alignment: Alignment.centerLeft,
                      width: 1.5* spaceUnit,
                      height: stationNameStyle.fontSize * 2,
                      child: stationLetter(stationNameStyle.fontSize ,stationNumber),
                    ),
                    clickable ? FlatButton(
                      onPressed: () {
                        isScheduleView = false;
                        redrawMobLayoutController.add(1); // write to stream, flag for update
                      },
                      child: Container(
                        width: 20.5* spaceUnit,
                        alignment: Alignment.centerLeft,
                        child:  Text(stationDisp.name, style: stationNameStyle),
                      ),
                    ) : Container(
                        width: 20.5* spaceUnit,
                        alignment: Alignment.centerLeft,
                        child:  Text(stationDisp.name, style: stationNameStyle),
                    ),
                    clickable ? Container() : Container(
                      alignment: Alignment.center,
                      width: 2* spaceUnit,
                      child: FlatButton(
                        onPressed: () {
                          selectedStations.remove(stationDisp);
                          removeUnusedBusLines();
                        },
                        child: Icon(
                          Icons.clear, //: Icon.place,
                          color: Colors.white,
                          size: spaceUnit,
                        ), //stationX(),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.5 * spaceUnit),
                  child: displayMsg == ''
                      ? Container(
                    child: getStationLineLabels(stationDisp, stationNameStyle.fontSize),
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
            )
          ),
        ],
      ),
    );
  }
}

Widget getStationLineLabels(Station station, double fontSize) {
  List<Widget> rowList = [];
  List<Widget> labelList = [];

  final infoBrdLines =  GoogleFonts.robotoCondensed(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1
  );
  final infoBrdLinesCrossed =  GoogleFonts.robotoCondensed(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1,
      decoration: TextDecoration.lineThrough,
      decorationColor: Color.fromRGBO(16, 16, 19, 1),
  );
  final infoBrdLinesFaint =  GoogleFonts.robotoCondensed(
      fontSize: 0.98 * fontSize,
      fontWeight: FontWeight.normal,
      color: baseWhite.withOpacity(0.5),
      letterSpacing: 1.1
  );

  for (String line in station.servedLines) {
    var newText = new GestureDetector(
      child: Text(
        line.padLeft(3),
        style: nsBusLinesContainsName(line)
            ? (busFilters.hideLine.contains(line)
                ? infoBrdLinesCrossed
                : infoBrdLines)
            : infoBrdLinesFaint,
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
    labelList.add(Text(' ', style: infoBrdLines,));

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
            true,
            lbl_clickMap.print(),
            )
        .show());
  }
  for (int i = 0; i < selectedStations.length; i++) {
    stationDispList.add(new StationLabelWidget(
            selectedStations[i], (i + 1).toString(), constraints, false)
        .show());
  }
  return stationDispList;
}
