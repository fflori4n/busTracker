import 'dart:html';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/loadModules/busLocator.dart';
import 'package:mapTest/mapRelated/map.dart';

import '../main.dart';

class Point{

double x = 0;
double y = 0;

Point(double x, double y){
  this.x = x;
  this.y = y;
}

}
class BusOverlayPainter extends CustomPainter {
  Path getTrianglePath(double x, double y, double heading) {
    final double size = 18;
    var points = new List.unmodifiable([
      Point(size/2,0),
      Point(-size/2,size/2),
      Point(-size/3,0),
      Point(-size/2,-size/2),
      Point(size/2,0),
    ]);

    double cosfi = cos(heading);
    double sinfi = sin(heading);
    for(var point in points){
      double newx= point.x * cosfi + point.y * sinfi;
      double newy= point.x * -sinfi + point.y * cosfi;

      point.x = newx;
      point.y = newy;
    }
    Path marker = new Path()
      ..moveTo(x + points[0].x, y + points[0].y)
      ..lineTo(x + points[1].x, y + points[1].y)
      ..lineTo(x + points[2].x, y + points[2].y)
      ..lineTo(x + points[3].x, y + points[3].y)
      ..lineTo(x + points[4].x, y + points[4].y);

    return marker;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for(var bus in buslist){
      if(!bus.displayedOnMap){
        continue;
      }

      double y = size.height * (bus.busPos.busPoint.latitude - mapConfig.mapNW.latitude)/(mapConfig.mapSE.latitude - mapConfig.mapNW.latitude);
      if(y < 0 || y> size.height){
        continue;
      }
      double x = size.width * (bus.busPos.busPoint.longitude - mapConfig.mapNW.longitude)/(mapConfig.mapSE.longitude - mapConfig.mapNW.longitude);
      if(x < 0 || x> size.width){
        continue;
      }

      if(bus.twins == 0){
        final paint = Paint()
          ..color = bus.color
        //..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;
        final stroke = Paint()
          ..color = Colors.black87
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;

        if (bus.busPos.heading != -1) {
          canvas.drawPath(getTrianglePath(x, y, bus.busPos.heading),
              paint); // paint bus markers
          canvas.drawPath(getTrianglePath(x, y, bus.busPos.heading),
              stroke); // TODO: maybe do both stroke and fill at once?}
        }
        else {
          canvas.drawCircle(Offset(x, y), 6, paint);
        }
        // draw text
        final textStyle = ui.TextStyle(
          color: Colors.black87,
          fontSize: 12,
        );
        final paragraphBuilder = ui.ParagraphBuilder(new ui.ParagraphStyle(textDirection: TextDirection.ltr,))
          ..pushStyle(textStyle);

        paragraphBuilder.addText('\t' + bus.busLine.name);

        if(bus.eTA.inSex() > 0 && bus.eTA.inSex() < 59*60){
          paragraphBuilder.addText('\t' + bus.eTA.mins.toString().padLeft(2,'0') + ':' + bus.eTA.sex.toString().padLeft(2,'0'));
        }

        final constraints = ui.ParagraphConstraints(width: 300);
        final paragraph = paragraphBuilder.build();
        paragraph.layout(constraints);
        final offset = Offset(x + 5, y + 5 + (bus.twins * 12 * 1.3) );
        canvas.drawParagraph(paragraph, offset);
      }
    }
  }

  @override
  bool shouldRepaint(BusOverlayPainter oldDelegate) => false;
}