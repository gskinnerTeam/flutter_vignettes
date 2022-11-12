import 'package:flutter/material.dart';

class ScalingInfo {
  static double scaleX = 1; // ? init initializes it so maybe there is a better pattern. Using 1 to silence errors
  static double scaleY = 1;

  static bool get initialized => scaleX != null;

  static void init(BuildContext context) {
    final queryData = MediaQuery.of(context);
    final appSize = queryData.size;

    scaleX = appSize.width / 320;
    scaleY = appSize.height / 480;

    if (scaleX > 2.0) {
      scaleX = 2.0;
    }
  }
}
