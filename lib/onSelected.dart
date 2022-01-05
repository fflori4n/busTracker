import 'package:mapTest/session/shared_pref.dart';
import 'loadModules/busLines.dart';
import 'loadModules/busLocator.dart';
import 'loadModules/ldBusSchedule.dart';
import 'loadModules/loadStations.dart';
import 'main.dart';

Future<void> onStationSelected() async {
  selectedStations.last.setActiveFocused();
  buslist.clear();
  //selectedStations.clear();                                                   /// not very efficient, but fine for now
  nsBusLines.clear();
  for(var selectedStation in selectedStations){
    selectedStation.distFromLineStart.clear();
    for(int i=0; i< selectedStation.servedLines.length; i++){                   /// init line from dist to be safe
      selectedStation.distFromLineStart.add(0.0);
    }
  }
  ///
  
  await loadLinesFromJson(selectedStations, user.busLinesFile);                    // DBG TODO:
  calcDistFromLineStart();/// fill out buslinestart to station distance table
  loadBuses(selectedStations);

  await writeCookie();                                                          //TODO: find good place for writing cookie

  //FavStation.addFavStation(selectedStations.first, "",1);
  //saveFavouritesToLocal();

  //removeUnusedBusLines(); /// dgb
  //redrawInfoBrd.add(1);
}