import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mapTest/dataClasses/user.dart';
import 'package:mapTest/location/locationTest.dart';
import 'package:mapTest/uiElements/tabs/filterTab.dart';
import 'package:mapTest/uiElements/tabs/settingsTab.dart';

import 'UIColors.dart';
import '../main.dart';
import 'legacySchedule.dart';

Widget showTabs(BuildContext context, User user, double maxWidth) {
  double totalWidth = screenWidth;
  //double totalHeight = 60;//screenHeight * 0.08;

  if (user.tabOpen == 0) {
    return Container();
  }

  return SizedBox(
    width: totalWidth,
    child: Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color.fromRGBO(46, 46, 46, 1),
      ),
      child: getTab(context, user.tabOpen, maxWidth),
    ),
  );
}

Widget getTab(BuildContext context, int tabNum, double maxWidth) {
  if (tabNum == 1) {
    return Column(
      children: <Widget>[
        TextButton(
          onPressed: () {
            // TODO: implement
          },
          child: Container(
            margin: EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 5),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseBlue,
              borderRadius: new BorderRadius.all(Radius.circular(2.0)),
            ),
            child: Text(
              'Save current as favourite!',
              style: busDescrSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  } else if (tabNum == 2) {
    /// navigation
    return Container(
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
    );
  } else if (tabNum == 3) {
    /// settings
    return showSettingsTab();
  } else if (tabNum == 4) {/// #filters
    return showFilterTab();
  } else if (tabNum == 5) {/// red voznje
    return showSimpleSchedule(context, maxWidth);
  }
  return Column();
}
