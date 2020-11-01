import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/multiLang.dart';

import '../UIColors.dart';
import '../main.dart';
import 'indicator.dart';

Widget FilterTab() {
  if (!user.filtTabOpen) {
    return Container();
  }
  return Column(
    children: <Widget>[
      Container(
        // margin: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
        padding:
            EdgeInsets.only(left: 17.0, right: 17.0, top: 6.0, bottom: 4.0),
        color: baseBlack,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 2, bottom: 5),
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
              padding: EdgeInsets.only(top: 2, bottom: 2),
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
                        child: indicator(baseBlue, baseYellow, baseBlack, !busFilters.left),
                        height: infoBrdSmall.fontSize,
                      ),],
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 2, bottom: 2),
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
                        child: indicator(baseBlue, baseYellow, baseBlack, busFilters.eTAgt15mins),
                        height: infoBrdSmall.fontSize,
                      ),],
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 2, bottom: 2),
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
                        child: indicator(baseBlue, baseYellow, baseBlack, !busFilters.next10only),
                        height: infoBrdSmall.fontSize,
                      ),],
                  )
              ),
            ),

            Container(  // switch language
              padding: EdgeInsets.only(top: 2, bottom: 2),
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
        ),
      ),
      Container(
        decoration: new BoxDecoration(
          color: baseWhite,
        ),
        height: 1,
        //margin: EdgeInsets.only(bottom: 5.0),
      ),
    ],
  );
}
