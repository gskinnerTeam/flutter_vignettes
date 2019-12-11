import 'package:flutter/material.dart';

class SpecificRectClipper extends CustomClipper<Rect> {
  final Rect clipRect;

  SpecificRectClipper(this.clipRect);

  @override
  Rect getClip(Size size) {
    return clipRect;
  }

  @override
  bool shouldReclip(SpecificRectClipper oldClipper) {
    return clipRect != oldClipper.clipRect;
  }
}
