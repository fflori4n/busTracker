
import 'package:mapTest/session/shared_pref.dart';
import 'dataClasses/Bus.dart';
import 'dataClasses/BusLine.dart';
import 'loadModules/busLines.dart';
import 'loadModules/busLocator.dart';
import 'loadModules/ldBusSchedule.dart';
import 'loadModules/loadStations.dart';
import 'main.dart';

Future<void> onStationSelected() async {

  buslist.clear();                                                              // not very efficient, but fine for now
  for(var selectedStation in selectedStations){
    selectedStation.distFromLineStart.clear();
    for(int i=0; i< selectedStation.servedLines.length; i++){                   // init line from dist to be safe
      selectedStation.distFromLineStart.add(0.0);
    }
    //print('DBG DBG -- ' + selectedStation.servedLines.toString());
  }

  //await loadLinesFromFile(selectedStations,false);                            /// Load busline points for active bus lines
  ///
  
  await loadLinesFromJson(selectedStations, busLineCityStr);                    // DBG TODO:
  calcDistFromLineStart();/// fill out buslinestart to station distance table
  loadBuses(selectedStations);

  await writeCookie();                                                          //TODO: find good place for writing cookie

  removeUnusedBusLines(); /// dgb
}