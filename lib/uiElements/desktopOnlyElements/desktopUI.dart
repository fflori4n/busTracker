import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/main.dart';
import 'package:mapTest/mapRelated/drawoverlay.dart';
import 'package:mapTest/mapRelated/map.dart';
import 'package:mapTest/mapRelated/webview.dart';
import 'package:mapTest/uiElements/responsive/ResponsiveWrapper.dart';
import '../infoDisp.dart';


class DesktopUI extends StatefulWidget {
  final Stream<int>stream;
  DesktopUI(this.stream);
  DesktopUIState createState() => DesktopUIState();
}

class DesktopUIState extends State<DesktopUI> {
  @override
  void initState(){
    widget.stream.listen((num) {});
    setState(() { print('desktop view refreshed! DBG');});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:new Stack(
        children: <Widget>[
         mainMapPage,
         MapOverlay(redrawOverlayController.stream),
         Buletin(redrawInfoBrd.stream),
    ],
    ),);
  }
}
