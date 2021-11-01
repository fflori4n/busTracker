import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/uiElements/infoDisp.dart';
import '../filters.dart';
import '../geometryFuncts.dart';
import '../main.dart';
import 'loadStations.dart';

final LatLng initMapCenter = new LatLng(0, 0);
const double avrgBusSpeed = 17;

List<Bus> buslist = [];
//bool isSorted = false;                                                          /// TODO: convert to static? instead of global
bool changeFlag = false;

void calcBusPos() {
  DateTime refTime = DateTime.now();

  for (var bus in buslist) {
    updateBusPos(bus, refTime);                                                 /// func. to update position down below
    updateBusTime(bus);

    if (bus.eTA.sex == -1) {                                                    /// decrease ER margin timer when bus is arriving
      bus.expErMarg.decrease(Time(0, 0, 1));
    }
  }
  if(changeFlag){                                                               /// sort all buses if time has changed
    changeFlag = false;
    sortAllByEta();
  }
  redrawInfoBrd.add(1);                                                         /// refresh values on infobrd
}

double getEstDistPassed(var startTime) {                                        /// basic estimation of pos for const speed
  int elapsedTime;
  if (startTime is Time) {                                                      /// is = instanceof in dart ;) cool
    DateTime now = DateTime.now();
    DateTime startDateTime = new DateTime(now.year, now.month, now.day,
        startTime.hours, startTime.mins, startTime.sex);
    elapsedTime = now.difference(startDateTime).inSeconds;
  } else if (startTime is int) {
    elapsedTime = startTime;
  }
  double distance = (elapsedTime) * 0.2777 * avrgBusSpeed; //1000/3600
  // print('Est dist: ' + distance.round().toString() + ' m');
  return distance;
}

void sortByEta(Bus bus) {
                                                                                /// TODO: convert everithing to index instead of ref.
  int busIndex = buslist.indexOf(bus);
  if ((busIndex - 1) > 0) {
    int prevBusSex = buslist[busIndex - 1].eTA.inSex();
    if (prevBusSex > bus.eTA.inSex()) {
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
      if (buslist[j].eTA.inSex() > buslist[j + 1].eTA.inSex()) {
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

int updateBusPos(Bus bus, DateTime refTime) {
  double distPassed;

  try {
    if (bus.noPosUpdateTicks > 0) {                                             /// do not update position on map
      bus.noPosUpdateTicks--;
    } else if (bus.noPosUpdateTicks == 0) {                                     /// try to display/update pos of bus on map
      DateTime startDateTime = new DateTime(
          refTime.year,
          refTime.month,
          refTime.day,
          bus.startTime.hours,
          bus.startTime.mins,
          bus.startTime.sex);
      int elapsedTime = refTime.difference(startDateTime).inSeconds;

      if (elapsedTime < 0) {                                                    /// not departed - not displayed
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = elapsedTime.abs() * 1000 ~/ mapRefreshPeriod;
        return 0;
      }

      distPassed = getEstDistPassed(elapsedTime);
      bus.busPos = getPOnPolyLineByDist(distPassed, bus.busLine.points);

      if (bus.busPos.busPoint == LatLng(-1, -1)) {                              /// bus is not on path, so it completed the route
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = -1; // never update Pos
        return 0;
      }

      // TODO: check if same bus is displayed for other station, do not draw double bus
      /*if(bus.findInBuslist() != buslist.indexOf(bus)){    // TODO: this but faster
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = -1;
        return 0;
      }*/

      bus.displayedOnMap = true;
      bus.noPosUpdateTicks = 1000 ~/ mapRefreshPeriod; // bus pos update time
    }
  } catch (e) {
    print('[  ER  ] calculate Pos: ' + bus.nickName + '--' + e.toString());
    return -1;
  }
  return 0;
}
int updateBusTime(Bus bus){
  double distPassed;

  if (bus.noEtaUpdateTicks > 0) {
    bus.noEtaUpdateTicks--;
    if (bus.eTA.hours <= 0 && bus.eTA.mins < 15 && bus.eTA.inSex() > 0) {       /// do not update if time is more than 15mins
      bus.eTA.decrease(Time(0, 0, 1));
    }
  } else if (bus.noEtaUpdateTicks == 0) {
    bus.noEtaUpdateTicks = 15000 ~/ mapRefreshPeriod; // every 15 sex

    try {
      Time eta = new Time(0, 0, 0);
      bool containsLine = false;
      double postStationDist;

      for (var selectedStation in selectedStations) {
        if (selectedStation.servedLines.contains(bus.busLine.name) &&
            selectedStations.indexOf(selectedStation) == bus.stationNumber) {
          containsLine = true;
          int i = selectedStation.servedLines.indexOf(bus.busLine.name);

          distPassed = getEstDistPassed(bus.startTime);
          postStationDist =
          (selectedStation.distFromLineStart[i] - distPassed);

          if (postStationDist < 0) {
            if (bus.expErMarg.inSex() <= 0) {
              // ************************************
              eta.sex = -2;
              bus.expErMarg.set(Time(0, 0, 0));
              bus.noEtaUpdateTicks = -1; // never update this
            } else {
              eta.sex = -1;
            }
            bus.setETA(eta);
            filterBus(bus, busFilters);
            continue;
          }
          int newETAsecs =
          ((selectedStation.distFromLineStart[i] - distPassed) ~/
              (0.2777 * avrgBusSpeed)); // m/km/h
          bus.expErMarg.set(bus.expErMarg
              .sex2Time((distPassed) ~/ (0.2777 * avrgBusSpeed) * 0.5));

          eta.hours = newETAsecs ~/ 3600;
          newETAsecs %= 3600;
          eta.mins = newETAsecs ~/ 60;
          if (eta.hours != 0 || eta.mins > 30)
            eta.sex = 0;
          else
            newETAsecs %= 60;
          eta.sex = newETAsecs;

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
