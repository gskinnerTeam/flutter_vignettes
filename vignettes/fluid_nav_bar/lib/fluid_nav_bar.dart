import 'package:flutter/material.dart';

import './fluid_icon.dart';
import './fluid_button.dart';
import './curves.dart';

typedef void FluidNavBarChangeCallback(int selectedIndex);

class FluidNavBar extends StatefulWidget {
  static const double nominalHeight = 56.0;

  final FluidNavBarChangeCallback? onChange;

  FluidNavBar({required this.onChange});

  @override
  State createState() => _FluidNavBarState();
}

class _FluidNavBarState extends State<FluidNavBar> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _xController;
  late AnimationController _yController;

  @override
  void initState() {
    _xController = AnimationController(vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _xController.value = _indexToPosition(_selectedIndex) / MediaQuery.of(context).size.width;
    _yController.value = 1.0;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    // The fluid nav bar consists of two components, the liquid background pane and the buttons
    // Build a stack with the buttons overlayed on top of the background pane
    final appSize = MediaQuery.of(context).size;
    final height = FluidNavBar.nominalHeight;
    return Container(
      width: appSize.width,
      height: FluidNavBar.nominalHeight,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            width: appSize.width,
            height: height,
            child: _buildBackground(),
          ),
          Positioned(
            left: (appSize.width - _getButtonContainerWidth()) / 2,
            top: 0,
            width: _getButtonContainerWidth(),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildButtons(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    // This widget acts purely as a container that controlls how the `_BackgroundCurvePainter` draws
    final inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: _BackgroundCurvePainter(
        _xController.value * MediaQuery.of(context).size.width,
        Tween<double>(
          begin: Curves.easeInExpo.transform(_yController.value),
          end: inCurve.transform(_yController.value),
        ).transform(_yController.velocity.sign * 0.5 + 0.5),
        Colors.white,
      ),
    );
  }

  List<FluidNavBarButton> _buildButtons() {
    List<FluidFillIconData> icons = [
      FluidFillIcons.home,
      FluidFillIcons.user,
      FluidFillIcons.window,
    ];
    var buttons = <FluidNavBarButton>[];
    for (var i = 0; i < 3; ++i) {
      buttons.add(FluidNavBarButton(icons[i], _selectedIndex == i, () => _handlePressed(i)));
    }
    return buttons;
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  double _indexToPosition(int index) {
    // Calculate button positions based off of their
    // index (works with `MainAxisAlignment.spaceAround`)
    const buttonCount = 3.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX + index.toDouble() * buttonsWidth / buttonCount + buttonsWidth / (buttonCount * 2.0);
  }

  void _handlePressed(int index) {
    if (_selectedIndex == index || _xController.isAnimating) return;

    setState(() {
      _selectedIndex = index;
    });

    _yController.value = 1.0;
    _xController.animateTo(_indexToPosition(index) / MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 620));
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        _yController.animateTo(1.0, duration: Duration(milliseconds: 1200));
      },
    );
    _yController.animateTo(0.0, duration: Duration(milliseconds: 300));

    widget.onChange?.call(index);
  }
}

class _BackgroundCurvePainter extends CustomPainter {
  // Top: 0.6 point, 0.35 horizontal
  // Bottom:

  static const _radiusTop = 54.0;
  static const _radiusBottom = 44.0;
  static const _horizontalControlTop = 0.6;
  static const _horizontalControlBottom = 0.5;
  static const _pointControlTop = 0.35;
  static const _pointControlBottom = 0.85;
  static const _topY = -10.0;
  static const _bottomY = 54.0;
  static const _topDistance = 0.0;
  static const _bottomDistance = 6.0;

  final double _x;
  final double _normalizedY;
  final Color _color;

  _BackgroundCurvePainter(double x, double normalizedY, Color color)
      : _x = x,
        _normalizedY = normalizedY,
        _color = color;

  @override
  void paint(canvas, size) {
    // Paint two cubic bezier curves using various linear interpolations based off of the `_normalizedY` value
    final norm = LinearPointCurve(0.5, 2.0).transform(_normalizedY) / 2;

    final radius = Tween<double>(begin: _radiusTop, end: _radiusBottom).transform(norm);
    // Point colinear to the top edge of the background pane
    final anchorControlOffset =
        Tween<double>(begin: radius * _horizontalControlTop, end: radius * _horizontalControlBottom)
            .transform(LinearPointCurve(0.5, 0.75).transform(norm));
    // Point that slides up and down depending on distance for the target x position
    final dipControlOffset = Tween<double>(begin: radius * _pointControlTop, end: radius * _pointControlBottom)
        .transform(LinearPointCurve(0.5, 0.8).transform(norm));
    final y = Tween<double>(begin: _topY, end: _bottomY).transform(LinearPointCurve(0.2, 0.7).transform(norm));
    final dist =
        Tween<double>(begin: _topDistance, end: _bottomDistance).transform(LinearPointCurve(0.5, 0.0).transform(norm));
    final x0 = _x - dist / 2;
    final x1 = _x + dist / 2;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(x0 - radius, 0)
      ..cubicTo(x0 - radius + anchorControlOffset, 0, x0 - dipControlOffset, y, x0, y)
      ..lineTo(x1, y)
      ..cubicTo(x1 + dipControlOffset, y, x1 + radius - anchorControlOffset, 0, x1 + radius, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    final paint = Paint()..color = _color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BackgroundCurvePainter oldPainter) {
    return _x != oldPainter._x || _normalizedY != oldPainter._normalizedY || _color != oldPainter._color;
  }
}
