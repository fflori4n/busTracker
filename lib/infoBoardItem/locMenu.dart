import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/location/locationTest.dart';

import '../UIColors.dart';
import '../main.dart';
import 'indicator.dart';

Widget LocationMenu() {
  if (!user.locTabOpen) {
    return Container();
  }
  return Column(
    children: <Widget>[
      Container(
        // margin: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
        padding:
        EdgeInsets.only(left: 17.0, right: 17.0, top: 6.0, bottom: 4.0),
        color: baseGray,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 2, bottom: 2),
              child: GestureDetector(
                  onTap: () {
                    user.locationEnabled = !user.locationEnabled;
                    if(user.locationEnabled){
                      updatePos();
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Text('location enabled',style: infoBrdSmall,),
                      Spacer(),
                      Container(
                        child: indicator(baseBlue, baseYellow, baseGray, !user.locationEnabled),
                        height: infoBrdSmall.fontSize,
                      ),],
                  )
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 2, bottom: 2),
              child: GestureDetector(
                  onTap: () {
                    user.cookiesEnabled = !user.cookiesEnabled;
                  },
                  child: Row(
                    children: <Widget>[
                      Text('cookies enabled',style: infoBrdSmall,),
                      Spacer(),
                      Container(
                        child: indicator(baseBlue, baseYellow, baseGray, !user.cookiesEnabled),
                        height: infoBrdSmall.fontSize,
                      ),],
                  )
              ),
            ),

          ],
        ),
      ),
      Container(
        decoration: new BoxDecoration(
          color: baseWhite,
        ),
        height: 1,
        //margin: EdgeInsets.only(bottom: 5.0),
      ),
    ],
  );
}
