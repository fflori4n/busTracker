

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/UIColors.dart';

class navBar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.topCenter,
      color: baseBlack,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Expanded(child: SizedBox()),
          //clock()
          Text('hello navbar'),
        ],
      )
    );
  }
}

class clock extends StatefulWidget {
  clockState createState() => clockState();
}

class clockState extends State<clock> {

  DateTime _now = DateTime.now();
  @override
  void initState(){
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
        _now = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_now.hour.toString() + ':'+ _now.minute.toString() + ':' + _now.second.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
                color: baseWhite,
                fontWeight: FontWeight.bold,
                fontSize: 25)
        ),
        Text(
          'mon' + '. ' + _now.day.toString() + '. ' + _now.month.toString() + '. ' +_now.year.toString() + '.', textAlign: TextAlign.right,
          style: TextStyle(
            color: baseYellow
          ),
        )
      ],
    );
  }
}