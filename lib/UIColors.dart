import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/main.dart';

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

Color giveMeColor(String seedStr){
  String digest = sha1.convert(utf8.encode(seedStr.replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';}))).toString().replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
  String digest2 = sha1.convert(utf8.encode(seedStr)).toString().replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
  var rand = new Random(int.parse(digest));
  var rand2 = new Random(int.parse(digest2));
  // #458BFA
  double hue = 45; //new Random(int.parse(digest));
  //double hueVariation = 25 * rand2.nextInt(5).toDouble();
  double satVariation = 0.1 * rand2.nextInt(5).toDouble() - 0.5;
  double sat = 110;
  double light = 0.5; // const
  //r = min + rnd.nextInt(max - min);
  sat = (sat -50 + rand.nextInt(70+50) + satVariation)/255;
  hue = 303 - 108 + rand.nextInt(216).toDouble();
  hue = hue % 360;//(hue + hueVariation) % 360;

  print(hue.toString() + sat.toString() + light.toString());
  HSLColor newColor = new HSLColor.fromAHSL(1, hue, sat, light);
  return newColor.toColor();
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
    //fontSize: 15 * wScaleFactor,
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1
);
TextStyle infoBrdYellow =  GoogleFonts.robotoCondensed(
    //fontSize: 15 * wScaleFactor,
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: baseYellow,
    letterSpacing: 1.1
);
TextStyle infoBrdSmall =  GoogleFonts.robotoCondensed(
    //fontSize: 10 * wScaleFactor,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1
);

TextStyle infoBrdSmallCrossedOut =  GoogleFonts.robotoCondensed(
  //fontSize: 10 * wScaleFactor,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1,
    decoration: TextDecoration.lineThrough,
);

TextStyle infoBrdSmallSemiTransp = GoogleFonts.robotoCondensed(
//fontSize: 10 * wScaleFactor,
fontSize: 15,
fontWeight: FontWeight.normal,
color: baseWhite.withOpacity(0.5),
letterSpacing: 1.1
);

TextStyle infoBrdSmaller = GoogleFonts.robotoCondensed(
    //fontSize: 8 * wScaleFactor,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: baseWhite,
    letterSpacing: 1.1
);
// legend for station name and lines
TextStyle infoBrdLabel = GoogleFonts.robotoCondensed(
  //fontSize: 10 * wScaleFactor,
  fontSize: 15,
  letterSpacing: 1.1,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
  color: baseWhite.withOpacity(0.8),
);
// bus line description under infoitem
TextStyle busDescrSmall = GoogleFonts.robotoCondensed(
  //fontSize: 8 * wScaleFactor,
  fontSize: 12,
  letterSpacing: 1.1,
  fontWeight: FontWeight.normal,
  color: baseWhite,
);

