/// call refresh with mapTileSwitchController.add(1)

import 'dart:async';

import 'package:flutter/cupertino.dart';

StreamController<int> redrawOverlayController = StreamController<int>.broadcast();

class MapOverlay extends StatefulWidget {
  final Stream<int>stream;
  MapOverlay(this.stream);

  @override
  _MapOverlayState createState() => _MapOverlayState();
}

class _MapOverlayState extends State<MapOverlay> {
  @override
  void initState(){
    widget.stream.listen((num) { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}