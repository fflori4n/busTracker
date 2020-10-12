import 'dart:js';
import 'package:flutter/foundation.dart';

import 'location.dart';

success(pos) {
  try {
    print(pos.coords.latitude);
    print(pos.coords.longitude);
  } catch (ex) {
    print("Exception thrown : " + ex.toString());
  }
}
getCurrentLocation() {
    getCurrentPosition(allowInterop((pos) => success(pos)));
}