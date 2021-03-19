import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/uiElements/UIColors.dart';

import '../main.dart';

class StatusBar extends StatefulWidget {
  _statusBarState createState() => _statusBarState();
}
class _statusBarState extends State<StatusBar> {
  String _dispString;
  String _spinner;
  String _spinner2;
  Timer _everySecond;

  @override
  void initState() {
    super.initState();
    // sets first value
    // ⠤⠶⠿⣀⣤⣶⣿⠿⠛⠉
    //final String animString = '⡿⣟⣯⣷⣾⣽⣻⢿';
    //⣿⣯⣯⣯⣿⣿⠿⠿⠿⠛⠛⠉

    /*
    ⣀
    ⣤
    ⣶
    ⣿
    ⠿⣀
    ⠛⣤
    ⠛⡤
    */
    final String animString =  '⣀⣤⣶⣶⣿⣿⣿⠿⠿⠿⠿⠛⠛⠛⠛⠛⠛⠉    ';
    final String animString2 = '       ⣀⣀⣀⣀⣤⣤⡤⣤⡤⣤⣶⣿⠿⠛⠉';
    // '⢿⠿⠿⡿
    _dispString = user.progStatusString;
    int frameInd = 0;
    // defines a timer
    _everySecond = Timer.periodic(Duration(milliseconds: 200), (Timer t) { // 80 for DBG
      setState(() {
        try{
          if(frameInd >= animString.length){frameInd = 0;}
          _dispString = user.progStatusString;
          _spinner = animString[frameInd];
          _spinner2 = animString2[frameInd];
          frameInd++;
        }
        catch(r){
          return;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 6.0, left:6.0, right:6.0, bottom:0.0),
      height: 28 * hScaleFactor,
      width: isMobile ? screenWidth : 370 * wScaleFactor,  //350
      decoration: BoxDecoration(
        color: baseWhite,
        borderRadius: new BorderRadius.all(Radius.circular(2.0)),
      ),
      child: Row(
        children: <Widget>[
          Text('$_dispString'),
          Expanded(child: SizedBox()),
          Container(
            child: Row(
              children: <Widget>[
                RotatedBox(
                  quarterTurns: 1,
                  child: Text('$_spinner', style: TextStyle( color: Colors.black,),),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text('$_spinner2', style: TextStyle( color: Colors.black),),
                ),
              ],
            ),
            padding:  EdgeInsets.only(bottom: 4.0),
          )
        ],
      )
    );
  }
}