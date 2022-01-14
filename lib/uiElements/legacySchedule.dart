import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/uiElements/scheduleDisplay.dart';

import 'UIColors.dart';
import '../main.dart';

String selectedLine = '';
bool isDescLoaded = false;
String dispLineDescr = '';

Widget showSimpleSchedule(BuildContext context, double maxWidth) {
  if (selectedLine == '') {
    return lineChoser(maxWidth);
  }
  else {
    return showSelectedLine(context, maxWidth);
  }
}

Widget lineChoser(double maxWidth) {

  final int linesInRow = 8;
  final double paddingWidth = maxWidth*0.85/50;
  final double buttonWidth = (maxWidth*0.85 - (linesInRow+ 1)) / (linesInRow);

  final TextStyle scheduleBtnStyle = GoogleFonts.robotoCondensed(
      fontSize: autoSizeOneLine(
          stringLength: 5,
          maxWidth: buttonWidth),
      fontWeight: FontWeight.bold,
      color: baseWhite,
      letterSpacing: 1.1);

  List<String> lineNames = [];
  if(user.cityString == "novi_sad"){
    lineNames = [
      '1A', '1B', '2A', '2B', '3A', '3AA', '3AB', '3B', '3BA', '3BB', '4A', '4B', '5A','5B','6A','6B','7A','7B','8A','8B','9A','9B','10A','10B',
      '11A', '11B', '12A', '12B', '13A', '13B', '14A', '14B', '15A', '15B', '16A', '16B', '17A', '17B', '18A', '18B', '20A', '20B', '60A', '60B', '64A', '64B', '72A', '72B', '74A', '74B', '76A', '76B'
    ];
  }
  else if(user.cityString == "subotica"){
    lineNames = [
      '1A', '1AR', '2', '2R', '3', '3R', '4', '4R', '6', '6R', '7', '7R', '8', '8R', '8A', '8AR', '9', '9R', '10', '10R', '16', '16R'
    ];
  }
  List<Widget> busLineButtons = [];
  List<Widget> rowList = [];

  for (String name in lineNames) {
    Container newBut = Container(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
      margin: EdgeInsets.only(top: paddingWidth,
          //bottom: paddingWidth,
          left: paddingWidth,),
          //right: paddingWidth),
      width: buttonWidth,
      height: buttonWidth,
      decoration: BoxDecoration(
        color: getLineColor(name),
        borderRadius: new BorderRadius.all(Radius.circular(2.0)),
      ),
      child: Tooltip(
          message: name,
          child: InkWell(
            onTap: (){},
            onHover: (isHovering){
              if(isHovering){
                loadDescription(name, user.busLinesFile);
              }
              else{
                scheduleTabLines.clear();
              }
            },
            child: FlatButton(
              onPressed: () {
                selectedLine = name;
              },
              child: Center(
                child: Text(name, style: scheduleBtnStyle),
              ),
            )
          ),
      ),
    );
    busLineButtons.add(newBut);
  }

  for (int i = 0; i < busLineButtons.length; i += linesInRow ) {
    if ((i + linesInRow ) < busLineButtons.length) {
      rowList.add(Row(
        children: busLineButtons.sublist(i, i + linesInRow ),
      ));
    }
    else {
      rowList.add(Row(
        children: busLineButtons.sublist(i, busLineButtons.length),
      ));
    }
  }

  return Container(
    padding: EdgeInsets.all(maxWidth / 90),
    child: Center(
      child: Column(
        children: rowList,
      ),
    ),
  );
}

Widget showSelectedLine(BuildContext context, double maxWidth) {
  isDescLoaded = false;
  loadDescription(selectedLine, user.busLinesFile);
  maxWidth*= 0.85;
  return Column(
    children: [
      Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
            margin: EdgeInsets.only(left: maxWidth / 50, top: maxWidth/50, bottom: maxWidth/50),
            width: maxWidth / 10,
            height: maxWidth / 10,
            decoration: BoxDecoration(
              color: getLineColor(selectedLine),
              borderRadius: new BorderRadius.all(Radius.circular(2.0)),
            ),
            child: Tooltip(
                message: 'back',
                child: FlatButton(
                  onPressed: () {
                    selectedLine='';
                  },
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: maxWidth/20,
                    ),
                  ),
                )
            ),
          ),
           Container(
            padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
            margin: EdgeInsets.only(left: maxWidth/50, right: maxWidth/50, top: maxWidth/50, bottom: maxWidth/50),
            width: maxWidth / 10,
            height: maxWidth / 10,
            decoration: BoxDecoration(
              color: getLineColor(selectedLine),
              borderRadius: new BorderRadius.all(Radius.circular(2.0)),
            ),
            child: SizedBox(
                width: maxWidth/20,
                height: maxWidth/20,
                child: Center(child: Text(selectedLine),),
            )
          ),
          isDescLoaded ? Text(dispLineDescr,) : Text(dispLineDescr,),
        ],
      ),
      showSchedule(context, maxWidth, selectedLine),
    ],
  );
}
