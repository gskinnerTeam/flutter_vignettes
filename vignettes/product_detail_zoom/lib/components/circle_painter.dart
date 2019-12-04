import 'package:flutter/widgets.dart';

class CirclePainter extends CustomPainter {
  Paint _paint;
  final Color color;
  final double radius;

  CirclePainter({this.color, this.radius}) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
