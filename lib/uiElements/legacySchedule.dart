import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/uiElements/scheduleDisplay.dart';

import 'UIColors.dart';
import '../main.dart';

String selectedLine = '';
bool isDescLoaded = false;
String dispLineDescr = '';

// tabopen == 5 && selectedLine.notEmpty()
Widget showSimpleSchedule(BuildContext context, double maxWidth) {
  if (selectedLine == '') {
    return lineChoser(maxWidth);
  }
  else {
    return showSelectedLine(context, maxWidth);
  }
}

Widget lineChoser(double maxWidth) {
  maxWidth*= 0.85;
  List<String> lineNames = [
    '1A',
    '1B',
    '2A',
    '2B',
    '3A',
    '3AA',
    '3AB',
    '3B',
    '3BA',
    '3BB',
    '4A',
    '4B',
    '5A',
    '5B',
    '6A',
    '6B',
    '7A',
    '7B',
    '8A',
    '8B',
    '9A',
    '9B',
    '10A',
    '10B',
    '11A',
    '11B',
    '12A',
    '12B',
    '13A',
    '13B',
    '14A',
    '14B',
    '15A',
    '15B',
    '16A',
    '16B',
    '17A',
    '17B',
    '18A',
    '18B',
    '20A',
    '20B',
    '60A',
    '60B',
    '64A',
    '64B',
    '72A',
    '72B',
    '74A',
    '74B',
    '76A',
    '76B'
  ];
  List<Widget> busLineButtons = [];
  List<Widget> rowList = [];

  for (String name in lineNames) {
    Container newBut = Container(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
      margin: EdgeInsets.only(top: maxWidth / 90,
          bottom: maxWidth / 90,
          left: maxWidth / 90,
          right: maxWidth / 90),
      width: maxWidth / 10,
      height: maxWidth / 10,
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
                loadDescription(name, busLineCityStr);
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
                child: Text(name, style: infoBrdSmallBold),
              ),
            )
          ),
      ),
    );
    busLineButtons.add(newBut);
  }

  for (int i = 0; i < busLineButtons.length; i += 9) {
    if ((i + 9) < busLineButtons.length) {
      rowList.add(Row(
        children: busLineButtons.sublist(i, i + 9),
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
  loadDescription(selectedLine, busLineCityStr);
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
                child: Center(child: Text(selectedLine, style: infoBrdSmallBold),),
            )
          ),
          isDescLoaded ? Text(dispLineDescr, style: infoBrdSmall,) : Text(dispLineDescr, style: infoBrdSmall,),
        ],
      ),
      showSchedule(context, maxWidth, selectedLine),
    ],
  );
}
