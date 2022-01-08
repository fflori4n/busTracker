import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

const Color switchActive= Color.fromRGBO(45, 160, 230,0.8);                        // #5578BD
const Color switchInactive= Color(0xff121314);                        // #5578BD
const Color switchToggle= Color(0xffffffff);                        // #5578BD

final Color infoDispDarkBlue = Color.fromRGBO(23, 67, 108, 1);
final Color infoDispLiteBlue = Color.fromRGBO(0, 90, 152, 1);

/// https://stackoverflow.com/questions/50751226/how-to-dynamically-resize-text-in-flutter - Taur
/// really smart solution for fixed area, modified it for const width, thanks!

double autoSizeOneLine({@required int stringLength, @required double maxWidth}) {
  assert(stringLength != null, "`quoteLength` may not be null");
  assert(maxWidth != null, "`parentArea` may not be null");

  final double letterSize = (maxWidth *1.4) / stringLength;
  return letterSize;
}

final Color uIYellow = Color.fromARGB(255, 230, 168, 37);
final Color uIWhite = Colors.white;

TextStyle white(size, scaleRatio){
  return GoogleFonts.roboto(
      fontSize: (size * scaleRatio),
      fontWeight: FontWeight.normal,
      color: uIWhite,
      letterSpacing: 1);
}

TextStyle yellow(size, scaleRatio){
  return GoogleFonts.roboto(
      fontSize: (size * scaleRatio),
      fontWeight: FontWeight.normal,
      color: uIYellow,
      letterSpacing: 1);
}