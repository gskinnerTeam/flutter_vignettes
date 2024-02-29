import 'package:flutter/material.dart';
import 'gooey_edge.dart';

// This isn't used in the example, but it can be used to quickly paint a GooeyEdge to a canvas.
class GooeyEdgePainter extends CustomPainter {
  GooeyEdge edge;

  GooeyEdgePainter({required this.edge});

  @override
  void paint(Canvas canvas, Size size) {
    Paint fill = new Paint()..color = Colors.blue;
    canvas.drawPath(edge.buildPath(size), fill);
  }

  @override
  bool shouldRepaint(GooeyEdgePainter oldPainter) {
    return true;
  }
}