import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/uiElements/animatons/fadeInAnim.dart';

import '../UIColors.dart';

Widget favItem(Station favStation, Size constraints) {
  final settingsTextStyle = TextStyle(
      fontSize: autoSizeOneLine(
          stringLength: 35, maxWidth: 18 * constraints.width / 25),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  return FadeIn(
    1.5,
    Container(
      height: settingsTextStyle.fontSize * 2,
      width: constraints.width,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {},
                onHover: (isHovering) {},
                child: Text(
                  "BUL. MIHAJLA PUPINA - POTHODNIK",
                  style: settingsTextStyle,
                ),
              ),
              new Spacer(),
              Center(
                child: InkWell(
                  onTap: () {
                    if(!selectedStations.contains(favStation)){
                      selectedStations.add(favStation);
                    }
                  },
                  onHover: (isHovering) {},
                  child: Container(
                      alignment: Alignment.center,

                      height: settingsTextStyle.fontSize * 1.8,
                      width: settingsTextStyle.fontSize * 1.8,
                      color: baseBlue,
                      child: Center(
                        child: Icon( Icons.login, size: settingsTextStyle.fontSize * 1.5, color: Colors.white,),
                      )
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

/*
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
* */
