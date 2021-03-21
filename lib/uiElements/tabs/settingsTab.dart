
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/location/locationTest.dart';
import 'package:mapTest/mapRelated/map.dart';

import '../UIColors.dart';
import '../../main.dart';


Widget showSettingsTab(){
  return Column(
    children: [
      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Container(),/*Row(
          children: <Widget>[
            Text(
              'language:',
              style: infoBrdSmall,
            ),
            Spacer(),
            /**/
            Container(
              child: Tooltip(
                message: 'Switch language',
                child: FlatButton(
                  onPressed: (){
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
                  child:Text(activeLang, style: infoBrdSmall,),
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Text(
              'city:',
              style: infoBrdSmall,
            ),
            Spacer(),
            Container(
                child: Tooltip(
                    message: busLineCityStr.contains('su') ? 'Switch to Novi Sad' : 'Switch to Subotica',
                    child: FlatButton(
                      onPressed: (){
                        // TODO: switch city
                      },
                      child: busLineCityStr.contains('su') ? Text('Subotica', style: infoBrdSmall,) : Text('Novi Sad', style: infoBrdSmall,),
                    )
                )
            )
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Text(
              'map style:',
              style: infoBrdSmall,
            ),
            Spacer(),
            Container(
              child: Tooltip(
                message: 'Switch map style',
                child: FlatButton(
                  onPressed: (){
                    activeMapTile++;
                    if(activeMapTile>5){
                      activeMapTile = 0;
                    }
                    mapTileSwitchController.add(activeMapTile);
                  },
                  child: Text(mapProviderNames[activeMapTile], style: infoBrdSmall,),
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
        ),*/
      ),
    ],
  );
}