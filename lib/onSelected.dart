
import 'package:mapTest/dataClasses/FavStation.dart';
import 'package:mapTest/session/favStations.dart';
import 'package:mapTest/session/shared_pref.dart';
import 'package:mapTest/uiElements/mobileOnlyElements/overMapDisp.dart';
import 'loadModules/busLines.dart';
import 'loadModules/busLocator.dart';
import 'loadModules/ldBusSchedule.dart';
import 'loadModules/loadStations.dart';
import 'main.dart';

Future<void> onStationSelected() async {

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
  redrawOverMapDisp.add(1);                                                     // TODO: cool, but dont do it here
  calcDistFromLineStart();/// fill out buslinestart to station distance table
  loadBuses(selectedStations);

  await writeCookie();                                                          //TODO: find good place for writing cookie

  if(((favouriteStations.firstWhere((favStat) => favStat.stationStr == selectedStations.first.name, orElse: () => null)) == null)){  /// do not add same favourite multiple times
    favouriteStations.add(FavStation(selectedStations.first, "", selectedStations.first.name,1)); /// DBG DBG
  }
  saveFavouritesToLocal();

  //removeUnusedBusLines(); /// dgb
}