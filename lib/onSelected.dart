
import 'package:mapTest/session/shared_pref.dart';

import 'dataClasses/BusLine.dart';
import 'geometryFuncts.dart';
import 'loadModules/busLines.dart';
import 'loadModules/busLocator.dart';
import 'loadModules/ldBusSchedule.dart';
import 'loadModules/stations.dart';

Future<void> onStationSelected() async {

  buslist.clear();
  activeStation.distFromLineStart.clear();
  for(int i=0; i< activeStation.servedLines.length; i++){   // init line from dist to be safe
    activeStation.distFromLineStart.add(0.0);
  }
  // TODO: copy in select closest station

  await loadLinesFromFile(activeStation.servedLines,false);
  calcDistFromLineStart();

  for(BusLine busLine in nsBusLines){
    ldLineSchedule(busLine, DateTime.now());
  }
  /*for(var busline in nsBusLines){   // create graphic station list
    returnStationOnLine(busline);
  }*/
  await writeCookie();                                          //TODO: find good place for writing cookie
}