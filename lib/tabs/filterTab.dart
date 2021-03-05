import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mapTest/dataClasses/multiLang.dart';

import '../UIColors.dart';
import '../main.dart';

Widget showFilterTab(){
  return Column(
    children: [
      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Text(
              lbl_filt_hiddenLines.print(),
              style: infoBrdSmall,
            ),
            Spacer(),
            /**/
            Container(
              child: Tooltip(
                message: lbl_filt_hiddenLines.print(),
                child: FlatButton(
                  onPressed: (){
                    busFilters.hideLine.clear();
                  },
                  child:Text(busFilters.hideLine.toString(), style: infoBrdSmall,),
                ),
              ),
            ),
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
}