import 'dart:math';

import 'package:flutter/material.dart';

class PlaceholderCardShort extends StatelessWidget {
  final double width;
  final double height;
  final double cornerRadius;
  final Color? color;
  final Color? backgroundColor;

  const PlaceholderCardShort({Key? key, this.cornerRadius = 4, this.color, this.backgroundColor, this.width = 400, this.height = 90 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var r = Random();
    var fgColor = color ?? Color(0xfff2f2f2);
    double lineHeight = 16;
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        color: backgroundColor ?? Colors.white,
      ),
      padding: EdgeInsets.all(26),
      child: Stack(
        children: <Widget>[
          //Circle image
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: fgColor),
              height: 32,
              width: 32,
            ),
          ),

          //Content Line
          Container(margin: EdgeInsets.only(right: 60.0 + r.nextInt(60)), color: fgColor, height: lineHeight ),

          //Content Line
          Container(margin: EdgeInsets.only(right: 80.0 + r.nextInt(120), top: lineHeight + 6), color: fgColor, height: lineHeight ),

        ],
      ),
    );
  }
}
