import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mapTest/dataClasses/user.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/location/locationTest.dart';
import 'package:mapTest/uiElements/tabs/favourites.dart';
import 'package:mapTest/uiElements/tabs/filterTab.dart';
import 'package:mapTest/uiElements/tabs/navigationTab.dart';
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
    return showFavourites(Size(maxWidth,0));
  } else if (tabNum == 2) {
    /// navigation
    return showNavigationTab(Size(maxWidth,0));
  } else if (tabNum == 3) {
    /// settings
    return showSettingsTab(Size(maxWidth,0),context);
  } else if (tabNum == 4) {/// #filters
    return showFilterTab(Size(maxWidth,0));
  } else if (tabNum == 5) {/// red voznje
    return showSimpleSchedule(context, maxWidth);
  }
  return Column();
}
