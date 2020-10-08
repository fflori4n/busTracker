import 'package:mapTest/loadModules/busLocator.dart';
import 'dataClasses/Bus.dart';
import 'dataClasses/Show.dart';

void applyFilters(Show filters){
  for(var bus in buslist){
    filterBus(bus,filters);
  }
}

void filterBus(Bus bus,Show filters){
  if(filters.hideLine.contains(bus.busLine.name)){
    bus.displayedOnSchedule = false;
    bus.noEtaUpdateTicks = -1; //never update
  }
  else{
    bus.noPosUpdateTicks = 0;
    bus.noEtaUpdateTicks = 0;
    bus.displayedOnSchedule = true;
    bus.displayedOnMap = true; // TODO:problematic, fix later
  }
  if(bus.eTA.equals(0, 0, -2)) {
    if (filters.left) {
      bus.noPosUpdateTicks = 0;
      bus.noEtaUpdateTicks = 0;
      bus.displayedOnSchedule = true;
      bus.displayedOnMap = true; // TODO:problematic, fix later
    }
    else {
      bus.displayedOnSchedule = false;
      bus.noEtaUpdateTicks = -1; //never update
      // bus.displayedOnMap = false;
    }
  }
  if(bus.eTA.inSex() > 15 * 60){
    if (filters.eTAgt15mins) {
      bus.noPosUpdateTicks = 0;
      bus.noEtaUpdateTicks = 0;
      bus.displayedOnSchedule = true;
      bus.displayedOnMap = true; // TODO:problematic, fix later
    }
    else {
      bus.displayedOnSchedule = false;
      bus.noEtaUpdateTicks = -1; //never update
    }
  }
}