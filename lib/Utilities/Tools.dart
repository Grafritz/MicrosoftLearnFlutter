
import 'package:flutter/foundation.dart';

class Tools {

  static String tag = "GRAFRITZ: ";

  static void logCat(Object object) {
    if (!kReleaseMode) {
      debugPrint('$tag: $object');
    }
  }

  static void println(Object object) {
    if (!kReleaseMode) {
      debugPrint('$tag: $object');
    }
  }

}