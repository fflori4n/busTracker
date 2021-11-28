import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/uiElements/infoDisp.dart';
import '../filters.dart';
import '../geometryFuncts.dart';
import '../main.dart';
import 'loadStations.dart';

//final LatLng initMapCenter = new LatLng(0, 0);
const double avrgBusSpeed = 17;
const double slownessFactor = 0.5;

List<Bus> buslist = []; /// TODO: convert to static? instead of global
bool changeFlag = false;

void calcBusPos() {
  var unixNow = new DateTime.now().millisecondsSinceEpoch~/1000;                /// now seconds
  //unixNow += 3600;  // 7200 when no daylight saving

  for (var bus in buslist) {
    updateBusPos(bus, unixNow);                                                 /// func. to update position down below
    updateBusTime(bus, unixNow);

    /*if (bus.eTA.sex == -1) {                                                    /// decrease ER margin timer when bus is arriving
      bus.expErMarg.decrease(Time(0, 0, 1));
    }*/
  }
  if(changeFlag){                                                               /// sort all buses if time has changed
    changeFlag = false;
    sortAllByEta();
  }
  redrawInfoBrd.add(1);                                                         /// refresh values on infobrd
}

double getEstDistPassed(var reftime, var startTime) {                                        /// basic estimation of pos for const speed
  var elapsedTime = reftime - startTime;
  //print("timediff" + elapsedTime.toString());
  var distance = (elapsedTime) * 0.2777 * avrgBusSpeed; //1000/3600
  //print('Est dist: ' + distance.round().toString() + ' m');
  return distance;
}
int getEstTime2Station(double dist2Station){
  return dist2Station ~/ (0.2777 * avrgBusSpeed);
}

void sortByEta(Bus bus) {
                                                                                /// TODO: convert everithing to index instead of ref.
  int busIndex = buslist.indexOf(bus);
  if ((busIndex - 1) > 0) {
    double prevBusSex = buslist[busIndex - 1].unixStartDT;
    if (prevBusSex > bus.unixStartDT) {
      Bus temp = buslist[busIndex];
      buslist[busIndex] = buslist[busIndex - 1];
      buslist[busIndex - 1] = temp;
    }
  }
}

void sortAllByEta() {
  for (int i = 0; i < (buslist.length - 1); i++) {
    bool flg = true;
    for (int j = 0; j < (buslist.length - 1); j++) {
      if (buslist[j].unixStartDT > buslist[j + 1].unixStartDT) {
        Bus temp = buslist[j];
        buslist[j] = buslist[j + 1];
        buslist[j + 1] = temp;
        flg = false;
      }
    }
    if (flg) {
      return;
    }
  }
}

int updateBusPos(Bus bus, var refTime) {                                   /// TODO: mayor bug here probably? trows a bunch of exceptions in subotica
  double distPassed;

  try {
    if (bus.noPosUpdateTicks > 0) {                                             /// do not update position on map
      bus.noPosUpdateTicks--;
    } else if (bus.noPosUpdateTicks == 0) {                                     /// try to display/update pos of bus on map
      double elapsedTime = refTime - bus.unixStartDT;

      if (elapsedTime < 0) {                                                    /// not departed - not displayed
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = elapsedTime.abs() * 1000 ~/ mapRefreshPeriod;    /// TODO: make it const
        return 0;
      }
      //print('calculating bus' + bus.nickName);
      distPassed = getEstDistPassed(refTime, bus.unixStartDT);
      bus.busPos = getPOnPolyLineByDist(distPassed, bus.busLine.points);

      if (bus.busPos.busPoint == LatLng(-1, -1)) {                              /// bus is not on path, so it completed the route
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = -1; // never update Pos
        return 0;
      }

      bus.displayedOnMap = true;
      bus.noPosUpdateTicks = 1000 ~/ mapRefreshPeriod; // bus pos update time
    }
  } catch (e) {
    print('[  ER  ] calculate Pos: ' + bus.nickName + '--' + e.toString());
    return -1;
  }
  return 0;
}
int updateBusTime(Bus bus, var unixNow){

  if (bus.noEtaUpdateTicks > 0) {
    bus.noEtaUpdateTicks--;
    if (bus.eTA.hours <= 0 && bus.eTA.mins < 15 && bus.eTA.inSex() > 0) {       /// do not update if time is more than 15mins
      bus.eTA.decrease(Time(0, 0, 1));
    }
  } else if (bus.noEtaUpdateTicks == 0) {
    bus.noEtaUpdateTicks = 15000 ~/ mapRefreshPeriod;                           /// every 15 sex

    try {
      Time eta = new Time(0, 0, 0);
      bool containsLine = false;


      for (var selectedStation in selectedStations) {
        if (selectedStation.servedLines.contains(bus.busLine.name) && selectedStations.indexOf(selectedStation) == bus.stationNumber) {
          containsLine = true;
          int i = selectedStation.servedLines.indexOf(bus.busLine.name);

          int time2StationSex = getEstTime2Station(selectedStation.distFromLineStart[i]);
          bus.expErMarg = time2StationSex * slownessFactor;
          //print('time to station ' + time2StationSex.toString());

         if(bus.unixStartDT + time2StationSex + bus.expErMarg < unixNow){ /// bus left
            eta.sex = -2;
            bus.expErMarg = 0;
            bus.noEtaUpdateTicks = -1; /// never update this
            bus.setETA(eta);
            filterBus(bus, busFilters);
            continue;
          }
          if((bus.unixStartDT + time2StationSex < unixNow) && (unixNow < bus.unixStartDT + time2StationSex + bus.expErMarg)){                      ///bus is arriving
            eta.sex = -1;
            bus.setETA(eta);
            filterBus(bus, busFilters);
            continue;
          }
          double uETA =(bus.unixStartDT + time2StationSex) - unixNow;
          //print('eta for' + bus.nickName + " " + uETA.toString());


          eta.hours = uETA ~/ 3600;
          uETA %= 3600;
          eta.mins = uETA ~/ 60;
          if (eta.hours != 0 || eta.mins > 30)
            eta.sex = 0;
          else
            uETA %= 60;
          eta.sex = uETA.toInt();

          if(!bus.eTA.equals(eta.hours, eta.mins, eta.sex)){
            bus.setETA(eta);
            changeFlag = true;
          }
        }
      }
      if (containsLine == false) {
        print('[  Wr  ] bus not found in servedlines - skipping and removing');
        buslist.remove(bus);
        return -1;
      }
    } catch (e) {
      print('[  ER  ] cant calculate ETA for: ' + bus.nickName + '--' + e.toString());
    }
  }
}