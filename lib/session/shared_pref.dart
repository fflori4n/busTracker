import 'package:flutter/material.dart';
import 'package:mapTest/dataClasses/Show.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart'; // rememeber to import shared_preferences: ^0.5.4+8

/// from https://stackoverflow.com/questions/56417667/how-to-save-to-web-local-storage-in-flutter-web
/// slamarseillebg

class UserDefaults{

  place() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('user', user.toString());
    await prefs.setString('filters', busFilters.toString());
  }
  read() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(prefs.getInt('user'));
    print(prefs.getInt('filters'));
  }
}
