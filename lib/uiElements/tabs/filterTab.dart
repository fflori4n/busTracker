import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../UIColors.dart';
import '../../main.dart';

Widget showFilterTab(Size constraints) {
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
              height: settingsTextStyle.fontSize*1.5,
              alignment: Alignment.centerLeft,
              width: 12*constraints.width/50,
              //color: Colors.green,
              child: Text('Sakrivene linije:', style: settingsTextStyle,),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Tooltip(
                  message: 'obrisi sve',
                  child: FlatButton(
                    onPressed: (){
                      busFilters.hideLine.clear();
                      busFilters.refreshFlg = true;
                    },
                    child: Text(busFilters.hideLine.toString(), style: settingsTextStyle,),
                  ),
                ),
              ),)
          ],
        ),
        Row(
          children: [
            Container(
              height: settingsTextStyle.fontSize * 1.5,
              alignment: Alignment.centerLeft,
              width: 20 * constraints.width / 25,
              child: Text(
                'Vidljivost prošlih buseva:',
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
                      value: busFilters.left,
                      onToggle: (val1) {
                        busFilters.left = val1;
                        busFilters.refreshFlg = true;
                      }),
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              height: settingsTextStyle.fontSize * 1.5,
              alignment: Alignment.centerLeft,
              width: 20 * constraints.width / 25,
              child: Text(
                'Samo vidljivi, koje stižu za <15min:',
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
                      value: !busFilters.eTAgt15mins,
                      onToggle: (val1) {
                        busFilters.eTAgt15mins = !val1; //busFilters.next10only
                        busFilters.refreshFlg = true;
                      }),
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              height: settingsTextStyle.fontSize * 1.5,
              alignment: Alignment.centerLeft,
              width: 20 * constraints.width / 25,
              child: Text(
                'Samo vidljivi, naredna 10:',
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
                      value: busFilters.next10only,
                      onToggle: (val1) {
                        busFilters.next10only = val1; //
                        busFilters.refreshFlg = true;
                      }),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
}