import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/dataClasses/BusLine.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/loadStations.dart';

import '../filters.dart';
import '../main.dart';
import '../onSelected.dart';
import 'UIColors.dart';
import 'animatons/fadeInAnim.dart';
import 'infoDisp.dart';

class ActStation{
  final double _edgeBandHeight = 12;
  Size constraints;
  Station station = new Station.byName("workn't :(");
  String topText = '', bottomText = '';
  ActStation({this.constraints, this.station, this.topText, this.bottomText});

  Widget show() {
    double scaleRatio = (this.constraints.width)/1000;
    return InkWell(
          onTap: (){
              if(station.isActiveFocused){
                station.isActiveFocused = false;
              }
              else{
                station.setActiveFocused();
              }
              redrawInfoBrd.add(1);
          },
          onDoubleTap: (){},
          onHover: (isHovering) {
          },
          child: Container(
            width: 1000*scaleRatio,
            //height: station.isActiveFocused ? (150*scaleRatio) : (82*scaleRatio),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0 * scaleRatio) //                 <--- border radius here
              ),
              gradient: LinearGradient( colors: [Color.fromARGB(255, 2, 90, 150), Color.fromARGB(255, 20, 70, 110)]),
            ),
            child:  Column(
              children: [
                Container(
                  //padding: EdgeInsets.symmetric(horizontal: 25*scaleRatio),
                    width: 1000*scaleRatio,
                    //height:  ? (150 - _edgeBandHeight)*scaleRatio : (82 - _edgeBandHeight)*scaleRatio,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              //color: Colors.white,
                              width: 82 *scaleRatio,
                              height: 84 *scaleRatio,
                              padding: station.isActiveFocused ? EdgeInsets.only(left: 17*scaleRatio) : EdgeInsets.only(left: 20*scaleRatio),
                              alignment: Alignment.centerLeft,
                              child: (station.isActiveFocused ?
                              Icon(Icons.location_pin, size: 48 * scaleRatio, color: Colors.white,) :
                              stationNum(statNum: (selectedStations.indexOf(station) + 1).toString(), scaleRatio: scaleRatio)),//stationLetter(30, stationLet),
                            ),
                            Container(
                              //color: Colors.white,
                              height: 84 *scaleRatio,
                              width: 855 *scaleRatio,
                              alignment: Alignment.centerLeft,
                              child: Text(station.name.toUpperCase(), style: white(36,scaleRatio),),
                            ),
                            InkWell(
                              onTap: (){
                                  selectedStations.remove(station);
                                  //removeUnusedBusLines();
                                  onStationSelected();
                                  redrawInfoBrd.add(1);
                              },
                              child: Container(
                                //color: Colors.white,
                                  height: 84 *scaleRatio,
                                  width: 63 *scaleRatio,
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.close,
                                    size: 48 * scaleRatio,
                                    color: Colors.white,
                                  )
                              ),
                            )
                          ],
                        ),
                        (station.isActiveFocused ? Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20*scaleRatio),
                              width: 82 *scaleRatio,
                              height: 66 * scaleRatio,
                              alignment: Alignment.centerLeft,
                              child: stationNum(statNum: (selectedStations.indexOf(station) + 1).toString(), scaleRatio: scaleRatio),
                            ),
                            Container(
                              //color: Colors.white,
                              //height: 66 *scaleRatio,
                              width: 855 *scaleRatio,
                              alignment: Alignment.centerLeft,
                              child: busLinesDisp(scaleRatio: scaleRatio, station: station),
                            ),
                          ],
                        ) : SizedBox.shrink()),
                      ],
                    )
                ),
                Container(
                  width: 1000*scaleRatio,
                  height: (_edgeBandHeight)*scaleRatio,
                  color: Color.fromARGB(255, 20, 70, 110),
                ),
              ],
            ),
          ),
        );
  }
}

Widget busLinesDisp({double scaleRatio, Station station}){
  final TextStyle white30 = white(30,scaleRatio);
  final TextStyle white30dim = white30.apply(color: Colors.white.withOpacity(0.5));
  final TextStyle white30crossed = white30.apply(decoration: TextDecoration.lineThrough,);

  List<TextSpan> dispLines = [];
  int numOfLines = 1;
  TextStyle style = white30;
  int sumChar = 1;
  final int maxChar = 49;

  for(var line in station.servedLines){
    style = white30;
    if(!nsBusLinesContainsName(line)){
      style = white30dim;
    }
    if(busFilters.hideLine.contains(line)){
      style = white30crossed;
    }
    dispLines.add(TextSpan(text: (line + " ").toUpperCase(), style: style, recognizer: TapGestureRecognizer()
      ..onTap = () {
        if (busFilters.hideLine.contains(line)) {
          busFilters.hideLine.remove(line);
        } else {
          busFilters.hideLine.add(line);
        }
        applyFilters(busFilters);
      }
      ),);
    sumChar += line.length + 1;
  }
  numOfLines = max(sumChar~/maxChar,1);
  return Container(
    height: numOfLines * 66 *scaleRatio,
    child: Text.rich(
      TextSpan(
        children: dispLines,
      )
    ),
  );
}

///(selectedStations.indexOf(station) + 1).toString()
Widget stationNum({double scaleRatio, String statNum}){


  return Container(
      width: 35 * scaleRatio,
      height: 35 * scaleRatio,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2 * scaleRatio,
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(18.5 * scaleRatio) //                 <--- border radius here
        ),
      ),
      child: Center(
        child: Text(statNum, style: white(24,scaleRatio)),
      )
  );
}

class InfoBrdBanner{
  final double _edgeBandHeight = 12;
  Size constraints;
  String topText = '', bottomText = '';
  InfoBrdBanner({this.constraints, this.topText, this.bottomText});

  Widget show() {
    double scaleRatio = (this.constraints.width)/1000;
    return FadeIn(
        (20.0),
        InkWell(
          onTap: (){},
          onDoubleTap: (){},
          onHover: (isHovering) {
          },
          child: Container(
            width: 1000*scaleRatio,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0 * scaleRatio) //                 <--- border radius here
              ),
              gradient: LinearGradient( colors: [Color.fromARGB(255, 2, 90, 150), Color.fromARGB(255, 20, 70, 110)]),
            ),
            child:  Column(
              children: [
                Container(
                    width: 1000*scaleRatio,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              //color: Colors.white,
                              width: 82 *scaleRatio,
                              height: 84 *scaleRatio,
                              padding: EdgeInsets.only(left: 20*scaleRatio),
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.not_listed_location, size: 48 * scaleRatio, color: Color.fromARGB(255, 230, 168, 37),),//stationLetter(30, stationLet),
                            ),
                            Container(
                              //color: Colors.white,
                              height: 84 *scaleRatio,
                              width: 855 *scaleRatio,
                              alignment: Alignment.centerLeft,
                              child: Text(topText, style: white(36,scaleRatio),),
                            ),
                            InkWell(
                              onTap: (){
                              },
                              child: Container(
                                //color: Colors.white,
                                  height: 84 *scaleRatio,
                                  width: 63 *scaleRatio,
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.close,
                                    size: 48 * scaleRatio,
                                    color: Colors.white,
                                  )
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20*scaleRatio),
                              width: 82 *scaleRatio,
                              height: 66 * scaleRatio,
                              alignment: Alignment.centerLeft,
                            ),
                            Container(
                              //color: Colors.white,
                              height: 66 *scaleRatio,
                              width: 855 *scaleRatio,
                              alignment: Alignment.topLeft,
                              child: Text(bottomText, style: white(24,scaleRatio),),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                Container(
                  width: 1000*scaleRatio,
                  height: (_edgeBandHeight)*scaleRatio,
                  color: Color.fromARGB(255, 20, 70, 110),
                ),
              ],
            ),
          ),
        ));
  }
}