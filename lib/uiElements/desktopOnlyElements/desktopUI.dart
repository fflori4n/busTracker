import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/mapRelated/drawoverlay.dart';
import 'package:mapTest/uiElements/responsive/ResponsiveWrapper.dart';
import '../infoDisp.dart';


class DesktopUI extends StatefulWidget {
  DesktopUIState createState() => DesktopUIState();
}

class DesktopUIState extends State<DesktopUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:new Stack(
        children: <Widget>[
          mainMapPage, 
          MapOverlay(redrawOverlayController.stream),
          Buletin(),
    ],
    ),);
  }
}
