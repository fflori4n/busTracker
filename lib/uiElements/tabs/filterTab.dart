import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mapTest/dataClasses/multiLang.dart';

import '../UIColors.dart';
import '../../main.dart';

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
              'Vidljivost prošlih buseva:',
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
                value: busFilters.left,
                onToggle: (val1) {
                  busFilters.left = val1;
                  busFilters.refreshFlg = true;
                }),
          ],
        ),
      ),

      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Row(
          children: [
            Text(
              'Samo vidljivi, koje stižu za <15min:',
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
                value: !busFilters.eTAgt15mins,
                onToggle: (val1) {
                  busFilters.eTAgt15mins = !val1;                               //busFilters.next10only
                  busFilters.refreshFlg = true;
                }),
          ],
        ),
      ),

      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Row(
          children: [
            Text(
              'Samo vidljivi, naredna 10:',
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
                value: busFilters.next10only,
                onToggle: (val1) {
                  busFilters.next10only = val1;                               //
                  busFilters.refreshFlg = true;
                }),
          ],
        ),
      ),

      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Row(
          children: [
            Text(
              'Bus markers visible:',
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
                value: user.showBusMarkers,
                onToggle: (val1) {
                  user.showBusMarkers = val1;
                }),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Row(
          children: [
            Text(
              'Bus Eta on map visible:',
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
                value: user.showBusETAonMap,
                onToggle: (val1) {
                  user.showBusETAonMap = val1;
                }),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Row(
          children: [
            Text(
              'Bus lines visible:',
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
                value: user.showBusLinesMap,
                onToggle: (val1) {
                  user.showBusLinesMap = val1;
                }),
          ],
        ),
      ),
    ],
  );
}