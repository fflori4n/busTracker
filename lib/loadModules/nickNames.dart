import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/Time.dart';

void loadNickName(Bus busRef) async{
  Time startTime = busRef.startTime;
  String busLineName = busRef.busLine;
  try {
    String hashIn = busLineName + startTime.hours.toString() + startTime.mins.toString() + startTime.sex.toString();
    String digest = sha1.convert(utf8.encode(hashIn)).toString().replaceAllMapped(RegExp(r'[^0-9]'), (match) {return '';});
    var rand = new Random(int.parse(digest));
    //print(hashIn);
    print(rand.nextInt(1));

    String fileName = 'muskaImena.txt';
    if(rand.nextInt(2) == 0){
      fileName = 'zenskaImena.txt';
    }
    String rawFileContent = await rootBundle.loadString('nameLists/' + fileName);
    List<String> lines = rawFileContent.split('\n');
    String newNickName = lines.elementAt(rand.nextInt(lines.length)).trim();
    busRef.nickName = newNickName;

  }
  catch(e) {
    print('[  Er  ] laoding nickname: ' + e);
  }
}