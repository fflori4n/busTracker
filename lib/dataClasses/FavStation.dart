import 'package:mapTest/loadModules/loadStations.dart';
import 'Station.dart';

List<FavStation> favouriteStations = [];

class FavStation{
  String stationStr = '';
  String nickName = '';
  Station station;
  double priority = 1;

  FavStation.empty();
  FavStation(this.station, this.nickName, this.stationStr, this.priority);

  static int addFavStationfromStr(String stationStr,[String nickname = "", String priority = '1']){
    if(favouriteStations.isEmpty || ((favouriteStations.firstWhere((favStat) => favStat.stationStr == stationStr, orElse: () => null)) == null)){ /// TODO: double iteration, once here, then in factory, optimise this pls.
      favouriteStations.add(FavStation.fromString(stationStr, nickname, priority));
      return 0;
    }
    print('[  Wr  ] ' + stationStr + ' alredy favourite');
    return -1;
  }
  static int addFavStation(Station station, [String nickname = "", double priority = 1]){ /// add to favouriteStations, if not yet in list
    if(favouriteStations.isEmpty || ((favouriteStations.firstWhere((favStat) => favStat.stationStr == station.name, orElse: () => null)) == null)){ /// TODO: double iteration, once here, then in factory, optimise this pls.
      favouriteStations.add(FavStation(station, nickname, station.name, priority));
      print("added " + station.name + ' to favourites!');
      return 0;
    }
    print('[  Wr  ] ' + station.name + ' alredy favourite');
    return -1;
  }
  static void sortFavList(){
    /// TODO: implement me
  }
  /// stationStr,nickName,priority,
  factory FavStation.fromString(String stationStr, [String nickname = "", String priority = '1']){

    FavStation newFavStation = FavStation.empty();

    try{
      newFavStation.nickName = nickname;
      newFavStation.stationStr = stationStr;

      for(Station station in stationList){
       // print(station.name + " == " + newFavStation.stationStr);
        if(station.name == newFavStation.stationStr){
          newFavStation.station = station;
          break;
        }
      }

      if(newFavStation.station == null){
        newFavStation.station = new Station.empty();
        print('[  Wr  ] fav station: ' + newFavStation.stationStr + " - not found");
      }
      try{
        newFavStation.priority = double.parse(priority);
      }
      catch(E){
        newFavStation.priority = 1;
      }
    }
    catch(E){
      print("[  ER  ] parsing favstation string" + E.toString());
    }
    return newFavStation;
  }
  String toString(){
    return (this.stationStr + "," + this.nickName + "," + this.priority.toString() + "\n");
  }

}