import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/dataClasses/user.dart';
import 'package:mapTest/infoBoardItem/indicator.dart';
import 'package:mapTest/location/locationTest.dart';

import '../UIColors.dart';
import '../main.dart';

Widget showTabs(User user) {
  double totalWidth = screenWidth;
  //double totalHeight = 60;//screenHeight * 0.08;

  if (user.tabOpen == 0) {
    return Container();
  }

  return SizedBox(
    width: totalWidth,
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(46, 46, 46, 1),
      ),
      child: getTab(user.tabOpen),
    ),
  );
}

Widget getTab(int tabNum) {
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: GestureDetector(
              onTap: () {
                final List<String> languages = [
                  'srb',
                  'eng',
                  'hun'
                ]; // TODO: use array instead of string
                int i = languages.indexOf(activeLang);
                if (i < languages.length - 1)
                  i++;
                else
                  i = 0;

                activeLang = languages[i];
              },
              child: Row(
                children: <Widget>[
                  Text(
                    'language:',
                    style: infoBrdSmall,
                  ),
                  Spacer(),
                  Text(
                    activeLang,
                    style: infoBrdSmall,
                  ),
                ],
              )),
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: GestureDetector(
              onTap: () {
               /* if(busLineCityStr.contains('su')){
                  router('ns');
                }
                else if(busLineCityStr.contains('ns')){
                  router('su');
                }*/ // TODO: this not working brah...
              },
              child: Row(
                children: <Widget>[
                  Text(
                    'city:',
                    style: infoBrdSmall,
                  ),
                  Spacer(),
                  busLineCityStr.contains('su') ? Text('Subotica', style: infoBrdSmall,) : Text('Novi Sad', style: infoBrdSmall,),
                ],
              )),
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Row(
            children: [
              Text(
                'device location:',
                style: infoBrdSmall,
              ),
              Spacer(),
              FlutterSwitch(
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
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Row(
            children: [
              Text(
                'cookies enabled:',
                style: infoBrdSmall,
              ),
              Spacer(),
              FlutterSwitch(
                  width: infoBrdSmall.fontSize * 2 * 1.3,
                  height: infoBrdSmall.fontSize * 1.3,
                  toggleSize: infoBrdSmall.fontSize * 0.7 * 1.3,
                  activeColor: switchActive,
                  inactiveColor: switchInactive,
                  toggleColor: switchToggle,
                  value: user.cookiesEnabled,
                  onToggle: (val1) {
                    user.cookiesEnabled = val1;
                    /*if (user.locationEnabled) {
                      user.cookiesEnabled = !user.cookiesEnabled;
                    }*/
                  }),
            ],
          ),
        ),
      ],
    );
  } else if (tabNum == 4) {
    /// #filters
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: GestureDetector(
            onTap: () {
              busFilters.hideLine.clear();
            },
            child: Row(
              children: <Widget>[
                Text(
                  lbl_filt_hiddenLines.print(),
                  style: infoBrdSmall,
                ),
                Spacer(),
                Text(
                  busFilters.hideLine.toString(),
                  style: infoBrdSmall,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: GestureDetector(
              onTap: () {
                busFilters.left = !busFilters.left;
                busFilters.refreshFlg = true;
              },
              child: Row(
                children: <Widget>[
                  Text(
                    lbl_filt_leftBuses.print(),
                    style: infoBrdSmall,
                  ),
                  Spacer(),
                  Container(
                    child: indicator(baseBlue, baseYellow,
                        Color.fromRGBO(46, 46, 46, 1), !busFilters.left),
                    height: infoBrdSmall.fontSize,
                  ),
                ],
              )),
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: GestureDetector(
              onTap: () {
                busFilters.eTAgt15mins = !busFilters.eTAgt15mins;
                busFilters.refreshFlg = true;
              },
              child: Row(
                children: <Widget>[
                  Text(
                    lbl_filt_eta1.print(),
                    style: infoBrdSmall,
                  ),
                  Spacer(),
                  Container(
                    child: indicator(baseBlue, baseYellow,
                        Color.fromRGBO(46, 46, 46, 1), busFilters.eTAgt15mins),
                    height: infoBrdSmall.fontSize,
                  ),
                ],
              )),
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: GestureDetector(
              onTap: () {
                busFilters.next10only = !busFilters.next10only;
                busFilters.refreshFlg = true;
              },
              child: Row(
                children: <Widget>[
                  Text(
                    lbl_filt_onlyFirst10.print(),
                    style: infoBrdSmall,
                  ),
                  Spacer(),
                  Container(
                    child: indicator(baseBlue, baseYellow,
                        Color.fromRGBO(46, 46, 46, 1), !busFilters.next10only),
                    height: infoBrdSmall.fontSize,
                  ),
                ],
              )),
        ),
      ],
    );
  } else if (tabNum == 5) {
    /// red voznje
    return Column();
  }
  return Column();
}
