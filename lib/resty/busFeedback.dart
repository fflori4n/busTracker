import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/dataClasses/user.dart';
import 'package:mapTest/loadModules/loadStations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


Future<void> postBusFeedBack(String btn,bool isOK, Bus bus,User user) async {

  final postLmt = 5;
  final timeLmtMins = 5;

  print('feedBack: sent these thing to server');
  print('button pressed  \t' + btn);                          //
  print('busline   \t' + bus.busLine.name.toString());                          //
  print('bus ETA   \t' + bus.eTA.toString());                                   //
  print('bus ExpEr \t' + bus.expErMarg.toString());                     //
  print('startTime \t' + bus.startTime.inSex().toString());                     //
  print('station   \t' + selectedStations[bus.stationNumber].name);             //
  print('stationPOS\t' + selectedStations[bus.stationNumber].pos.toString());   //
  print('isOK      \t' + isOK.toString());                                      //
  print('userPos   \t' + user.position.toString());
  print('bus       \t' + bus.nickName);

  //String ua = await FlutterUserAgent.getPropertyAsync('userAgent');
  print(DateTime.now().toLocal().toString());
  //print(ua);

  print('___________________');

  /// read local storage to get number of sent req, and date of last POST
  try{
    String msg = await checkLocalStorage();
    if(msg == 'null'){
      print('msg is null');
      makePostRequest(isOK,bus,user,btn);//sendFeedback('hello world!');
      writeToLocalStorage(1);
    }
    else{
      var data = msg.split(',');
      double numOfReq = double.parse(data[0]);
      print('num of req:' + numOfReq.toString());
      if(numOfReq < postLmt){                                                   /// post feedback, if number is small
        makePostRequest(isOK,bus,user,btn);//sendFeedback('hello world!');
        writeToLocalStorage((numOfReq + 1));
      }
      else{                                                                     /// check time of last post, and clear number if time passed
        DateTime lastPost = DateTime.parse(data[1]);
        if(DateTime.now().difference(lastPost).inMinutes > timeLmtMins){
          makePostRequest(isOK,bus,user,btn);
          writeToLocalStorage(1);
        }
        else{
          print('[  Wr  ]  too many requests!');
        }
      }
    }
  }
  catch(e){
    print('[  Er  ]  cant read local storage: ' + e);
    return;
  }
}

Future<String> checkLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('bus_feedback').toString();
}
Future<void> writeToLocalStorage(double numOfReq) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bus_feedback', numOfReq.toString() + ',' + DateTime.now().toString());
}

makePostRequest(bool isOK, Bus bus,User user, String btn) async {
  Uri url = new Uri.http("sandorr.eunetddns.net", "/logResponse.php");
  //String json = '{"bus_stop":"'+selectedStations[bus.stationNumber].name+'","bus_stop_pos": "'+selectedStations[bus.stationNumber].pos.toString()+'","isOK": '+isOK.toString()+',"bus_line" = "' + bus.busLine.name.toString() + '", "bus_start_time" = "' + bus.startTime.toString()+ '","bus_ETA" = "' +bus.eTA.toString()+ '", "bus_exp_er" = "' + bus.expErMarg.toString()+ '", "user_pos" = "' + user.position.toString()+ '"}';
  for(int i=0; i<10; i++){
    try{
      http.Response response = await http.post(url, body: {
        "button_pressed" : btn,
        "bus_stop" : selectedStations[bus.stationNumber].name,
        "bus_stop_pos" : selectedStations[bus.stationNumber].pos.toString(),
        "isOK" : isOK.toString(),
        "bus_line" : bus.busLine.name.toString(),
        "bus_start_time" : bus.startTime.toString(),
        "user_time" : DateTime.now().toLocal().toString(),
        "bus_ETA" : bus.eTA.toString(),
        "bus_exp_er" : bus.expErMarg.toString(),
        "user_pos" : user.position.toString(),
        //"user_agent" : ua,
      });
      int statusCode = response.statusCode;
      //String body = response.body;
      if(statusCode == 200){
        print('msg sent!:' + statusCode.toString());                            //DBG
        break;
      }
      else{
        print('[  Wr  ]  could not send:' + statusCode.toString());
      }
    }
    catch(e){
      print('[  Wr  ]  exc. while sending:' + e);
    }
  }
}