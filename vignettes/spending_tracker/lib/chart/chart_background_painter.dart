import 'package:flutter/material.dart';

import 'chart.dart';

class ChartBackgroundPainter extends CustomPainter {
  Chart _chart;

  ChartBackgroundPainter(Chart chart)
      : _chart = chart,
        super(repaint: chart);

  @override
  void paint(canvas, size) {
    const monthNames = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final List<String> xAxisLabels = [];
    for (int i = _chart.domainStart.round(); i <= _chart.domainEnd.round(); ++i) {
      xAxisLabels.add(monthNames[i % 12]);
    }

    final double start = _chart.domainStart;
    final double end = _chart.domainEnd;
    for (int i = start.round(); i <= end.round(); ++i) {
      final x = (i.toDouble() - start.round()) / (end - start) * size.width + 28;
      canvas.drawLine(
          Offset(x + 0.5, 0),
          Offset(x, size.height),
          Paint()
            ..color = Color(0xFF3D4666)
            ..strokeWidth = 1.0);
    }
    canvas.clipRect(Rect.fromLTRB(16, size.height, size.width - 16, size.height + 24));
    for (int i = start.round(); i <= end.round(); ++i) {
      final x = (i.toDouble() - start) / (end - start) * size.width + 28;
      final textPainter = TextPainter(
        text: TextSpan(
          text: xAxisLabels[i - start.round()],
          style: TextStyle(
            color: i == _chart.selectedDataPoint ? Color(0xFFC3C8D9) : Color(0xFFC4C8D9),
            fontFamily: 'Lato',
            fontWeight: i == _chart.selectedDataPoint ? FontWeight.bold : FontWeight.w200,
            fontSize: 12,
          ),
        ),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x - 10, size.height + 10));
    }
  }

  @override
  bool shouldRepaint(ChartBackgroundPainter oldPainter) {
    return false;
  }
}
