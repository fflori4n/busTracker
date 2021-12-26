
import 'dart:js';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/loadStations.dart';

import '../../main.dart';
import '../../onSelected.dart';
import '../UIColors.dart';
import 'favouriteItem.dart';

Widget showFavourites(Size constraints){

  final settingsTextStyle = TextStyle(
      fontSize: autoSizeOneLine(
          stringLength: 35, maxWidth: 18 * constraints.width / 25),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: constraints.width / 20),
    width: constraints.width,
    child: Column(
      children: [
        favItem(new Station.empty(), constraints),
        favItem(new Station.empty(), constraints),
        favItem(new Station.empty(), constraints),
      ],
    ),
  );
}

/*List<Row> listFavourites(Size constraints){
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
}*/