import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SQRBtn extends StatelessWidget{

  final double scaleRatio;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;
  final String btnLabel;
  SQRBtn({this.scaleRatio = 1, this. icon = Icons.assistant_photo, this.color = Colors.white, this.onTap, this.iconSize = 74, this.btnLabel = ''});

  @override
  Widget build(BuildContext context) {
    final TextStyle White22 = GoogleFonts.roboto(
        fontSize: (22 * scaleRatio),
        fontWeight: FontWeight.normal,
        color: Colors.white,
        letterSpacing: 1);

    return InkWell(
      onTap: this.onTap,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: 120 * scaleRatio,
            height:  80 * scaleRatio,
            child: Text(btnLabel, style: White22),
          ),
          Container(
            width: 120 * scaleRatio,
            height:  120 * scaleRatio,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: color,
                width: 2 * scaleRatio,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(5 * scaleRatio)
              ),
            ),
            child: Center(
              child: Icon(
                icon, size: iconSize * scaleRatio, color: color,
              ),
            ),
          ),
        ],
      )
    );
  }
}