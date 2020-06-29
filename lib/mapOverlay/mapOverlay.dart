import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget drawMapOverlay(){
  print('rendering map overlay!');
  return IgnorePointer(
      child:LayoutBuilder(
      builder: (_, constraints) => Container(
        width: constraints.widthConstraints().maxWidth,
        height: constraints.heightConstraints().maxHeight,
        color: Colors.blue.withOpacity(0.2),
        child: CustomPaint(painter: OverlayPainter()),
  ),),);
}

class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final List<Offset> points = [Offset(0,0), Offset(50,50), Offset(size.width, size.height)];
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    print('drawing...');
    drawPolyLine(canvas, points, paint);
  }

  void drawPolyLine(Canvas canvas,List<Offset> linePoints, Paint lineStyle){
    Offset prevPoint;
    for(var point in linePoints){
      /*if (point != null && prevPoint != null) {
        print('poly' + point.toString() + prevPoint.toString());*/
      try{
        canvas.drawLine(prevPoint, point, lineStyle);
      }
      catch(e){

      }
      //}
      point = prevPoint;
    }
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) => false;
}