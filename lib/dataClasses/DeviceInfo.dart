import 'dart:html';

import 'package:flutter/cupertino.dart';

/// from: https://www.youtube.com/watch?v=z7P1OFLw4kY
///
enum DeviceType{
  mobile,
  desktop,
  tablet,
}

class DeviceInfo{
  Orientation orientation;
  DeviceType deviceType;
  Size screenSize;
  Size widgetSize;
  bool isMobile = false;
  
  DeviceInfo({this.orientation, this.deviceType, this.screenSize, this.widgetSize}){
    if(this.deviceType == DeviceType.mobile){
      isMobile = true;
    }
  }

  String toString(){
    return "orientation:" + orientation.toString() + ", deviceType:"+ deviceType.toString() + ", screenSize:" + screenSize.toString() + ", widgetSize:" + widgetSize.toString();
  }
}