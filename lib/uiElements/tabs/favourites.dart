
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapTest/loadModules/loadStations.dart';

import '../../main.dart';
import '../../onSelected.dart';
import '../UIColors.dart';

Widget showFavourites(Size constraints){

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
              height: settingsTextStyle.fontSize * 2,
              alignment: Alignment.centerLeft,
              width: 18 * constraints.width / 25,
              child: Text(
                'Save current as favourite:',
                style: settingsTextStyle,
              ),
            ),
            Expanded(
              child: Container(
                height: settingsTextStyle.fontSize* 1.3,
                alignment: Alignment.centerRight,
                child: Tooltip(
                  message: 'save as favourite',
                  child: TextButton(
                    onPressed: () {
                      print(selectedStations.toString());
                      String nickName = DateTime.now().toLocal().toString();
                      user.addFavourite(nickName, selectedStations);
                      user.dbgPrintFavourites();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: baseBlue,
                        borderRadius: new BorderRadius.all(Radius.circular(settingsTextStyle.fontSize* 0.2)),
                      ),
                      child: Text(
                        'Save!',
                        style: settingsTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: settingsTextStyle.fontSize * 1.5,
              alignment: Alignment.centerLeft,
              width: 18 * constraints.width / 25,
              child: Text(
                'load or remove favourites:',
                style: settingsTextStyle,
              ),
            ),
           ],
        ),
        Column(
          children: listFavourites(constraints),
        )
      ],
    ),
  );
}

List<Row> listFavourites(Size constraints){
  List<Row> rows = [];

  final settingsTextStyle = TextStyle(
      fontSize: autoSizeOneLine(
          stringLength: 35, maxWidth: 18 * constraints.width / 25),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  for(var favourite in user.favourites){
    Row newRow = Row(
      children: [
        Container(
          height: settingsTextStyle.fontSize * 2,
          alignment: Alignment.centerLeft,
          width: 21 * constraints.width / 25,
          child: Tooltip(
            message: 'select',
            child: TextButton(
              onPressed: () {
                selectedStations.clear();
                selectedStations = favourite.stations;
                onStationSelected();
              },
              child:Text(
            favourite.nickName,
            style: settingsTextStyle,
          ),),),
        ),
        Expanded(
          child: Container(
            height: settingsTextStyle.fontSize* 1.3,
            width: settingsTextStyle.fontSize* 1.3,
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: 'remove favourite',
              child: TextButton(
                onPressed: () {
                  // TODO : delete me
                  user.favourites.remove(favourite);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: baseBlue,
                    borderRadius: new BorderRadius.all(Radius.circular(settingsTextStyle.fontSize* 0.2)),
                  ),
                  child: Text(
                    'x',
                    style: settingsTextStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    rows.add(newRow);
  }
  return rows;
}