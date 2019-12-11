import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'main.dart';

class AppColors {
  static Color orangeAccent = Color(0xfff1a35d);
  static Color orangeAccentLight = Color(0xffff7f33);
  static Color redAccent = Color(0xfff1a35d);
  static Color grey = Color(0xff4d4d4d);
}

class Styles {
  static TextStyle text(double size, Color color, bool bold, {double height}) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      height: height,
      fontFamily: "Poppins",
      package: App.pkg
    );
  }
}
