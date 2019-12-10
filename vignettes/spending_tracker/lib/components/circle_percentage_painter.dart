import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'scaling_info.dart';

class SpendingCategoryChartPainter extends CustomPainter {
  final double percent;
  final Color color0;
  final Color color1;

  SpendingCategoryChartPainter(this.percent, this.color0, this.color1);

  @override
  void paint(canvas, size) {
    final paint = Paint();
    paint.color = Color(0xFF5B668C);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 5 * ScalingInfo.scaleY;
    paint.strokeCap = StrokeCap.square;

    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 0, math.pi * 2, false, paint);
    paint.shader = ui.Gradient.linear(Offset.zero, Offset(0, size.height), [color0, color1]);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), -math.pi / 2, -2 * math.pi * percent, false, paint);
  }

  @override
  bool shouldRepaint(SpendingCategoryChartPainter oldCategory) {
    return percent != oldCategory.percent || color0 != oldCategory.color0 || color1 != oldCategory.color1;
  }
}
