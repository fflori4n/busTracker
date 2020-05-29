import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/main.dart';

import 'geometryFuncts.dart';

const Color mainBCG = Color.fromRGBO(20, 20, 20, 0.5);
const Color inactiveStationCol = Color.fromRGBO(20, 20, 20, 0.5);
const Color inactiveStationCol2 = Color.fromRGBO(80, 80, 80, 0.5);
const Color activeStationCol = Color.fromRGBO(45, 160, 230,0.8);

const Color baseYellow = Color.fromRGBO(255, 193, 36, 1);                       // #E6A825
const Color baseBlack = Color.fromRGBO(31, 31, 31,1);                           // #121314
const Color baseGray = Color(0xff3D3D3D);                                       // #3D3D3D
const Color baseWhite =  Color(0xffffffff);                                     // #C9C9C9
const Color baseBlue = Color(0xff195169);                                       // #195169
const Color baseLBlue= Color.fromRGBO(120, 156, 255, 1);                        // #5578BD

const Color buletinHeader= baseBlue;
const Color buletinBCG= baseGray;

double setSize(double devSize, {int devScreenwidth= 1366}){
  double newWidth = devSize * (screenWidth/devScreenwidth);

  print('screen:' + screenWidth.toString());
  print('in:' + devSize.toString() + ' out:' + newWidth.toString());
  print(devScreenwidth/screenWidth);
  return newWidth.toDouble();
}

TextStyle listText = TextStyle(
    fontSize: 15,

    fontWeight: FontWeight.bold,
    color: baseWhite,
    letterSpacing: 1.1
);
TextStyle legendText = TextStyle(
    fontSize: 12,

    fontWeight: FontWeight.bold,
    color: baseWhite,
    letterSpacing: 1.1
);

// info board style
TextStyle infoBrdLarge = TextStyle(
    fontSize: 15 * wScaleFactor,
    fontWeight: FontWeight.bold,
    color: baseWhite,
    letterSpacing: 1.1
);
TextStyle infoBrdYellow = TextStyle(
    fontSize: 15 * wScaleFactor,
    fontWeight: FontWeight.bold,
    color: baseYellow,
    letterSpacing: 1.1
);
TextStyle infoBrdSmall = TextStyle(
    fontSize: 10 * wScaleFactor,
    fontWeight: FontWeight.bold,
    color: baseWhite,
    letterSpacing: 1.1
);