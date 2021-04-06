import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/DeviceInfo.dart';
import 'package:mapTest/loadModules/busLines.dart';


DeviceType getDevType(MediaQueryData mediaQuery){
  double deviceScreenWidth = mediaQuery.size.width;

  if(deviceScreenWidth > 950){
    return DeviceType.desktop;
  }
  if(deviceScreenWidth > 600){
    return DeviceType.mobile;
  }
  return DeviceType.mobile;
}

class RespWrap extends StatelessWidget{
  final Widget Function(BuildContext context, DeviceInfo deviceInfo) builder;
  const RespWrap({this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints){
      var mediaQuery = MediaQuery.of(context);
      var deviceInfo = DeviceInfo(
        orientation: mediaQuery.orientation,
        deviceType: getDevType(mediaQuery),
        screenSize: mediaQuery.size,
        widgetSize: Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
      );
      //print(deviceInfo.toString());   // TODO: DBG
      return builder(context, deviceInfo);
    },
    );
  }

}