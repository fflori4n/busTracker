import 'package:latlong/latlong.dart';
import 'package:mapTest/dataClasses/Station.dart';
import 'package:mapTest/dataClasses/Time.dart';
import 'package:mapTest/dataClasses/Bus.dart';
import 'package:mapTest/loadModules/busLines.dart';
import 'package:mapTest/loadModules/stations.dart';
import '../geometryFuncts.dart';
import '../main.dart';

final LatLng initMapCenter = new LatLng(0,0);
const double avrgBusSpeed = 17;

List<Bus> buslist=[];

final calcVerbose = true;
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

      if(elapsedTime < 0){
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = elapsedTime.abs()*1000 ~/ mapRefreshPeriod;
        continue;
      }

      distPassed = getEstDistPassed(bus.startTime);

      bus.busPos = getPOnPolyLineByDist(distPassed,bus.busLine.points);
      if(bus.busPos.busPoint == LatLng(-1,-1)){
        bus.displayedOnMap = false;
        bus.noPosUpdateTicks = -1;  // never update Pos
        continue;
      }

      bus.noPosUpdateTicks = 5000 ~/ mapRefreshPeriod;
    }

    if(bus.noEtaUpdateTicks > 0){
      bus.noEtaUpdateTicks--;
      if(bus.eTA.hours <= 0 && bus.eTA.mins < 15){      // do not update if time is more than 15mins
        bus.eTA.sex--;

        if(bus.eTA.sex < 0){     // just count down, do not calculate actual Eta
          bus.eTA.sex = 59;
          bus.eTA.mins--;
        }

        if(bus.eTA.mins < 0){
          bus.eTA.mins = 59;
          bus.eTA.hours--;
        }
        if(bus.eTA.hours < 0){  // technically not needed if mins arent displayed over one hour
          bus.eTA.hours = 23;
        }
      }
    }
    else if(bus.noEtaUpdateTicks == 0){
        bus.noEtaUpdateTicks = 15000 ~/ mapRefreshPeriod;     // every 15 sex
        print('calculateing ETA');
        try{
          Time eta = new Time(0,0,0);
          int i = activeStation.servedLines.indexOf(bus.busLine.name);
          if(i < 0 || i>activeStation.servedLines.length){
            print('[  Wr  ] bus not found in servedlines - skipping');
            continue;
          }
          distPassed = getEstDistPassed(bus.startTime);

          print(bus.busLine.name + 'distFrom Start:' + activeStation.distFromLineStart[i].toString());
          if((activeStation.distFromLineStart[i] - distPassed) < 0){
            eta.sex = -1;
            bus.setETA(eta);
            bus.noEtaUpdateTicks = -1;  // never update this
           // print('bus left');
            continue;
          }

          /*print(bus.nickName + '****************');
          print(distPassed);
          print(activeStation.distFromLineStart[i]);*/

          int newETAsecs = ((activeStation.distFromLineStart[i] - distPassed) ~/ (0.2777 * avrgBusSpeed));// m/km/h

          eta.hours = newETAsecs ~/ 3600;
          newETAsecs %= 3600;
          eta.mins = newETAsecs ~/ 60;
          if(eta.hours != 0 || eta.mins > 30)
            eta.sex = 0;
          else
            newETAsecs %= 60;
          eta.sex = newETAsecs;

          bus.setETA(eta);
          sortByEta(bus);

        } catch(e){
          print('[  ER  ] cant calculate ETA for: ' + bus.nickName + '--' + e.toString());
        }
    }
  }
}

double getEstDistPassed(Time startTime){ // basic estimation of pos for const speed

  DateTime now = DateTime.now();
  DateTime startDateTime = new DateTime(now.year,now.month,now.day,startTime.hours,startTime.mins, startTime.sex);
  int elapsedTime = now.difference(startDateTime).inSeconds;
  double distance = (elapsedTime)* 0.2777 * avrgBusSpeed;  //1000/3600
 // print('Est dist: ' + distance.round().toString() + ' m');
  return distance;
}

void addSelectedBuses(Station station, String line){
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
}

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