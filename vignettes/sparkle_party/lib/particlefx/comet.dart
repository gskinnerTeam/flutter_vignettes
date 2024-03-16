import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/rnd.dart';
import '../utils/sprite_sheet.dart';
import '../utils/vertex_helpers.dart';
import 'particle_fx.dart';

// Animated particle effects. Note that this just manages the data, ParticleFieldPainter renders the effect.
class Comet extends ParticleFX {
  double _hue = 0.0;
  Offset? _prevPoint;
  double _power = 0.0;
  late Offset _point;

  Comet({required SpriteSheet spriteSheet, required Size size}) : super(spriteSheet: spriteSheet, size: size) {
    center = Offset(width * 0.5, 30);
    _point = Offset(width * 0.5, height + 50);
  }

  void _activateParticle(int i, Offset pt, double m) {
    Particle o = particles[i];

    o.x = pt.dx;
    o.y = pt.dy;
    double a = Rnd.getRad();
    double v = Rnd.getDouble(3.0, 10.0) * m;
    o.vx = sin(a) * v;
    o.vy = cos(a) * v;

    o.animate = true;
    o.frame = Rnd.getInt(0, spriteSheet.length);
    o.life = Rnd.getDouble(50, 100) * (0.5 + 0.5 * m);

    double h = (_hue * 0.5 + Rnd.ratio * 40.0 + a / pi * 30) % 360;
    int color = HSLColor.fromAHSL(1.0, h, 1.0, Rnd.getBool(0.1) ? 1.0 : 0.4).toColor().value;
    injectColor(i, colors, color);

    if (o.animate) {
      o.frame = Rnd.getInt(0, spriteSheet.length);
    }
  }

  @override
  void tick(Duration duration) {
    if (spriteSheet.image == null) {
      return;
    }
    if (particles.isEmpty) {
      fillInitialData();
    }

    _point += ((touchPoint ?? center) - _point) * (touchPoint == null ? 0.05 : 0.2);

    _hue += 10;

    int frameCount = spriteSheet.length;
    double m = _updatePower();
    int addCount = (180 * m).toInt();

    for (int i = 0; i < count; i++) {
      Particle o = particles[i];
      if (o.life == 0 && --addCount > 0) {
        _activateParticle(i, _point, m);
      } else if (o.life == 0) {
        continue;
      }

      o.vy += 0.25;
      o.vy *= 0.99;
      o.x += o.vx;
      o.vx *= 0.99;
      o.y += o.vy;

      o.life -= 1.2;
      if (o.life <= 0) {
        resetParticle(i);
        continue;
      }

      double r = o.life / 100 * 24;
      injectVertex(i, xy, o.x - r, o.y - r, o.x + r, o.y + r);

      spriteSheet.injectTexCoords(i, uv, (++o.frame % frameCount));
    }

    _prevPoint = touchPoint;
    super.tick(duration);
  }

  double _updatePower() {
    double m = 0.25;
    if (touchPoint != null && _prevPoint != null) {
      double dx = touchPoint!.dx - _prevPoint!.dx;
      double dy = touchPoint!.dy - _prevPoint!.dy;
      m = min(1, sqrt(dx * dx + dy * dy) / 20 + m);
    }
    _power += (m - _power) * 0.05;
    return _power;
  }
}
