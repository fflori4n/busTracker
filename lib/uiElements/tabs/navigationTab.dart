


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mapTest/location/locationTest.dart';

import '../../main.dart';
import '../UIColors.dart';

Widget showNavigationTab(Size constraints) {
  final settingsTextStyle = TextStyle(
      fontSize: autoSizeOneLine(
          stringLength: 35, maxWidth: 18 * constraints.width / 25),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: constraints.width / 25),
    width: constraints.width,
    child: Column(
      children: [
        Row(
          children: [
            Container(
              height: settingsTextStyle.fontSize * 1.5,
              alignment: Alignment.centerLeft,
              width: 20 * constraints.width / 25,
              child: Text(
                'device location:',
                style: settingsTextStyle,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Tooltip(
                  message: 'toggle filter',
                  child: FlutterSwitch(
                      width: settingsTextStyle.fontSize * 2 * 1.3,
                      height: settingsTextStyle.fontSize * 1.3,
                      toggleSize: settingsTextStyle.fontSize * 0.7 * 1.3,
                      activeColor: switchActive,
                      inactiveColor: switchInactive,
                      toggleColor: switchToggle,
                      value: user.locationEnabled,
                      onToggle: (val) {
                        user.locationEnabled = val;
                        if (user.locationEnabled) {
                          updatePos();
                        }
                      },
                ),
              ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
/*Container(
margin: EdgeInsets.all(5),
child: Column(
children: <Widget>[
Row(
children: [
Text(
'device location:',
style: infoBrdSmall,
),
Spacer(),
Container(
margin: EdgeInsets.all(5),
child: FlutterSwitch(
width: infoBrdSmall.fontSize * 2 * 1.3,
height: infoBrdSmall.fontSize * 1.3,
toggleSize: infoBrdSmall.fontSize * 0.7 * 1.3,
activeColor: switchActive,
inactiveColor: switchInactive,
toggleColor: switchToggle,
value: user.locationEnabled,
onToggle: (val) {
user.locationEnabled = val;
if (user.locationEnabled) {
updatePos();
}
}),
),
],
),
],
),
);*/