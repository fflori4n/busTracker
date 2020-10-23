import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../UIColors.dart';

Widget stationLetter(String letter) {
  return Center(
    child: Container(
      height: infoBrdSmall.fontSize,
      width: infoBrdSmall.fontSize,
      margin: EdgeInsets.only(right: 10),
      //padding: EdgeInsets.only(bottom: 2),
      child: Center(child:Text(letter, style: infoBrdSmaller, textAlign: TextAlign.center,),),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1 , color:  baseWhite),
      ),
      ),
  );
}
