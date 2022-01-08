import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/busLocator.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:mapTest/mapRelated/map.dart';
import 'package:mapTest/resty/busFeedback.dart';
import 'package:mapTest/uiElements/animatons/fadeInAnim.dart';
import 'dart:js' as js;

import '../../main.dart';
import '../UIColors.dart';
import '../feedBackBtn.dart';
import '../infoDisp.dart';
import '../legacySchedule.dart';

Widget busListItem(BuildContext context, Bus bus, Size constraints, int listIndex) {
 try{
   //, //Station station){
   bool shiftText = false;

   const double _itemPadding = 0.025;
   const double _itemVerticalPadding = 0.01;
   const double _maxWidth = 1 - _itemPadding;
   double scaleRatio = (_maxWidth * constraints.width)/1000;

   if(!buslist.contains(bus)){
     //displayedBusList.remove(bus);
     return SizedBox.shrink();
   }
   if (!bus.displayedOnSchedule) {                                               /// probably not needed, test than remove
     return SizedBox.shrink();
   }

   final String lblLineName = bus.busLine.name.padRight(5, ' ');
   final String lblNickName = bus.nickName.toUpperCase();
   final String stationLet = (bus.stationNumber + 1).toString();
   String lblBusDescription = bus.lineDescr.toUpperCase();
   double time2Station = 0;
   try{
     final Station selectedStation = selectedStations.elementAt(bus.stationNumber);
     final double distance = selectedStation.distFromLineStart[selectedStation.lines.indexOf(bus.busLine)];
     time2Station = getEstTime2Station(distance).toDouble();
   }
   catch(E){
     print("[  Wr  ] " + E.toString());
   }
   DateTime TOA = DateTime.fromMillisecondsSinceEpoch((bus.unixStartDT + time2Station) * 1000);
   String lblTOA = TOA.hour.toString().padLeft(2, '0') + ":" + TOA.minute.toString().padLeft(2, '0');


   if(bus.lineDescr.length > 25){
     if(bus.descScrollPos >= (bus.lineDescr.length + 10)){                                /// shift description if too long
       bus.descScrollPos = 0;
     }
     lblBusDescription = (bus.lineDescr.toUpperCase() + "           " + bus.lineDescr.toUpperCase()).substring(bus.descScrollPos, bus.descScrollPos+25);
     // if(shiftText){
     bus.descScrollPos++;
     //}
   }

   final String lblStartTime = bus.startTime.hours.toString().padLeft(2, '0') + ":" + bus.startTime.mins.toString().padLeft(2, '0');
   String lblETATime = bus.eTA.hours.toString().padLeft(2, '0') + ":" + bus.eTA.mins.toString().padLeft(2, '0') + ":" + "00".padLeft(2, '0');
   if(bus.eTA.hours == 0 && bus.eTA.mins < 10 ){
     lblETATime = bus.eTA.hours.toString().padLeft(2, '0') + ":" + bus.eTA.mins.toString().padLeft(2, '0') + ":" + bus.eTA.sex.toString().toString().padLeft(2, '0');
   }
   String lblETAMsg = '';
   if (bus.eTA.equals(-1, -1, -1)) {
     lblETAMsg = '...';
   } else if (bus.eTA.equals(0, 0, -1)) {
     lblETAMsg = lbl_arriving.print();
   } else if (bus.eTA.equals(0, 0, -2)) {
     lblETAMsg = lbl_left.print();
   }


   String lblErMarg = '+00:00';
   if(bus.displayedOnMap){
     lblErMarg = '+' + (bus.expErMarg ~/ 60).toString().padLeft(2, '0') + ':' + (bus.expErMarg % 60).toInt().toString().padLeft(2, '0');
   }
   String lblTOAStart = '';
   String lblTOAEnd = '';

   if(bus.isHighLighted){
     //double time2Station = getEstTime2Station(selectedStations.elementAt(bus.stationNumber).distFromLineStart[bus.stationNumber]).toDouble();
     DateTime intervStart = TOA; //DateTime.fromMillisecondsSinceEpoch((bus.unixStartDT + time2Station) * 1000);
     DateTime intervEnd = intervStart.add(Duration(seconds: bus.expErMarg.toInt()));

     lblTOAStart = intervStart.hour.toString().padLeft(2, '0') + ':' + intervStart.minute.toString().padLeft(2, '0');
     lblTOAEnd = intervEnd.hour.toString().padLeft(2, '0') + ":" + intervEnd.minute.toString().padLeft(2, '0');
   }

   return Container(
     child: FadeIn(
       50 * listIndex.toDouble(),
       InkWell(
           onTap: (){
             if(bus.isHighLighted && scheduleTabLines.contains(bus.busLine)){
               scheduleTabLines.remove(bus.busLine);
             }
             bus.isHighLighted = !bus.isHighLighted;
             shiftText = !shiftText;
             redrawInfoBrd.add(1); /// test if laggy
             if(bus.displayedOnMap){
               mapController.move(
                   bus.busPos.busPoint, mapConfig.mapZoom);
             }
           },
           onHover: (isHovering){
             if(isHovering){
               bus.isTargMarkered = true;
               shiftText = true;
               redrawInfoBrd.add(1);
             }
             else{
               bus.isTargMarkered = false;
               redrawInfoBrd.add(1);
               shiftText = false;
             }
           },
           child:Container(
               width: constraints.width,
               padding: (bus.isHighLighted && !bus.reported && bus.displayedOnMap) ? EdgeInsets.only(bottom: constraints.width * _itemVerticalPadding + 20 * scaleRatio, top: constraints.width * _itemVerticalPadding, left: (constraints.width * _itemPadding), right: (constraints.width * _itemPadding)) : EdgeInsets.symmetric(vertical: constraints.width * _itemVerticalPadding, horizontal: (constraints.width * _itemPadding)),
               child: Container(
                 width: (_maxWidth * constraints.width),
                 //height: ,
                 decoration: BoxDecoration(
                   border: Border.all(
                     color: Colors.white,
                     width: 2 * scaleRatio,
                   ),
                   borderRadius: BorderRadius.all(
                       Radius.circular(5.0 * scaleRatio) //                 <--- border radius here
                   ),
                 ),
                 child: Column(
                   children: [
                     Row(
                       children: [
                         Container(
                           padding: EdgeInsets.only(left: (20 * scaleRatio)),
                           height: 65 * scaleRatio,
                           width: 160 * scaleRatio,
                           alignment: Alignment.centerLeft,
                           child:  Text(lblLineName, style: yellow(42, scaleRatio)),
                         ),
                         Container(
                           height: 65 * scaleRatio,
                           width: 45 * scaleRatio,
                           alignment: Alignment.center,
                           child:   Container(
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
                                 child: Text(stationLet, style: white(24, scaleRatio)),
                               )
                           ),//stationLetter(30, stationLet),
                         ),
                         Container(
                           height: 65 * scaleRatio,
                           width: 45 * scaleRatio,
                           alignment: Alignment.center,
                           child: Container(
                             width: 35 * scaleRatio,
                             height: 35 * scaleRatio,
                             decoration: BoxDecoration(
                               color: bus.lineColor,
                               border: Border.all(
                                 color: bus.lineColor,
                                 width: 2 * scaleRatio,
                               ),
                               borderRadius: BorderRadius.all(
                                   Radius.circular(18.5 * scaleRatio) //                 <--- border radius here
                               ),
                             ),
                           ),
                         ),
                         Container(
                           height: 65 * scaleRatio,
                           width: 225 * scaleRatio,
                           alignment: Alignment.centerRight,
                           child: Text(lblStartTime, style: white(36, scaleRatio),),
                         ),
                         Spacer(),
                         Container(
                           height: 65 * scaleRatio,
                           width: 215 * scaleRatio,
                           alignment: Alignment.centerLeft,
                           child: lblETAMsg.isEmpty
                               ? Text(lblETATime, style: yellow(36, scaleRatio))
                               : Text(lblETAMsg, style: yellow(36, scaleRatio).apply(fontSizeFactor: 0.8)),
                         ),
                         Container(
                             padding: EdgeInsets.only(right: (20 * scaleRatio)),
                             height: 65 * scaleRatio,
                             width: 205 * scaleRatio,
                             child: Row(
                               children: [
                                 Container(
                                     alignment: Alignment.centerLeft,
                                     child: Text(lblErMarg, style: white(28, scaleRatio),)
                                 ),
                                 Spacer(),
                                 Container(
                                     alignment: Alignment.centerRight,
                                     child: Icon(
                                       Icons.near_me,
                                       size: (48 * scaleRatio),
                                       color: bus.displayedOnMap ? Colors.white : Colors.white24,
                                     )
                                 )
                               ],
                             )
                         )
                       ],
                     ),
                     Row(
                       children: [
                         Container(
                           padding: EdgeInsets.only(left: (20 * scaleRatio)),
                           height: 50 * scaleRatio,
                           width: 475 * scaleRatio,
                           alignment: Alignment.centerLeft,
                           child: Text(lblBusDescription, style: white(28, scaleRatio)),
                         ),
                         Spacer(),
                         Container(
                             padding: EdgeInsets.only(right: (20 * scaleRatio)),
                             height: 50 * scaleRatio,
                             width: 215 * scaleRatio,
                             alignment: Alignment.centerLeft,
                             child: Text(lblTOA, style: yellow(28,scaleRatio),)
                         ),
                         Container(
                             padding: EdgeInsets.only(right: (20 * scaleRatio)),
                             height: 50 * scaleRatio,
                             width: 205 * scaleRatio,
                             alignment: Alignment.centerLeft,
                             child: Text(lblNickName, style: white(28, scaleRatio))
                         ),
                       ],
                     ),
                     arrivalInfo(bus,scaleRatio, lblTOAStart, lblTOAEnd),
                     accesInfo(bus, scaleRatio),
                     stationInfo(bus, scaleRatio),
                     feedBackPanel(bus, scaleRatio),
                   ],
                 ),
               )
           )
       ),
     )
   );
 }
 catch(E){
   print("[  ER  ] error creating bus widget: " + E.toString());
 }
}

Widget arrivalInfo(Bus bus, double scaleRatio, String lblTOAStart, String lblTOAEnd){
  final Color yellow = Color.fromARGB(255, 230, 168, 37);
  final TextStyle White28 = GoogleFonts.roboto(
      fontSize: (28 * scaleRatio),
      fontWeight: FontWeight.normal,
      color: Colors.white,
      letterSpacing: 1);
  final TextStyle Yellow28 = White28.apply(color: yellow);
  return bus.isHighLighted ?                                               /// Ocek. dolazak
  Row(
    children: [
      Container(
          padding: EdgeInsets.only(left: (20 * scaleRatio)),
          height: 65 * scaleRatio,
          width: 475 * scaleRatio,
          alignment: Alignment.centerLeft,
          child: Text("OČEKIVANI DOLAZAK IZMEĐU:", style: White28)
      ),
      Spacer(),
      Container(
          padding: EdgeInsets.only(right: (20 * scaleRatio)),
          height: 65 * scaleRatio,
          width: 420 * scaleRatio,
          alignment: Alignment.centerLeft,
          child: Text(lblTOAStart + " : " + lblTOAEnd, style: Yellow28)
      ),
    ],
  ) :
  Container();
}

Widget accesInfo(Bus bus, double scaleRatio){

  return bus.isHighLighted ?                                               /// Ramp
  Container(
      color: Color.fromARGB(255, 34, 34, 34),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: (20 * scaleRatio)),
            height: 65 * scaleRatio,
            width: 475 * scaleRatio,
            alignment: Alignment.centerLeft,
            child: bus.isRampAccesible ? Text("NISKOPODNI BUS SA RAMPOM", style: white(28,scaleRatio)) : Text("BUS BEZ RAMPE", style: white(28,scaleRatio)),
          ),
          Spacer(),
          Container(
              padding: EdgeInsets.only(right: (20 * scaleRatio)),
              height: 65 * scaleRatio,
              width: 420 * scaleRatio,
              alignment: Alignment.centerRight,
              child:  bus.isRampAccesible ? Icon(
                Icons.accessible_forward,
                size: 60 * scaleRatio ,
                color: Colors.white,
              ) : Icon(
                Icons.texture,
                size: 60 * scaleRatio ,
                color: uIYellow,
              )
          ),
        ],
      )
  ) :
  Container();
}

Widget stationInfo(Bus bus, double scaleRatio){
  return bus.isHighLighted ?                                               /// stanica
  Column(
    children: [
      Row(
        children: [
          Container(
              padding: EdgeInsets.only(left: (20 * scaleRatio)),
              height: 65 * scaleRatio,
              width: 900 * scaleRatio,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text("STANICA: ", style: white(28,scaleRatio)),
                  Text(selectedStations.elementAt(bus.stationNumber).name, style: white(28,scaleRatio).apply(color: Colors.white60)),
                ],
              )
          ),
        ],
      ),
      Row(
        children: [ /// put in function!!!
          InkWell(
            onTap: (){

            },
            child: Container(
              margin: EdgeInsets.only(left: (20 * scaleRatio)),
              width: 290 * scaleRatio,
              height: 70 * scaleRatio,
              decoration: BoxDecoration(
                //color: bus.lineColor,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2 * scaleRatio,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5 * scaleRatio) //                 <--- border radius here
                ),
              ),
              alignment: Alignment.center,
              child: Text("RED VOŽNJE", style: white(28,scaleRatio).apply(color: Colors.blueAccent)),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: (){
              if(scheduleTabLines.contains(bus.busLine)){
                scheduleTabLines.remove(bus.busLine);
              }
              else{
                scheduleTabLines.add(bus.busLine);
              }

            },
            child: Container(
              width: 290 * scaleRatio,
              height: 70 * scaleRatio,
              decoration: BoxDecoration(
                //color: bus.lineColor,
                color: scheduleTabLines.contains(bus.busLine) ? Colors.blueAccent : Colors.transparent,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2 * scaleRatio,
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(5 * scaleRatio) //                 <--- border radius here
                ),
              ),
              alignment: Alignment.center,
              child: Text("PRIKAZ LINIJE", style: scheduleTabLines.contains(bus.busLine) ? white(28,scaleRatio) : white(28,scaleRatio).apply(color: Colors.blueAccent)) ,
            ),
          ),
          Spacer(),
          InkWell(
              onTap: (){
                js.context.callMethod('open', ['https://www.google.com/maps/search/?api=1&query=' + selectedStations.elementAt(bus.stationNumber).pos.latitude.toString() + ',' + selectedStations.elementAt(bus.stationNumber).pos.longitude.toString() + '&z=14']);
              },
              child: Container(
                margin: EdgeInsets.only(right: (20 * scaleRatio)),
                width: 290 * scaleRatio,
                height: 70 * scaleRatio,
                decoration: BoxDecoration(
                  //color: bus.lineColor,
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2 * scaleRatio,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5 * scaleRatio) //                 <--- border radius here
                  ),

                ),
                alignment: Alignment.center,
                child: Text("MESTO NA GOOGLE", style: white(28,scaleRatio).apply(color: Colors.blueAccent)),
              )
          ),
        ],
      ),
    ],
  ) : Container();
}

Widget feedBackPanel(Bus bus, double scaleRatio){
  return bus.isHighLighted ? Column(
    children: [
      Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: (20 * scaleRatio)),
              height: 65 * scaleRatio,
              width: 900 * scaleRatio,
              alignment: Alignment.centerLeft,
              child:
              Text("OCENI TAČNOST VREMENA DOLASKA:", style: white(28,scaleRatio)),
            ),
          ]
      ),
      (!bus.reported && bus.displayedOnMap) ?  Container(
        transform: Matrix4.translationValues(0.0, 20.0 * scaleRatio, 0.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: (20 * scaleRatio)),
              child: SQRBtn(
                onTap: () {
                  bus.reported =  true;
                  postBusFeedBack("IN_STATION",true, bus,user);        /// TODO: evaluate if prediction is correct using ETA and ERmargin
                },
                scaleRatio: scaleRatio,
                icon: Icons.tour,
                iconSize: 74,
                color: Colors.blueAccent,
                btnLabel: "KONAČNO U STANICI",
              ),
            ),
            Spacer(),
            Container(
              child: SQRBtn(
                onTap: () {
                  bus.reported =  true;
                  postBusFeedBack("EARLY",false, bus,user);
                },
                scaleRatio: scaleRatio,
                icon: Icons.hourglass_top_rounded,
                iconSize: 74,
                color: Color.fromARGB(255, 200, 30, 30),
                btnLabel: "RANIJE",
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: (19 * scaleRatio)),
              child: SQRBtn(
                onTap: () {
                  bus.reported =  true;
                  postBusFeedBack("OK",true, bus,user);
                },
                scaleRatio: scaleRatio,
                icon: Icons.thumb_up,
                iconSize: 56,
                color: Colors.white,
                btnLabel: "NA VREME",
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: (19 * scaleRatio)),
              padding: EdgeInsets.only(right: (20 * scaleRatio)),
              child: SQRBtn(
                onTap: () {
                  bus.reported =  true;
                  postBusFeedBack("LATE",false, bus,user);
                },
                scaleRatio: scaleRatio,
                icon: Icons.hourglass_bottom_rounded,
                iconSize: 74,
                color: Color.fromARGB(255, 200, 30, 30),
                btnLabel: "KASNIJE",
              ),
            )
          ],
        ),
      ) : Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: (20 * scaleRatio)),
            height: 65 * scaleRatio,
            width: 900 * scaleRatio,
            alignment: Alignment.centerLeft,
            child: bus.reported ? Text(" POSLATA JE OCENA, HVALA!", style: white(28,scaleRatio)) : Text("TEK NAKON ŠTO JE KRENUO !", style: white(28,scaleRatio)),
          ),
        ],
      ),
    ],
  ) : Container();
}