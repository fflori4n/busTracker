import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../UIColors.dart';

Widget stationLetter(String letter) {
  return Center(
    child: Container(
      height: infoBrdSmall.fontSize,
      width: infoBrdSmall.fontSize,
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.all(0.5),
      child: Center(child:Text(letter, style: infoBrdSmaller, textAlign: TextAlign.center,),),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1 , color:  baseWhite),
      ),
      ),
  );
}

Widget stationX() {
  return Center(
    child: Container(
      height: infoBrdSmall.fontSize*1.2,
      width: infoBrdSmall.fontSize*1.2,
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.all(1),
      child: Center(child:Text('x', style: infoBrdSmaller, textAlign: TextAlign.center,),),
      decoration: BoxDecoration(
        border: Border.all(width: 1 , color:  baseWhite),
        borderRadius: BorderRadius.all( Radius.circular(2),),
      ),

    ),
  );
}