
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/multiLang.dart';
import 'package:mapTest/dataClasses/user.dart';
import 'package:mapTest/infoBoardItem/indicator.dart';
import 'package:mapTest/location/locationTest.dart';

import '../UIColors.dart';
import '../main.dart';

Widget showTabs(User user){
  double totalWidth = screenWidth;
  //double totalHeight = 60;//screenHeight * 0.08;

  if(user.tabOpen == 0){
    return Container();
  }

  return SizedBox(
      width: totalWidth,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(46, 46, 46, 1),
        ),
        child: getTab(user.tabOpen),
      ),
  );
}

Column getTab(int tabNum){
  if(tabNum == 1){
    return Column(
      children: <Widget>[
        Text("hello"),
        Text("hello"),
        Text("hello"),
        Text("hello"),
      ],
    );
  }
  else if(tabNum == 2){ /// location
    bool isSwitched = false;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: /*GestureDetector(
              onTap: () {
                user.locationEnabled = !user.locationEnabled;
                if(user.locationEnabled){
                  updatePos();
                }
              },
              child:*/ Row(
                children: <Widget>[
                  Text('location enabled',style: infoBrdSmall,),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Switch(
                      value: isSwitched,
                      onChanged: (value){
                        user.locationEnabled = isSwitched = value;
                        if(user.locationEnabled){
                          updatePos();
                        }
                        //print(value.toString());
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ),],
              )
          ),
       // ),

        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: GestureDetector(
              onTap: () {
                user.cookiesEnabled = !user.cookiesEnabled;
              },
              child: Row(
                children: <Widget>[
                  Text('cookies enabled',style: infoBrdSmall,),
                  Spacer(),
                  Container(
                    child: indicator(baseBlue, baseYellow, Color.fromRGBO(46, 46, 46, 1), !user.cookiesEnabled),
                    height: infoBrdSmall.fontSize,
                  ),],
              )
          ),
        ),
      ],
    );
  }
  else if(tabNum == 3){ /// settings
    return Column(
      children: <Widget>[
        Container(  // switch language
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: GestureDetector(
              onTap: () {
                final List<String> languages = ['srb','eng','hun']; // TODO: use array instead of string
                int i = languages.indexOf(activeLang);
                if(i < languages.length - 1)
                  i++;
                else
                  i=0;

                activeLang = languages[i];
              },
              child: Row(
                children: <Widget>[
                  Text('language:',style: infoBrdSmall,),
                  Spacer(),
                  Text(activeLang,style: infoBrdSmall,),],
              )
          ),
        ),
      ],
    );
  }
  else if(tabNum == 4){ /// #filters
    return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                child: GestureDetector(
                  onTap: () {
                    busFilters.hideLine.clear();
                  },
                  child: Row(
                    children: <Widget>[
                      Text(lbl_filt_hiddenLines.print(),style: infoBrdSmall,),
                      Spacer(),
                      Text(busFilters.hideLine.toString(),style: infoBrdSmall,),
                    ],),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                child: GestureDetector(
                    onTap: () {
                      busFilters.left = !busFilters.left;
                      busFilters.refreshFlg = true;
                    },
                    child: Row(
                      children: <Widget>[
                        Text(lbl_filt_leftBuses.print(),style: infoBrdSmall,),
                        Spacer(),
                        Container(
                          child: indicator(baseBlue, baseYellow, Color.fromRGBO(46, 46, 46, 1), !busFilters.left),
                          height: infoBrdSmall.fontSize,
                        ),],
                    )
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                child: GestureDetector(
                    onTap: () {
                      busFilters.eTAgt15mins = !busFilters.eTAgt15mins;
                      busFilters.refreshFlg = true;
                    },
                    child: Row(
                      children: <Widget>[
                        Text(lbl_filt_eta1.print(),style: infoBrdSmall,),
                        Spacer(),
                        Container(
                          child: indicator(baseBlue, baseYellow, Color.fromRGBO(46, 46, 46, 1), busFilters.eTAgt15mins),
                          height: infoBrdSmall.fontSize,
                        ),],
                    )
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                child: GestureDetector(
                    onTap: () {
                      busFilters.next10only = !busFilters.next10only;
                      busFilters.refreshFlg = true;
                    },
                    child: Row(
                      children: <Widget>[
                        Text(lbl_filt_onlyFirst10.print(),style: infoBrdSmall,),
                        Spacer(),
                        Container(
                          child: indicator(baseBlue, baseYellow, Color.fromRGBO(46, 46, 46, 1), !busFilters.next10only),
                          height: infoBrdSmall.fontSize,
                        ),],
                    )
                ),
              ),
            ],
    );
  }
  return Column();
}