
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/resty/busFeedback.dart';

import 'UIColors.dart';
import '../main.dart';

Widget feedBackThumbs(Bus bus, double maxWidth){
  maxWidth*= 0.85;
  if(!bus.reported && bus.displayedOnMap){
    return Row(
      children: [

        Container(
          margin: EdgeInsets.only(left: 0, right: maxWidth/50, top: maxWidth/50, bottom: maxWidth/50),
          width: maxWidth/10,
          height: maxWidth/10,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: new BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Tooltip(
              message: 'Stigao je bus, dobra predikcija!',
              child:  FlatButton(
                onPressed: (){
                  bus.reported =  true;
                  postBusFeedBack(true, bus,user);
                  // TODO: implement feedback POST
                },
                child: Center(
                  child: Icon(
                    Icons.thumb_up,
                    color: Colors.white,
                    size: maxWidth/20,
                  ),
                ),
              )
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 0, right: maxWidth/50, top: maxWidth/50, bottom: maxWidth/50),
          width: maxWidth/10,
          height: maxWidth/10,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: new BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Tooltip(
              message: 'Nije došao na vreme, loša predikcija!',
              child:  FlatButton(
                onPressed: (){
                  bus.reported =  true;
                  postBusFeedBack(false, bus,user); // TODO: implement feedback POST
                },
                child: Center(
                  child: Icon(
                    Icons.thumb_down,
                    color: Colors.white,
                    size: maxWidth/20,
                  ),
                ),
              )
          ),
        ),
      ],
    );
  }
  else if(!bus.reported && !bus.displayedOnMap){
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 0, right: maxWidth/50, top: maxWidth/50, bottom: maxWidth/50),
          width: maxWidth/10,
          height: maxWidth/10,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: new BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Tooltip(
              message: 'Nije krenuo bus, ne možete glasati!',
              child:  Center(
                  child: Icon(
                    Icons.thumb_up,
                    color: Colors.white,
                    size: maxWidth/20,
                  ),
                ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 0, right: maxWidth/50, top: maxWidth/50, bottom: maxWidth/50),
          width: maxWidth/10,
          height: maxWidth/10,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: new BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Tooltip(
              message: 'Nije krenuo bus, ne možete glasati!',
              child:  Center(
                  child: Icon(
                    Icons.thumb_down,
                    color: Colors.white,
                    size: maxWidth/20,
                  ),
                ),
          ),
        ),
      ],
    );
  }
  else{
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 0, right: maxWidth/50, top: maxWidth/50, bottom: maxWidth/50),
          width: maxWidth/5 + maxWidth/50,
          height: maxWidth/10,
          decoration: BoxDecoration(
            //color: Colors.grey,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: new BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Tooltip(
            message: 'Poslato je. Hvala!',
            child:  Center(
              child:  Text('Hvala!', style: TextStyle(color: baseWhite))
            ),
          ),
        ),
      ],
    );
  }
}