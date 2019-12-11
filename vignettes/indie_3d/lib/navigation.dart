import 'package:flutter/material.dart';

class Indie3dNavigationIndicator extends StatelessWidget {

  final int pageIndex;

  Indie3dNavigationIndicator({ this.pageIndex = 0 });

  @override
  Widget build(context) {
    final activeColor = Color(0xFFFFFFFF);
    final defaultColor = Color(0xFFAAAAAA);
    final double width = 20;
    final double height = 5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          margin: EdgeInsets.all(2),
          color: pageIndex == 0 ? activeColor : defaultColor,
        ),
        Container(
          width: width,
          height: height,
          margin: EdgeInsets.all(2),
          color: pageIndex == 1 ? activeColor : defaultColor,
        ),
        Container(
          width: width,
          height: height,
          margin: EdgeInsets.all(2),
          color: pageIndex == 2 ? activeColor : defaultColor,
        ),
      ],
    );
  }
}

