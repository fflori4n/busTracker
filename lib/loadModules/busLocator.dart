import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/stations.dart';
import 'package:mapTest/location/locationTest.dart';
import '../filters.dart';
import '../geometryFuncts.dart';
import '../main.dart';

final LatLng initMapCenter = new LatLng(0,0);
const double avrgBusSpeed = 17;

List<Bus> buslist=[];

final calcVerbose = false;
bool isSorted = false;  // TODO: convert to static? instead of global

void calcBusPos(){
  DateTime refTime = DateTime.now();

  for(var bus in buslist){
    double distPassed;

    if(bus.noPosUpdateTicks > 0){
      bus.noPosUpdateTicks--;
    }
    else if(bus.noPosUpdateTicks == 0){
      //bus.dbgPrint();
      DateTime startDateTime = new DateTime(refTime.year,refTime.month,refTime.day,bus.startTime.hours,bus.startTime.mins, bus.startTime.sex);
      int elapsedTime = refTime.difference(startDateTime).inSeconds;

      if(elapsedTime < 0){  // not departed - not displayed
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = elapsedTime.abs()*1000 ~/ mapRefreshPeriod;
        continue;
      }
      distPassed = getEstDistPassed(elapsedTime);

      bus.busPos = getPOnPolyLineByDist(distPassed,bus.busLine.points);
      if(bus.busPos.busPoint == LatLng(-1,-1)){
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = -1;  // never update Pos
        continue;
      }
      else{
        bus.displayedOnMap = true;
      }
      bus.noPosUpdateTicks = 1000 ~/ mapRefreshPeriod;  // bus pos update time
    }
    if(activeStation.name == paperStationName){   // do not calculate eta for easter egg station
      bus.setETA(Time(-1, -1, -1));
      continue;
    }
    if(bus.eTA.sex == -1){
      bus.expErMarg.decrease(Time(0,0,1));         // decrease timer when bus is arriving
    }
    if(bus.noEtaUpdateTicks > 0){
      bus.noEtaUpdateTicks--;
      if(bus.eTA.hours <= 0 && bus.eTA.mins < 15 && bus.eTA.inSex() > 0){// do not update if time is more than 15mins
        bus.eTA.decrease(Time(0,0,1));
      }
    }
    else if(bus.noEtaUpdateTicks == 0){
        bus.noEtaUpdateTicks = 15000 ~/ mapRefreshPeriod;     // every 15 sex
        try{
          Time eta = new Time(0,0,0);
          int i = activeStation.servedLines.indexOf(bus.busLine.name);
          if(i < 0 || i>activeStation.servedLines.length){
            print('[  Wr  ] bus not found in servedlines - skipping');
            continue;
          }
          distPassed = getEstDistPassed(bus.startTime);

          //print(bus.busLine.name + ' distFrom Start:' + activeStation.distFromLineStart[i].toString());
          double postStationDist = (activeStation.distFromLineStart[i] - distPassed);

          if(postStationDist < 0){
            if(bus.expErMarg.inSex() <= 0){ // ************************************
              eta.sex = -2;
              bus.expErMarg.set(Time(0,0,0));
              bus.noEtaUpdateTicks = -1;  // never update this
            }
            else{
              eta.sex = -1;
              //bus.expErMarg.decrease(Time(0,0,15));
            }
            bus.setETA(eta);
            filterBus(bus, busFilters);
           // print('bus left');
            continue;
          }
          int newETAsecs = ((activeStation.distFromLineStart[i] - distPassed) ~/ (0.2777 * avrgBusSpeed));// m/km/h
          bus.expErMarg.set(bus.expErMarg.sex2Time((distPassed) ~/ (0.2777 * avrgBusSpeed)*0.5));

          eta.hours = newETAsecs ~/ 3600;
          newETAsecs %= 3600;
          eta.mins = newETAsecs ~/ 60;
          if(eta.hours != 0 || eta.mins > 30)
            eta.sex = 0;
          else
            newETAsecs %= 60;
          eta.sex = newETAsecs;

          bus.setETA(eta);

         // if(!isSorted && buslist.indexOf(bus) == buslist.length){
            sortAllByEta();
         /*   isSorted = true;
          }
          else{
            sortByEta(bus);
          }*/

        } catch(e){
          print('[  ER  ] cant calculate ETA for: ' + bus.nickName + '--' + e.toString());
        }
    }
  }
}

double getEstDistPassed(var startTime){ // basic estimation of pos for const speed

  int elapsedTime;

  if(startTime is Time){                                                        // is = instanceof in dart ;) cool
    DateTime now = DateTime.now();
    DateTime startDateTime = new DateTime(now.year,now.month,now.day,startTime.hours,startTime.mins, startTime.sex);
    elapsedTime = now.difference(startDateTime).inSeconds;
  }
  else if(startTime is int){
    elapsedTime = startTime;
  }
  double distance = (elapsedTime)* 0.2777 * avrgBusSpeed;  //1000/3600
 // print('Est dist: ' + distance.round().toString() + ' m');
  return distance;
}

/*void addSelectedBuses(Station station, String line){
  Bus newBus = new Bus.empty();

  for(var bbusline in nsBusLines){
    if(bbusline.name == line){
      newBus.lineColor = bbusline.color;
      newBus.color = bbusline.color.withAlpha(200);
      newBus.busLine = bbusline;
      newBus.busPos = new Position(bbusline.points[0], -1);
      DateTime now = DateTime.now();
      //print(now.hour.toString() + ':' + now.minute.toString());
      newBus.startTime = Time(now.hour, now.minute, 0);
      buslist.add(newBus);
    }
  }
}*/

void sortByEta(Bus bus){
  // TODO: convert everithing to index instead of ref.
  int busIndex = buslist.indexOf(bus);
  if(( busIndex - 1) > 0){
    int prevBusSex = buslist[busIndex - 1].eTA.inSex();
    if(prevBusSex > bus.eTA.inSex()){
      Bus temp = buslist[busIndex];
      buslist[busIndex] = buslist[busIndex - 1];
      buslist[busIndex - 1] = temp;
    }
  }
}
void sortAllByEta(){
  for(int i=0; i< (buslist.length - 1); i++){
    bool flg = true;
    for(int j=0; j < (buslist.length - 1); j++){
      if(buslist[j].eTA.inSex() > buslist[j+1].eTA.inSex()){
        Bus temp = buslist[j];
        buslist[j] = buslist[j + 1];
        buslist[j + 1] = temp;
        flg = false;
      }
    }
    if(flg) {
      return;
    }
  }

}