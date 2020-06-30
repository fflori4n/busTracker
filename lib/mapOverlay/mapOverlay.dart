import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:mapTest/UIColors.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/main.dart';

Widget drawMapOverlay(){
  print('rendering map overlay!');
  return IgnorePointer(
      child:LayoutBuilder(
      builder: (_, constraints) => Container(
        width: constraints.widthConstraints().maxWidth,
        height: constraints.heightConstraints().maxHeight,
        color: baseBlue.withOpacity(0.2),
        child: CustomPaint(painter: OverlayPainter()),
  ),),);
}

class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    for(var busline in nsBusLines){
      final paint = Paint()
        ..color = busline.color.withOpacity(0.2)
        ..strokeWidth = 4
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;
      print('drawing...');

      drawPolyLine(canvas,size,busline.points, paint);
    }
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) => false;
}

/*Offset convertToOverlayCoords(LatLng latlng, Size size){
  double y = size.height * (latlng.latitude - mapNW.latitude)/(mapSE.latitude - mapNW.latitude);
  double x = size.width * (latlng.longitude - mapNW.longitude)/(mapSE.longitude - mapNW.longitude);

  return Offset(x,y);
}*/
void drawPolyLine(Canvas canvas,Size size,List<LatLng> inLatLng, Paint lineStyle){

  List<Offset> linePoints = [];
  for(var point in inLatLng){
    double y = size.height * (point.latitude - mapNW.latitude)/(mapSE.latitude - mapNW.latitude);
    double x = size.width * (point.longitude - mapNW.longitude)/(mapSE.longitude - mapNW.longitude);
    linePoints.add(Offset(x,y));
  }

  Offset startP = Offset(-1,0);
  Offset endP;

  for( Offset point in linePoints){
    endP = point;
    /*if(startP.dx > size.width || startP.dx < 0 || startP.dy > size.height || startP.dy < 0){
      print('[  ER  ]  Start P out of bounds!');
      continue;
    }
    if(endP.dx > size.width || endP.dx < 0 || endP.dy > size.height || endP.dy < 0){
      print('[  ER  ]  End P out of bounds!');
      continue;
    }*/
    try{
      if(startP.dx != -1) {
        canvas.drawLine(startP, endP, lineStyle);
      }
    }
    catch(e){
      print(e);
    }
    startP = endP;
  }
}