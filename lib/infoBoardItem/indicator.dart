import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class indicatorShape extends CustomPainter {
  Color onColor;
  Color offColor;
  Color pinColor;
  bool isSet;

  indicatorShape(this.onColor, this.offColor,this.pinColor, this.isSet);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isSet ? onColor : offColor
      ..strokeWidth = 0
      ..style = PaintingStyle.fill;
    Paint paint2 = Paint()
      ..color = pinColor
      ..strokeWidth = 0
      ..style = PaintingStyle.fill;

   Path big = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, size.height/2), radius: size.height / 2));

   Path pin = Path();
   if(isSet){
     pin.addOval(Rect.fromCircle(center: Offset(0, size.height), radius: size.height / 6));
   }
   else{
     pin.addOval(Rect.fromCircle(center: Offset(size.height / 2, size.height/2), radius: size.height / 6));
   }


    canvas.drawPath(big, paint);
    canvas.drawPath(pin, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget indicator(Color onColor, Color offColor,Color pinColor, bool isSet) {
    return Center(
      child: CustomPaint(
        painter: indicatorShape(onColor, offColor,pinColor,isSet),
        child: Container(
            child: Text(' ')),
      ),
    );
}
