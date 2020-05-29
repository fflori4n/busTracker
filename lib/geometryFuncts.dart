import 'dart:math';

import 'package:latlong/latlong.dart';

import 'loadModules/stations.dart';

LatLng getPOnPolyLineByDist (double distance, List<LatLng> polyLine){
  List<LatLng> pointList = polyLine;
  double distSum = 0;  //m

  int i =0;
  for(;i<pointList.length;i++){
    if(i+2 >= pointList.length){   // path is not long enough
      print('longer than path!');
      return LatLng(0,0);}
    distSum += normLoc(pointList[i], pointList[i+1]);
    if(distSum > distance){
      break;
    }
  }
  distance = distSum - distance;
  double sectionDist = normLoc(pointList[i], pointList[i+1]);
  double sectCompleted = 1 - (distance / sectionDist);

  //print("dbg: next point " + distance.round().toString() + ", " + (sectCompleted*100).round().toString() + '%');

  LatLng newPos = LatLng(pointList[i].latitude + sectCompleted*(pointList[i+1].latitude-pointList[i].latitude), pointList[i].longitude + sectCompleted*(pointList[i+1].longitude-pointList[i].longitude));
  return newPos;
}

double distToPprojection(LatLng point, List<LatLng> polyLine){   // not good needs fixing
  List<LatLng> pointList = polyLine;
  LatLng minPoint;
  double minDist = 10000;
  int mindex = 0;

  for(int i = 0; i<(pointList.length - 1); i++){
    LatLng projection = pProjectionToLine(pointList[i], pointList[i+1], point);
    double dist = normLoc(projection, point);
    if(dist < minDist){
      minDist = dist;
      minPoint = projection;
    }
  }

  pointList.insert((mindex + 1), minPoint);
  double distSum = 0;

  for(int i = 0; i<(mindex + 2); i++){
    distSum+=normLoc(pointList[i], pointList[i+1]);
  }

  pointList.removeAt(mindex + 1);
  //print('closest point:' + minPoint.toString());
  //print('distance from path start:' + distSum.roundToDouble().toString());
  return distSum.roundToDouble();
}

LatLng pProjectionOnPolyLine(LatLng point, List<LatLng> pointList){
  LatLng minPoint;
  double minDist = 10000;
  for(int i = 0; i<(pointList.length - 1); i++){
    LatLng projection = pProjectionToLine(pointList[i], pointList[i+1], point);
    double dist = normLoc(projection, point);
    if(dist < minDist){
      minDist = dist;
      minPoint = projection;
    }
  }
  //print('closest point:' + minPoint.toString());
  return minPoint;
}

LatLng pProjectionToLine( LatLng lnPoint0, LatLng lnPoint1, LatLng point){
  // https://stackoverflow.com/questions/15232356/projection-of-a-point-on-line-defined-by-2-points Corey Ogburn
  LatLng projection = new LatLng(0,0);
  if(lnPoint0.latitude == lnPoint1.latitude && lnPoint0.longitude == lnPoint1.longitude){ lnPoint0.latitude -= 0.00001;}

  double U = ((point.latitude - lnPoint0.latitude) * (lnPoint1.latitude-lnPoint0.latitude)) + ((point.longitude - lnPoint0.longitude)*(lnPoint1.longitude - lnPoint0.longitude));
  double Udenom = pow(lnPoint1.latitude - lnPoint0.latitude, 2) + pow(lnPoint1.longitude - lnPoint0.longitude, 2);
  U/=Udenom;

  projection.latitude = lnPoint0.latitude + (U *(lnPoint1.latitude - lnPoint0.latitude));
  projection.longitude = lnPoint0.longitude + (U * (lnPoint1.longitude - lnPoint0.longitude));

  double minx, maxx, miny, maxy;

  minx = min(lnPoint0.latitude,lnPoint1.latitude);
  maxx = max(lnPoint0.latitude,lnPoint1.latitude);
  miny = min(lnPoint0.longitude,lnPoint1.longitude);
  maxy = max(lnPoint0.longitude,lnPoint1.longitude);


  if(!(projection.latitude >= minx && projection.latitude <= maxx && projection.longitude >= miny && projection.longitude <= maxy)){
    if(normLoc(projection, lnPoint0) < normLoc(projection, lnPoint1)){
      return lnPoint0;
    }
    return lnPoint1;
  }
  return projection;
}

double normLoc(LatLng point0, LatLng point1){ // quick and dirty aprox. r^2=r^2+d^2
  const double toRad = 3.1415/180;
  const double R = 6371e3;

  double F1 = point0.latitude * toRad;  //lat
  double F2 = point1.latitude * toRad;
  double L1 = point0.longitude * toRad;
  double L2 = point1.longitude * toRad;

  double x = (L2-L1) * cos((F1+F2)/2);
  double y = (F2-F1);

  return (sqrt(x*x + y*y)*R);
}

double map(double val, double inLow, double inHigh, double outLow, double outHigh,[int saturation]){ // Arduino style map function

  // saturation - null - both
  //              0 - none
  //              1 - only low
  //              2 - only high

  double out = (val - inLow) * (outHigh - outLow) / (inHigh - inLow) + outLow;

  if(saturation != 0){
    if(saturation != 1) {
      out = min(out, outHigh);}
    if(saturation != 2){
      out = max(out, outLow);}
  }
  return out;
}
