import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' hide Path;
import 'package:mapTest/UIColors.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/geometryFuncts.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/stations.dart';
import 'package:mapTest/main.dart';

import 'busMarkersOverlay.dart';

Widget drawMapOverlay(){
    print('rendering map overlay!');
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (_, constraints) =>
            Container(
              width: constraints
                  .widthConstraints()
                  .maxWidth,
              height: constraints
                  .heightConstraints()
                  .maxHeight,
              color: baseBlue.withOpacity(0.2),
              child: CustomPaint(painter: OverlayPainter(),
                foregroundPainter: BusOverlayPainter(),),
            ),),);
}

class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    for(var busline in nsBusLines){
      var paint = Paint();
      if(activeStation.name == paperStation.name){
        paint = Paint()
          ..color = busline.color.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;
      }
      else{
        paint = Paint()
          ..color = busline.color.withOpacity(0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;
      }
      drawPolyLine(canvas,size,busline.points, paint);
    }
    for(Station station in stationList){  // draw stations on overlay? maybe faseter? test it
      double radius = 6;
      Paint paint = Paint()
        ..color = baseBlack.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      if(station == activeStation){
        radius = 10;
        paint = Paint()
          ..color = baseBlack.withOpacity(0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;
      }

      double y = size.height * (station.pos.latitude - mapConfig.mapNW.latitude)/(mapConfig.mapSE.latitude - mapConfig.mapNW.latitude);
      if(y < 0 || y> size.height){
        continue;
      }
      double x = size.width * (station.pos.longitude - mapConfig.mapNW.longitude)/(mapConfig.mapSE.longitude - mapConfig.mapNW.longitude);
      if(x < 0 || x> size.width){
        continue;
      }
      canvas.drawCircle(Offset(x,y), radius, paint);
    }
    if(user.locationEnabled && user.position != LatLng(-1,-1)){
      double y = size.height * (user.position.latitude - mapConfig.mapNW.latitude)/(mapConfig.mapSE.latitude - mapConfig.mapNW.latitude);
      double x = size.width * (user.position.longitude - mapConfig.mapNW.longitude)/(mapConfig.mapSE.longitude - mapConfig.mapNW.longitude);
      if(x < 0 || x> size.width || y < 0 || y> size.height){
        print('user location out of bounds! [  Wr  ]');
      }
      else{
        Paint userPaint = Paint()
          ..color = baseBlue.withOpacity(0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(Offset(x,y), 5, userPaint);


        double diam = mapDiameterByDistance(user.posAcc, size);
        //print(diam);
        if(diam > 0){
          canvas.drawCircle(Offset(x,y), diam/2, userPaint ..color=baseBlue.withOpacity(0.1));
        }
      }
    }
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) => false;
}

void drawPolyLine(Canvas canvas,Size size,List<LatLng> inLatLng, Paint lineStyle){
  Path line = Path();
  for(int i = 0; i < inLatLng.length; i++){
    double y = size.height * (inLatLng[i].latitude - mapConfig.mapNW.latitude)/(mapConfig.mapSE.latitude - mapConfig.mapNW.latitude);
    double x = size.width * (inLatLng[i].longitude - mapConfig.mapNW.longitude)/(mapConfig.mapSE.longitude - mapConfig.mapNW.longitude);
    if(i == 0){
      line.moveTo(x, y);
      continue;
    }
    line.lineTo(x, y);
  }
  canvas.drawPath(line,lineStyle);
}


double mapDiameterByDistance( double meter, Size size){
  double longDist = normLoc(LatLng(mapConfig.mapSE.latitude, mapConfig.mapNW.longitude), mapConfig.mapSE);
  return (meter * size.width)/longDist;
  //print(longDist);
  //return meter;
}