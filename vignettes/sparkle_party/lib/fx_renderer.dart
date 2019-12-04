import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'utils/sprite_sheet.dart';
import 'particlefx/particle_fx.dart';
import 'particlefx/particle_fx_painter.dart';
import 'touchpoint_notification.dart';
import 'fx_entry.dart';

class FxRenderer extends StatefulWidget {
  final SpriteSheet spriteSheet;
  final FXEntry fx;
  final Size size;

  FxRenderer({this.fx, this.size, key, this.spriteSheet}) : super(key:key);

  @override
  _FxRendererState createState() => _FxRendererState();
}

class _FxRendererState extends State<FxRenderer> with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  Ticker _ticker;
  ParticleFX _fxWidget;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
    _fxWidget = widget.fx.create(spriteSheet: widget.spriteSheet, size: widget.size);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FxRenderer oldWidget) {
    if (oldWidget.size != widget.size || oldWidget.fx != widget.fx) {
      _fxWidget = widget.fx.create(spriteSheet: widget.spriteSheet, size: widget.size);
    }
    super.didUpdateWidget(oldWidget);
  }

  void setTouchPoint([Offset pt]) {
    TouchPointChangeNotification()..dispatch(context);
    if (_fxWidget != null) { _fxWidget.touchPoint = pt; }
  }

  void _tick(Duration duration) {
    if (_fxWidget != null) { _fxWidget.tick(duration); }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (TapDownDetails details) => setTouchPoint(details.localPosition),
      onTapUp: (_) => setTouchPoint(),
      onPanStart: (DragStartDetails details) => setTouchPoint(details.localPosition),
      onPanEnd: (_) => setTouchPoint(),
      onPanUpdate: (DragUpdateDetails details) => setTouchPoint(details.localPosition),
      child: CustomPaint(
        painter: ParticleFXPainter(fx: _fxWidget),
        child: Container(), // force it to fill the available area, and capture touch inputs.
      ),
    );
  }
}

