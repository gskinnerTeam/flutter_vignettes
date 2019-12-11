import 'package:flutter/material.dart';

class ScalingInfo {

  static double _scaleX;
  static double _scaleY;


  static void init(MediaQueryData data) {
    final appSize = data.size;
    _scaleX = (appSize.width / 320).clamp(1, 1.5);
  }

  static double get scaleX => _scaleX;
  static double get scaleY => _scaleY;

}
