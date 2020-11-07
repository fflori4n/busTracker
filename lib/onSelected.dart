
import 'package:mapTest/session/shared_pref.dart';
import 'loadModules/busLines.dart';
import 'loadModules/busLocator.dart';
import 'loadModules/ldBusSchedule.dart';
import 'loadModules/stations.dart';

Future<void> onStationSelected() async {

  buslist.clear();
  for(var selectedStation in selectedStations){
    selectedStation.distFromLineStart.clear();
    for(int i=0; i< selectedStation.servedLines.length; i++){   // init line from dist to be safe
      selectedStation.distFromLineStart.add(0.0);
    }
    print('DBG DBG -- ' + selectedStation.servedLines.toString());
  }

  await loadLinesFromFile(selectedStations,false);
  calcDistFromLineStart();

  for(var selectedStation in selectedStations){
    for(var line in selectedStation.lines){
      ldLineSchedule(line,selectedStations.indexOf(selectedStation).toString(), DateTime.now());
    }
  }

  await writeCookie();                                          //TODO: find good place for writing cookie
}