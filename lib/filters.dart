import 'package:mapTest/loadModules/busLocator.dart';
import 'dataClasses/Show.dart';

void applyFilters(Show filters){
  for(var bus in buslist){
      if(bus.eTA.equals(0, 0, -2)){
        if(filters.left){
          bus.displayedOnSchedule = true;
         // bus.displayedOnMap = true;  // TODO:problematic, fix later
        }
        else{
          bus.displayedOnSchedule = false;
         // bus.displayedOnMap = false;
        }
        // TODO: maybe modify refresh time to save processing
      }
  }
}