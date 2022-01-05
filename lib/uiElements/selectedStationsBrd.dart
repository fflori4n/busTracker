import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/loadModules/loadStations.dart';

import '../onSelected.dart';
import 'animatons/fadeInAnim.dart';
import 'infoDisp.dart';

class ActStation{
  final double _edgeBandHeight = 12;
  Size constraints;
  Station station;

  ActStation({this.constraints, this.station});

  Widget show() {
    double scaleRatio = (this.constraints.width)/1000;

    final TextStyle White36 = GoogleFonts.roboto(
        fontSize: (36 * scaleRatio),
        fontWeight: FontWeight.normal,
        color: Colors.white,
        letterSpacing: 1);

    return FadeIn(
        (150.0),
        InkWell(
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
                            ),
                            Container(
                              //color: Colors.white,
                              height: 84 *scaleRatio,
                              width: 855 *scaleRatio,
                              alignment: Alignment.centerLeft,
                              child: Text(station.name.toUpperCase(), style: White36,),
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
                        station.isActiveFocused ? Row(
                          children: [
                            Container(
                              height: 66 * scaleRatio,
                            )
                          ],
                        ) : Container(),
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