import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapTest/uiElements/UIColors.dart';
import 'package:mapTest/loadModules/ldBusSchedule.dart';

Future<Column> _readSingleScheduleFromJson(String selectedLine) async{
  String raw = await loadScheduleAsText(selectedLine);
  String outStr = '';
  for(var line in raw.split('\n')){
    line.replaceAll(' ', '\t\t ');
    if(line[0] != '#'){
      outStr+= line + '\n';
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(outStr, style: infoBrdSmall,),
    ],
  );

}

Widget showSchedule(BuildContext context,double maxWidth, String selectedLine) {
  return FutureBuilder<Column>(
      future: _readSingleScheduleFromJson(selectedLine),                                                     /// asunc load shedule
      builder: (BuildContext context, AsyncSnapshot<Column> snapshot) {
        Column children;

        if (snapshot.hasData) {
          children = snapshot.data;
        } else if (snapshot.hasError) {
          children = Column(
            children: [
              Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
              )
            ],
          );
        } else {
          children = Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(maxWidth/50),
                  child: CircularProgressIndicator(),
                  width: maxWidth/10,
                  height: maxWidth/10,
                ),
              )
            ],
          );
        }
        return children;
      },
  );
}