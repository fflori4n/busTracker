import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/main.dart';

import 'geometryFuncts.dart';

const Color mainBCG = Color.fromRGBO(20, 20, 20, 0.5);
const Color inactiveStationCol = Color.fromRGBO(20, 20, 20, 0.5);
const Color inactiveStationCol2 = Color.fromRGBO(80, 80, 80, 0.5);
const Color activeStationCol = Color.fromRGBO(45, 160, 230,0.8);

const Color baseYellow = Color(0xFFE6A825);                                     // #E6A825
const Color baseBlack = Color(0xff121314);                                      // #121314
const Color baseGray = Color(0xff3D3D3D);                                       // #3D3D3D
const Color baseWhite =  Color(0xffffffff);                                     // #C9C9C9
const Color baseBlue = Color(0xff195169);                                       // #195169
const Color baseLBlue= Color.fromRGBO(120, 156, 255, 1);                        // #5578BD

const Color ligthBlack = Color(0xff202015);

const Color buletinHeader= baseBlack;
const Color buletinBCG= baseGray;

double setSize(double devSize, {int devScreenwidth= 1366}){
  double newWidth = devSize * (screenWidth/devScreenwidth);

  print('screen:' + screenWidth.toString());
  print('in:' + devSize.toString() + ' out:' + newWidth.toString());
  print(devScreenwidth/screenWidth);
  return newWidth.toDouble();
}

TextStyle listText =  GoogleFonts.robotoCondensed(
    fontSize: 15,

    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1
);
TextStyle legendText =  GoogleFonts.robotoCondensed(
    fontSize: 12,

    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1
);

// info board style
TextStyle infoBrdLarge =  GoogleFonts.robotoCondensed(
    fontSize: 15 * wScaleFactor,
    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1
);
TextStyle infoBrdYellow =  GoogleFonts.robotoCondensed(
    fontSize: 15 * wScaleFactor,
    fontWeight: FontWeight.normal,
    color: baseYellow,
    letterSpacing: 1.1
);
TextStyle infoBrdSmall =  GoogleFonts.robotoCondensed(
    fontSize: 10 * wScaleFactor,
    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1
);

TextStyle infoBrdSmallSemiTransp = GoogleFonts.robotoCondensed(
fontSize: 10 * wScaleFactor,
fontWeight: FontWeight.normal,
color: baseWhite.withOpacity(0.5),
letterSpacing: 1.1
);
TextStyle infoBrdSmaller = GoogleFonts.robotoCondensed(
    fontSize: 8 * wScaleFactor,
    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1
);
// legend for station name and lines
TextStyle infoBrdLabel = GoogleFonts.robotoCondensed(
  fontSize: 10 * wScaleFactor,
  letterSpacing: 1.1,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
  color: baseWhite.withOpacity(0.8),
);
// bus line description under infoitem
TextStyle busDescrSmall = GoogleFonts.robotoCondensed(
  fontSize: 8 * wScaleFactor,
  letterSpacing: 1.1,
  fontWeight: FontWeight.normal,
  color: baseWhite,
);

