import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../UIColors.dart';

Widget stationLetter(double width, String letter) {
  return Center(
    child: Container(
      height: width,
      width: width,
      child: Center(child:Text(letter, style: TextStyle(color: baseWhite, fontSize: width*2/3),textAlign: TextAlign.center,),),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1 , color:  baseWhite),
      ),
      ),
  );
}

Widget stationX(double width) {
  return Center(
    child: Container(
      height: width,
      width: width,
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.all(1),
      child: Center(child:Text('x',textAlign: TextAlign.center,),),
      decoration: BoxDecoration(
        border: Border.all(width: 1 , color:  baseWhite),
        borderRadius: BorderRadius.all( Radius.circular(2),),
      ),

    ),
  );
}