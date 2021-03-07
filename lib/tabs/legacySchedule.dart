import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/loadModules/busLines.dart';

import '../UIColors.dart';

String selectedLine = '';

Widget showSimpleSchedule(double maxWidth) {
  if (selectedLine == '') {
    return lineChoser(maxWidth);
  }
  else {
    return showSelectedLine(maxWidth);
  }
}

Widget lineChoser(double maxWidth) {
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
    '13B'
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
          child: FlatButton(
            onPressed: () {
              selectedLine = name;
            },
            child: Center(
              child: Text(name, style: infoBrdSmallBold),
            ),
          )
      ),
    );
    busLineButtons.add(newBut);
  }

  for (int i = 0; i < busLineButtons.length; i += 9) {
    if ((i + 8) < busLineButtons.length) {
      rowList.add(Row(
        children: busLineButtons.sublist(i, i + 8),
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

Widget showSelectedLine(double maxWidth) {
  return Column(
    children: [
      Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
            margin: EdgeInsets.only(top: maxWidth / 90,
                bottom: maxWidth / 90,
                left: maxWidth / 90,
                right: maxWidth / 90),
            width: maxWidth / 12,
            height: maxWidth / 12,
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
                      size: maxWidth/22,
                    ),
                  ),
                )
            ),
          ),
           Container(
            padding: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
            margin: EdgeInsets.only(top: maxWidth / 90,
                bottom: maxWidth / 90,
                left: maxWidth / 90,
                right: maxWidth / 90),
            width: maxWidth / 12,
            height: maxWidth / 12,
            decoration: BoxDecoration(
              color: getLineColor(selectedLine),
              borderRadius: new BorderRadius.all(Radius.circular(2.0)),
            ),
            child: Center(
              child: Text(selectedLine, style: infoBrdSmallBold),
            ),
          ),
        ],
      )
    ],
  );
}