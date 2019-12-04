
import 'package:flutter/material.dart';

class DogSliderBgPainter extends CustomPainter {
  final double xPos;
  final double arcScaleY;
  final double arcRadius;
  final double bottomPadding;

  DogSliderBgPainter({
    this.xPos = 230,
    this.arcScaleY = 1,
    this.arcRadius = 20,
    this.bottomPadding = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var arcHeight = arcScaleY * arcRadius;
    var lineY = size.height - arcRadius - bottomPadding;
    var strokeWidth = 4.0;

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Color(0xff357171);

    var radius = Radius.elliptical(arcRadius, arcHeight);
    bool arcClockwise = arcHeight.sign < 0;

    //Paint accent portion of line
    var path = Path();
    path.moveTo(0, lineY);
    path.lineTo(xPos - arcRadius, lineY);
    path.arcToPoint(Offset(xPos, lineY + arcHeight), radius: radius, clockwise: arcClockwise);
    canvas.drawPath(path, paint);

    //Paint grey portion of line
    paint.color = Color(0xffd1d0da);
    path = Path();
    path.moveTo(xPos, lineY + arcHeight);
    path.arcToPoint(Offset(xPos + arcRadius, lineY), radius: radius, clockwise: arcClockwise);
    path.lineTo(size.width, lineY);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    var oldPainter = (oldDelegate as DogSliderBgPainter);
    return oldPainter.xPos != xPos || oldPainter.arcScaleY != arcScaleY;
  }
}