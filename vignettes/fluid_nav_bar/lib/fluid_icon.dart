import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared/ui/path_util.dart';

// Users of this class shouldn't have to explicitly import fluid_icon_data
import './fluid_icon_data.dart';
export './fluid_icon_data.dart';

class FluidFillIcon extends StatelessWidget {
  static const double iconDataScale = 0.9;

  final FluidFillIconData _iconData;

  /// A normalzied value between 0 and 1
  final double _fillAmount;

  final double _scaleY;

  FluidFillIcon(FluidFillIconData iconData, double fillAmount, double scaleY)
      : _iconData = iconData,
        _fillAmount = fillAmount,
        _scaleY = scaleY;

  @override
  Widget build(context) {
    return CustomPaint(
      painter: _FluidFillIconPainter(_iconData.paths, _fillAmount, _scaleY),
    );
  }
}

class _FluidFillIconPainter extends CustomPainter {
  List<ui.Path> _paths;
  double _fillAmount;
  double _scaleY;

  _FluidFillIconPainter(List<ui.Path> paths, double fillAmount, double scaleY)
      : _paths = paths,
        _fillAmount = fillAmount,
        _scaleY = scaleY;

  @override
  void paint(canvas, size) {
    final paintBackground = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.grey;

    final paintForeground = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.black;

    // Scale around (0, height / 2)
    canvas.translate(0.0, size.height / 2);
    canvas.scale(1.0, _scaleY);
    // Center around (width / 2, height / 2) and apply the icon data scale
    canvas.translate(size.width / 2, 0.0);
    canvas.scale(FluidFillIcon.iconDataScale, FluidFillIcon.iconDataScale);

    // Draw the background greyed out path
    for (final path in _paths) {
      canvas.drawPath(path, paintBackground);
    }

    // Draw the black foreground path to simulate a filling effect
    if (_fillAmount > 0.0) {
      for (final path in _paths) {
        canvas.drawPath(extractPartialPath(path, 0.0, _fillAmount), paintForeground);
      }
    }
  }

  @override
  bool shouldRepaint(_FluidFillIconPainter oldWidget) {
    return _fillAmount != oldWidget._fillAmount;
  }
}
