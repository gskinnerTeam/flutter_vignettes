import 'package:flutter/material.dart';
import 'package:spending_tracker/main.dart';

import '../app_colors.dart';
import 'circle_percentage_painter.dart';

class CirclePercentageWidget extends StatefulWidget {
  final String title;
  final double percent;
  final Color color0;
  final Color color1;

  CirclePercentageWidget(
      {this.title = "", this.percent = 0.0, this.color0 = Colors.white, this.color1 = Colors.transparent});

  @override
  State createState() => _CirclePercentageWidgetState();
}

class _CirclePercentageWidgetState extends State<CirclePercentageWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 2400));

  @override
  void initState() {
    _controller.addListener(() => setState(() {}));
    _controller.animateTo(widget.percent);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(CirclePercentageWidget oldWidget) {
    if (oldWidget.percent != widget.percent) {
      _controller.animateTo(widget.percent);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(context) {
    final titleStyle = text1.copyWith(color: AppColors.colorText0, fontSize: 14);
    final labelStyle = text1.copyWith(fontSize: 14);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(widget.title, style: titleStyle),
        Container(
          /// TODO: Fix ScalingInfo
          width: 42 * appScale,
          height: 42 * appScale,
          margin: EdgeInsets.all(12),
          child: CustomPaint(
            isComplex: false,
            painter: SpendingCategoryChartPainter(_controller.value, widget.color0, widget.color1),
            child: Center(child: Text('${(_controller.value * 100).toInt()}%', style: labelStyle)),
          ),
        ),
      ],
    );
  }
}
