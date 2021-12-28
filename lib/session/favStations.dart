import 'package:mapTest/dataClasses/FavStation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveFavouritesToLocal() async {
  print("saving favstation to local");
  if(favouriteStations.isEmpty){  /// nothing to save, no favourites
    return;
  }
  String favStationsStr = "";
  for(var favstation in favouriteStations){
    favStationsStr += favstation.toString();
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fav_stat', favStationsStr);
}
Future<void> loadFavouritesFromLocal() async {                                  /// TODO: this is called from loadStations.dart
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String raw = prefs.getString('fav_stat');
  if(raw == null || raw.isEmpty){
    return;
  }
  List<String> favStatElements = raw.split('\n');                                          /// TODO: ',' in name or nickname can break it FIX THIS!!
  for(String favStatSrt in favStatElements){
    if(favStatSrt.isEmpty){
      favStatElements.remove(favStatSrt);
      print("removed fav");
      continue;
    }
    List<String> favAtrib = favStatSrt.split(',');
    if(favAtrib.length < 3 || favAtrib[0].length == 0){
      print('skippin');
      continue;
    }
    FavStation.addFavStationfromStr(favAtrib.elementAt(0), favAtrib.elementAt(1),favAtrib.elementAt(2));
  }
}