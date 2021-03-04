import 'dart:math';
import 'dart:convert';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/Time.dart';

Future loadNickName(Bus busRef) async{
  Time startTime = busRef.startTime;
  String busLineName = busRef.busLine.name;
  try {
    String hashIn = busLineName + startTime.hours.toString() + startTime.mins.toString() + startTime.sex.toString();
    String digest = sha1.convert(utf8.encode(hashIn)).toString().replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
    var rand = new Random(int.parse(digest));
    //print(hashIn);
    //print(rand.nextInt(1));

    String fileName = 'muskaImena.txt';
    if(rand.nextInt(2) == 0){
      fileName = 'zenskaImena.txt';
    }
    String rawFileContent = await rootBundle.loadString('nameLists/' + fileName);
    List<String> lines = rawFileContent.split('\n');
    String newNickName = lines.elementAt(rand.nextInt(lines.length)).trim();
    busRef.nickName = newNickName;
    return;
  }
  catch(e) {
    print('[  Er  ] laoding nickname: ' + e);
    return;
  }
}

Color giveMeColor(String seed){
  String digest = sha1.convert(utf8.encode(seed)).toString().replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
  var rand = new Random(int.parse(digest));
  // #458BFA
  double hue = 45; //new Random(int.parse(digest));
  double sat = 139;
  double light = 250; // const
  //r = min + rnd.nextInt(max - min);
  sat = sat -50 + rand.nextInt(70+50);
  hue = hue -45 + rand.nextInt(255);
  HSLColor newColor = new HSLColor.fromAHSL(1, hue, sat, light);
  return newColor.toColor();

}