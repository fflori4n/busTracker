import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' hide Path;
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/mapRelated/map.dart';

import '../UIColors.dart';
import '../geometryFuncts.dart';
import '../main.dart';
import 'busMarkersOverlay.dart';

class MapOverlay extends StatefulWidget {
  @override
  _MapOverlayState createState() => _MapOverlayState();
}

class _MapOverlayState extends State<MapOverlay> {
  @override
  void initState();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (_, constraints) => Container(
          width: constraints.widthConstraints().maxWidth,
          height: constraints.heightConstraints().maxHeight,
          color: Colors.blueGrey.withOpacity(0.2),
          child: CustomPaint(
            painter: OverlayPainter(),
            foregroundPainter: BusOverlayPainter(),),
          ),
        ),
    );
  }
}

class OverlayPainter extends CustomPainter {
  /// for static map objects
  ///
  final Paint nonSelectedCityBusStop = Paint()
    ..color = Colors.black.withOpacity(0.15)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint selectedCityBusStop = Paint()
    ..color = Colors.black.withOpacity(0.8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint;

    /// ********************************************************************** Bus Lines
    for (var busline in nsBusLines) {
      Paint busLinePaint = Paint()
        ..color = busline.color.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;

      drawPolyLine(canvas,size,busline.points, busLinePaint);
    }

    /// ********************************************************************** City Bus Stop
    for (Station station in stationList) {
      double radius = 6;
      paint = nonSelectedCityBusStop;
      if (selectedStations.contains(station)) {
        radius = 10;
        paint = selectedCityBusStop;
      }

      Offset mapOffset = getOverlayOffset(station.pos, size);
      if (mapOffset.dx < 0) {
        continue;
      }
      canvas.drawCircle(mapOffset, radius, paint);
    }

    /// ********************************************************************** USER LOCATION
    if (user.locationEnabled && user.position != LatLng(-1, -1)) {
      final Paint userPaint = Paint()
        ..color = baseBlue.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final Offset userOffset = getOverlayOffset(user.position, size);
      canvas.drawCircle(userOffset, 5, userPaint);
      double diam = mapDiameterByDistance(user.posAcc, size);
      if (diam > 0) {
        canvas.drawCircle(
            userOffset, diam / 2, userPaint..color = baseBlue.withOpacity(0.1));
      }
    }
  }

  Offset getOverlayOffset(LatLng location, Size size) {
    double y = size.height *
        (location.latitude - mapConfig.mapNW.latitude) /
        (mapConfig.mapSE.latitude - mapConfig.mapNW.latitude);
    if (y < 0 || y > size.height) {
      return Offset(0, 0);
    }
    double x = size.width *
        (location.longitude - mapConfig.mapNW.longitude) /
        (mapConfig.mapSE.longitude - mapConfig.mapNW.longitude);
    if (x < 0 || x > size.width) {
      return Offset(0, 0);
    }
    return Offset(x, y);
  }

  double mapDiameterByDistance(double meter, Size size) {
    double longDist = normLoc(
        LatLng(mapConfig.mapSE.latitude, mapConfig.mapNW.longitude),
        mapConfig.mapSE);
    return (meter * size.width) / longDist;
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

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) => false;
}