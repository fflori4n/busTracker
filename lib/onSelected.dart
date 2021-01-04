
import 'package:mapTest/session/shared_pref.dart';
import 'loadModules/busLines.dart';
import 'loadModules/busLocator.dart';
import 'loadModules/ldBusSchedule.dart';
import 'loadModules/stations.dart';

Future<void> onStationSelected() async {

  buslist.clear();                                                              // not very efficient, but fine for now
  for(var selectedStation in selectedStations){
    selectedStation.distFromLineStart.clear();
    for(int i=0; i< selectedStation.servedLines.length; i++){                   // init line from dist to be safe
      selectedStation.distFromLineStart.add(0.0);
    }
    //print('DBG DBG -- ' + selectedStation.servedLines.toString());
  }

  await loadLinesFromFile(selectedStations,false);                              /// Load busline points for active bus lines
  calcDistFromLineStart();                                                      /// fill out buslinestart to station distance table

  for(var selectedStation in selectedStations){
    for(var line in selectedStation.lines){
      ldLineSchedule(line,DateTime.now(),selectedStations.indexOf(selectedStation));
    }
  }

  await writeCookie();                                                          //TODO: find good place for writing cookie
}