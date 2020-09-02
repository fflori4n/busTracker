import 'dart:html';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:mapTest/loadModules/busLocator.dart';

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
      final paint = Paint()
        ..color = bus.color
        //..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;

      double y = size.height * (bus.busPos.busPoint.latitude - mapNW.latitude)/(mapSE.latitude - mapNW.latitude);
      if(y < 0 || y> size.height){
        continue;
      }
      double x = size.width * (bus.busPos.busPoint.longitude - mapNW.longitude)/(mapSE.longitude - mapNW.longitude);
      if(x < 0 || x> size.width){
        continue;
      }
      if(bus.busPos.heading == -1)
        canvas.drawCircle(Offset(x,y), 6, paint);
      else
        canvas.drawPath(getTrianglePath(x, y, bus.busPos.heading), paint);
    }
  }

  @override
  bool shouldRepaint(BusOverlayPainter oldDelegate) => false;
}