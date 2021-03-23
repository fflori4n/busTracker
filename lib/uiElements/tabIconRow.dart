import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

import 'UIColors.dart';
import '../main.dart';

Widget showTabIconRow(double maxWidth) {
  print('screenwidfth = ' + maxWidth.toString());
  maxWidth *= 0.85;

  final double btnPadding = maxWidth / 80;

  final TextStyle buttonTextSty = GoogleFonts.robotoCondensed(
      fontSize: autoSizeOneLine(
          stringLength: max("Red Vožnje".length, '#filteri'.length),
          maxWidth: maxWidth / 3.8),
      fontWeight: FontWeight.normal,
      color: baseWhite,
      letterSpacing: 1.1);

  return Stack(children: <Widget>[
    Container(
      height: maxWidth / 10,
      decoration: BoxDecoration(
        color: Color.fromRGBO(16, 16, 19, 1),
      ),
    ),
    Container(
      padding: EdgeInsets.symmetric(horizontal: maxWidth / 50),
      child: Row(
        children: <Widget>[
          Container(
            transform: user.tabOpen == 5
                ? Matrix4.translationValues(0.0, 8.0, 0.0)
                : Matrix4.translationValues(0.0, -5.0, 0.0),
            padding: EdgeInsets.symmetric(vertical: btnPadding),
            height: maxWidth / 10,
            width: maxWidth / 3.8,
            decoration: BoxDecoration(
              color: Color.fromRGBO(46, 46, 46, 1),
              borderRadius: BorderRadius.all(const Radius.circular(5)),
            ),
            child: Tooltip(
                message: 'Red Voznje',
                child: FlatButton(
                  onPressed: () {
                    if (user.tabOpen == 5) {
                      user.tabOpen = 0;
                    } else {
                      user.tabOpen = 5;
                    }
                  },
                  child: Center(
                    child: Text("Red Vožnje", style: buttonTextSty),
                  ),
                )),
          ),
          Container(
            transform: user.tabOpen == 4
                ? Matrix4.translationValues(0.0, 8.0, 0.0)
                : Matrix4.translationValues(0.0, -5.0, 0.0),
            padding: EdgeInsets.symmetric(vertical: btnPadding),
            margin: EdgeInsets.only(
              left: maxWidth / 50,
            ),
            height: maxWidth / 10,
            width: maxWidth / 3.8,
            decoration: BoxDecoration(
              color: Color.fromRGBO(46, 46, 46, 1),
              borderRadius: BorderRadius.all(const Radius.circular(5)),
            ),
            child: Tooltip(
                message: '#filteri',
                child: FlatButton(
                  onPressed: () {
                    if (user.tabOpen == 4) {
                      user.tabOpen = 0;
                    } else {
                      user.tabOpen = 4;
                    }
                  },
                  child: Center(
                    child: Text("#Filteri", style: buttonTextSty),
                  ),
                )),
          ),
          Spacer(),                                                               // TODO: alignment issue on mobile, possibly bug in flutter
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: maxWidth / 50,
            ),
            transform: user.tabOpen == 1
                ? Matrix4.translationValues(0.0, 8.0, 0.0)
                : Matrix4.translationValues(0.0, -5.0, 0.0),
            height: maxWidth / 10,
            width: maxWidth / 10,
            decoration: BoxDecoration(
              color: Color.fromRGBO(46, 46, 46, 1),
              borderRadius: BorderRadius.all(const Radius.circular(5)),
            ),
            child: Tooltip(
                message: 'Manage favourite stations',
                child: FlatButton(
                  onPressed: () {
                    if (user.tabOpen == 1) {
                      user.tabOpen = 0;
                    } else {
                      user.tabOpen = 1;
                    }
                  },
                  child:  Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: maxWidth / 20,
                      semanticLabel: 'favourites',
                    ),
                )),
          ),
          Container(
            margin: EdgeInsets.only(
              left: maxWidth / 50,
            ),
            transform: user.tabOpen == 2
                ? Matrix4.translationValues(0.0, 8.0, 0.0)
                : Matrix4.translationValues(0.0, -5.0, 0.0),
            height: maxWidth / 10,
            width: maxWidth / 10,
            decoration: BoxDecoration(
              color: Color.fromRGBO(46, 46, 46, 1),
              borderRadius: BorderRadius.all(const Radius.circular(5)),
            ),
            child: Tooltip(
                message: 'Navigation and location settings',
                child: FlatButton(
                  onPressed: () {
                    if (user.tabOpen == 2) {
                      user.tabOpen = 0;
                    } else {
                      user.tabOpen = 2;
                    }
                  },
                  child: Center(
                    child: Icon(
                      user.locationEnabled
                          ? (user.position == LatLng(-1, -1)
                              ? Icons.place
                              : Icons.gps_fixed)
                          : Icons.not_listed_location, //: Icon.place,
                      color: user.locationEnabled ? Colors.white : baseYellow,
                      size: maxWidth / 20,
                      semanticLabel: 'location',
                    ),
                  ),
                )),
          ),
          Container(
            margin: EdgeInsets.only(
              left: maxWidth / 50,
            ),
            transform: user.tabOpen == 3
                ? Matrix4.translationValues(0.0, 8.0, 0.0)
                : Matrix4.translationValues(0.0, -5.0, 0.0),
            height: maxWidth / 10,
            width: maxWidth / 10,
            decoration: BoxDecoration(
              color: Color.fromRGBO(46, 46, 46, 1),
              borderRadius: BorderRadius.all(const Radius.circular(5)),
            ),
            child: Tooltip(
                message: 'Settings',
                child: FlatButton(
                  onPressed: () {
                    if (user.tabOpen == 3) {
                      user.tabOpen = 0;
                    } else {
                      user.tabOpen = 3;
                    }
                  },
                  child: Center(
                    child: Icon(
                      Icons.settings, //: Icon.place,
                      color: Colors.white,
                      size: maxWidth / 20,
                      semanticLabel: 'settings',
                    ),
                  ),
                )),
          ),
        ],
      ),
    ),
  ]);
}
