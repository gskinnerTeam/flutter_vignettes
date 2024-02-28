import 'package:flutter/material.dart';
import 'particle_fx.dart';

// Renders a ParticleFX.
class ParticleFXPainter extends CustomPainter {
  ParticleFX fx;

  // ParticleFX is a ChangeNotifier, so we can use it as the repaint notifier.
  ParticleFXPainter({required this.fx}) : super(repaint: fx);

  @override
  void paint(Canvas canvas, Size size) {
    if (fx.vertices == null || fx.spriteSheet.image == null) {
      return;
    }
    Paint paint = Paint()
      ..shader = ImageShader(fx.spriteSheet.image!, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage);
    canvas.drawVertices(fx.vertices!, BlendMode.dstIn, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
