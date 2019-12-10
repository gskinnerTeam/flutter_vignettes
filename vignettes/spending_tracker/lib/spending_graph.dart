import 'package:flutter/material.dart';

import 'interact_notification.dart';
import 'components/scaling_info.dart';
import 'chart/chart.dart';
import 'chart/chart_painter.dart';
import 'chart/chart_background_painter.dart';
import 'globals.dart';

class SpendingGraph extends StatefulWidget {
  final Chart chart;

  SpendingGraph({this.chart});

  @override
  State createState() => _SpendingGraphState();
}

class _SpendingGraphState extends State<SpendingGraph> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _startRange;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 600), value: 1.0);
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final textStyle = TextStyle(
      color: Color(0xFFC4C8D9),
      fontSize: 12,
      fontFamily: 'Lato',
      fontWeight: FontWeight.w200,
    );
    final labelStyle = TextStyle(
      color: Color(0xFFDCE2F5),
      fontFamily: 'Lato',
      fontSize: 10,
    );
    final List<String> yAxisLabels = [
      '\$8k',
      '\$6k',
      '\$4k',
      '\$2k',
      '0',
    ];
    String label0Text, label1Text;
    double label0Y, label1Y;
    if (widget.chart.selectedDataPoint != -1) {
      label0Text =
          numberToPriceString((widget.chart.dataSets[0].values[widget.chart.selectedDataPoint] * 1000).round());
      label1Text =
          numberToPriceString((widget.chart.dataSets[1].values[widget.chart.selectedDataPoint] * 1000).round());
      label0Y = 150 * ScalingInfo.scaleY * (1.0 - widget.chart.selectedY(0)) + 10;
      label1Y = 150 * ScalingInfo.scaleY * (1.0 - widget.chart.selectedY(1)) + 10;
      // Resolve label intersection
      final d = label1Y - label0Y;
      if (d.abs() < 12) {
        label1Y += 24;
      }
    }

    final appSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTapUp: (details) => _handleTap(appSize, details),
      onHorizontalDragStart: (_) => _handleStartInteract(context),
      onHorizontalDragUpdate: _handleDrag,
      onHorizontalDragEnd: (_) => _handleEndInteract(context),
      onScaleStart: (details) {
        _handleStartInteract(context);
        _handleStartZoom(details);
      },
      onScaleUpdate: _handleZoom,
      onScaleEnd: (_) => _handleEndInteract(context),
      child: Container(
        //width: 320 * ScalingInfo.scaleX,
        height: 160 * ScalingInfo.scaleY,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              width: appSize.width,
              height: 150 * ScalingInfo.scaleY,
              child: CustomPaint(
                  painter: ChartBackgroundPainter(widget.chart),
                  foregroundPainter: ChartPainter(
                    widget.chart,
                    _controller,
                    [
                      Color(0x4C4AC3E5),
                      Color(0x005290C7),
                      Color(0x4CDEACD0),
                      Color(0x00DEACD0),
                    ],
                    [
                      Color(0xFF4A78ED),
                      Color(0xFF5DB391),
                      Color(0xFFA74CBA),
                      Color(0xFFF287A6),
                    ],
                  )),
            ),
            Positioned(
              left: 4,
              height: 150 * ScalingInfo.scaleY,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: yAxisLabels.map((label) => Text(label, style: textStyle)).toList(),
              ),
            ),
            Positioned(
              left: appSize.width - 24,
              height: 150 * ScalingInfo.scaleY,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: yAxisLabels.map((label) => Text(label, style: textStyle)).toList(),
              ),
            ),
            if (widget.chart.selectedDataPoint != -1) ...{
              _buildLabel(appSize, label0Text, labelStyle, label0Y),
              _buildLabel(appSize, label1Text, labelStyle, label1Y),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(Size appSize, String text, TextStyle style, double y) {
    return Positioned(
      left: appSize.width * widget.chart.selectedX() + 8,
      top: y,
      width: 40,
      child: Container(
        color: Color(0x99252B40).withOpacity(_controller.value < 0.6 ? _controller.value : 0.6),
        padding: EdgeInsets.all(4),
        child: Text(text,
            textAlign: TextAlign.center,
            style: style.copyWith(color: Color(0xFFDCE2F5).withOpacity(_controller.value))),
      ),
    );
  }

  void _handleTap(Size appSize, TapUpDetails details) {
    final x = (details.localPosition.dx - 28) / appSize.width;
    final offset = lerp(widget.chart.domainStart, widget.chart.domainEnd, x);
    if (offset.round() != widget.chart.selectedDataPoint) {
      widget.chart.selectedDataPoint = offset.round();
      _controller.forward(from: 0.0);
    }
  }

  void _handleStartInteract(BuildContext context) {
    InteractNotification(false)..dispatch(context);
  }

  void _handleEndInteract(BuildContext context) {
    InteractNotification(true)..dispatch(context);
  }

  void _handleStartZoom(ScaleStartDetails details) {
    _startRange = widget.chart.domainEnd - widget.chart.domainStart;
  }

  void _handleZoom(ScaleUpdateDetails details) {
    double d = 1.0 / details.scale;
    if (d == 0) return;
    final targetRange = _startRange * d;
    final range = widget.chart.domainEnd - widget.chart.domainStart;
    final scale = targetRange - range;

    if (range + scale < 13.0) {
      if (widget.chart.domainEnd != widget.chart.maxDomain) {
        widget.chart.domainEnd += scale;
      } else {
        widget.chart.domainStart -= scale;
      }
    }

    _controller.reverse();
  }

  void _handleDrag(DragUpdateDetails details) {
    final d = -details.primaryDelta / 200 * (widget.chart.domainEnd - widget.chart.domainStart);
    if (widget.chart.domainStart + d < 0 || widget.chart.domainEnd + d >= widget.chart.maxDomain) return;
    if (d < 0) {
      widget.chart.domainStart += d;
      widget.chart.domainEnd += d;
    } else {
      widget.chart.domainEnd += d;
      widget.chart.domainStart += d;
    }
    _controller.reverse();
  }
}
