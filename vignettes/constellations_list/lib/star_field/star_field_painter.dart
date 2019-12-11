import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  final ui.Image glowImage;

  StarFieldPainter(this.stars, {this.glowImage });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    if (stars == null || canvasSize == null) return;
    canvas.translate(canvasSize.width / 2, canvasSize.height / 2);
    var paint = Paint()..color = Colors.white;
    stars.forEach((s) {
      var scale = .1 + map(s.z, 0, canvasSize.width, s.size, 0);
      var sx = map(s.x / s.z, 0, 1, 0, canvasSize.width);
      var sy = map(s.y / s.z, 0, 1, 0, canvasSize.height);
      var time = DateTime.now().millisecondsSinceEpoch/200;
      paint.color = s.color;
      var pos = Offset(sx,sy);
      canvas.drawCircle( pos, scale, paint,);
      if(glowImage != null && s.color != Colors.white){
        var glowSizeX = scale * 6 + 2 * (sin(time * .5));
        var glowSizeY = scale * 6 + 2 * (cos(time * .75));
        var src = Rect.fromPoints(Offset.zero, Offset(glowImage.width.toDouble(), glowImage.height.toDouble()));
        var rect = Rect.fromCenter(center: pos, width: glowSizeX, height: glowSizeY);
        canvas.drawImageRect(glowImage, src, rect, paint);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double map(double value, double from1, double to1, double from2, double to2) {
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
  }
}

class Star {
  double x;
  double y;
  double z;
  double size = 1;
  double rotation = 0;
  Color color = Colors.white;

  Star({this.x = 0, this.y = 0, this.z = 0});
}
