import 'package:flutter/cupertino.dart';
import 'package:mapTest/loadModules/busLocator.dart';

import '../main.dart';

class BusOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for(var bus in buslist){
      if(!bus.displayedOnMap){
        continue;
      }
      final paint = Paint()
        ..color = bus.color.withOpacity(0.8)
        //..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;

      double y = size.height * (bus.busPos.latitude - mapNW.latitude)/(mapSE.latitude - mapNW.latitude);
      if(y < 0 || y> size.height){
        continue;
      }
      double x = size.width * (bus.busPos.longitude - mapNW.longitude)/(mapSE.longitude - mapNW.longitude);
      if(x < 0 || x> size.width){
        continue;
      }
      canvas.drawCircle(Offset(x,y), 6, paint);
    }
  }

  @override
  bool shouldRepaint(BusOverlayPainter oldDelegate) => false;
}