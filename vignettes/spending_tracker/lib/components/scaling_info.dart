import 'package:flutter/material.dart';

class ScalingInfo {
  static double scaleX;
  static double scaleY;

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
