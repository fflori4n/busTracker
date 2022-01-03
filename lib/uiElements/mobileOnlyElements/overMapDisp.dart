/// call refresh with mapTileSwitchController.add(1)

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/main.dart';

import '../../onSelected.dart';
import '../UIColors.dart';
import 'mobileUI.dart';

StreamController<int> redrawOverMapDisp = StreamController<int>.broadcast();

class OverMapDisp extends StatefulWidget {
  final Stream<int>stream;
  OverMapDisp(this.stream);

  @override
  _OverMapDispState createState() => _OverMapDispState();
}

class _OverMapDispState extends State<OverMapDisp> {

  final double width = screenWidth;
  final double height = 0.1* screenHeight;
  final promtStyle = TextStyle(
    color: Colors.black87,
    fontSize: 0.01 * screenWidth,
  );

  @override
  void initState(){
    widget.stream.listen((num) { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {



    List<Widget> lines = [];
    for(var station in selectedStations){
      lines.add(Text((selectedStations.indexOf(station) + 1).toString() + '. ' + station.name , style: promtStyle,));
    }
    if(lines.length == 0){
      lines.add(Text('kliknite stanicu polaska!', style: promtStyle,));
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width/100),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(4.0), bottomRight: Radius.circular(4.0)),
      ),
      width: width,
      height: promtStyle.fontSize * 2,
     // color: baseWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 0.1*0.04* screenHeight),
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                selectedStations.length != 0 ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.1*0.04* screenHeight),
                  //color:Colors.green,
                  width:  0.025 * screenWidth,
                  height: 0.025 * screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Tooltip(
                    message: 'Prihvati stanice! i pređi na dolazke',
                    child: FlatButton(
                      onPressed: (){
                        isScheduleView = true;
                        redrawLayoutController.add(1); // write to stream, flag for update
                      },
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 0.5 * 0.025 * screenWidth,
                        ),
                      ),
                    )
                  )
                ) : Container(),
                selectedStations.length != 0 ? Container(
                  margin: EdgeInsets.only(right: 0.1*0.04* screenHeight),
                  //color: Colors.red,
                  width: 0.025 * screenWidth,
                  height:  0.025 * screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Tooltip(
                      message: 'Briši stanicu!',
                      child: FlatButton(
                        onPressed: (){
                          if(selectedStations.length == 0)
                            return;
                          selectedStations.removeLast();
                          onStationSelected();
                        },
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 0.5 * 0.025 * screenWidth,
                          ),
                        ),
                      )
                  ),
                ) : Container(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0.1*0.04* screenHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines,
            ),
          ),
        ],
      ),
    );
  }
}