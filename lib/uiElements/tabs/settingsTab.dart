
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/location/locationTest.dart';
import 'package:mapTest/mapRelated/map.dart';

import '../UIColors.dart';
import '../../main.dart';

Widget showSettingsTab(Size constraints){

  final settingsTextStyle = TextStyle( //GoogleFonts.robotoCondensed
      fontSize: autoSizeOneLine(
          stringLength: 35,
          maxWidth: 18* constraints.width / 25),
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
                    child: Text('Language', style: settingsTextStyle,),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Tooltip(
                        message: 'Switch language:',
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
                        child:Text(activeLang, style: settingsTextStyle,),
                      ),
                    ),
                  ),)
                ],
              ),

              Row(
                children: [
                  Container(
                    height: settingsTextStyle.fontSize*1.5,
                    alignment: Alignment.centerLeft,
                    width: 12*constraints.width/50,
                    //color: Colors.green,
                    child: Text('City:', style: settingsTextStyle,),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Tooltip(
                        message: 'Switch city',
                        child: FlatButton(
                          onPressed: (){
                            // TODO: switch city
                          },
                          child: busLineCityStr.contains('su') ? Text('Subotica', style: settingsTextStyle,) : Text('Novi Sad', style: settingsTextStyle,),
                        ),
                      ),
                    ),)
                ],
              ),

              Row(
                children: [
                  Container(
                    height: settingsTextStyle.fontSize*1.5,
                    alignment: Alignment.centerLeft,
                    width: 12*constraints.width/25,
                    //color: Colors.green,
                    child: Text('Map style:', style: settingsTextStyle,),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
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
                          child: Text(mapProviderNames[activeMapTile], style: settingsTextStyle,),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              Row(
                children: [
                  Container(
                    height: settingsTextStyle.fontSize*1.5,
                    alignment: Alignment.centerLeft,
                    width: 20*constraints.width/25,
                    child: Text('Location:', style: settingsTextStyle,),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Tooltip(
                        message: 'toggle location',
                        child: FlutterSwitch(
                            width: settingsTextStyle.fontSize * 2 * 1.3,
                            height: settingsTextStyle.fontSize * 1.3,
                            toggleSize: settingsTextStyle.fontSize * 0.7 * 1.3,
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
                    ),
                  )
                ],
              ),

              Row(
                children: [
                  Container(
                    height: settingsTextStyle.fontSize*1.5,
                    alignment: Alignment.centerLeft,
                    width: 20*constraints.width/25,
                    child: Text('Cookies enabled:', style: settingsTextStyle,),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Tooltip(
                        message: 'toggle cookies',
                        child: FlutterSwitch(
                            width: settingsTextStyle.fontSize * 2 * 1.3,
                            height: settingsTextStyle.fontSize * 1.3,
                            toggleSize: settingsTextStyle.fontSize * 0.7 * 1.3,
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
                      'Bus markers visible:',
                      style: settingsTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Tooltip(
                        message: 'toggle',
                        child: FlutterSwitch(
                            width: settingsTextStyle.fontSize * 2 * 1.3,
                            height: settingsTextStyle.fontSize * 1.3,
                            toggleSize: settingsTextStyle.fontSize * 0.7 * 1.3,
                            activeColor: switchActive,
                            inactiveColor: switchInactive,
                            toggleColor: switchToggle,
                            value: user.showBusMarkers,
                            onToggle: (val1) {
                              user.showBusMarkers = val1;
                            }),
                      ),
                    ),
                  )
                ],
              ),
              ///
              Row(
                children: [
                  Container(
                    height: settingsTextStyle.fontSize * 1.5,
                    alignment: Alignment.centerLeft,
                    width: 20 * constraints.width / 25,
                    child: Text(
                      'Bus Eta on map visible:',
                      style: settingsTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Tooltip(
                        message: 'toggle',
                        child: FlutterSwitch(
                            width: settingsTextStyle.fontSize * 2 * 1.3,
                            height: settingsTextStyle.fontSize * 1.3,
                            toggleSize: settingsTextStyle.fontSize * 0.7 * 1.3,
                            activeColor: switchActive,
                            inactiveColor: switchInactive,
                            toggleColor: switchToggle,
                            value: user.showBusETAonMap,
                            onToggle: (val1) {
                              user.showBusETAonMap = val1;
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
                      'Bus lines visible:',
                      style: settingsTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Tooltip(
                        message: 'toggle',
                        child: FlutterSwitch(
                            width: settingsTextStyle.fontSize * 2 * 1.3,
                            height: settingsTextStyle.fontSize * 1.3,
                            toggleSize: settingsTextStyle.fontSize * 0.7 * 1.3,
                            activeColor: switchActive,
                            inactiveColor: switchInactive,
                            toggleColor: switchToggle,
                            value: user.showBusLinesMap,
                            onToggle: (val1) {
                              user.showBusLinesMap = val1;
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
