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

TextStyle primaryFont = GoogleFonts.robotoCondensed();

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
TextStyle infoBrdSmallBold =  GoogleFonts.robotoCondensed(
  //fontSize: 10 * wScaleFactor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
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
    decorationColor: Color.fromRGBO(16, 16, 19, 1),
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

TextStyle busDescrSmallLink = GoogleFonts.robotoCondensed(
  //fontSize: 8 * wScaleFactor,
  fontSize: 12,
  letterSpacing: 1.1,
  fontWeight: FontWeight.normal,
  decoration: TextDecoration.underline,
  color: Colors.blue,
);

