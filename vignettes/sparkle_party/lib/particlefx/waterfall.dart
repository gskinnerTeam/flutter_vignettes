import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/rnd.dart';
import '../utils/sprite_sheet.dart';
import '../utils/vertex_helpers.dart';
import 'particle_fx.dart';

// Animated particle effects. Note that this just manages the data, ParticleFieldPainter renders the effect.
class Waterfall extends ParticleFX {
  double _hue = 0.0;

  Waterfall({required SpriteSheet spriteSheet, required Size size})
      : super(spriteSheet: spriteSheet, size: size, count: size.shortestSide > 600 ? 40000 : 20000);

  @override
  void fillInitialData() {
    for (int i = 0; i < count; i++) {
      particles.add(_Particle());
      resetParticle(i);
    }
  }

  @override
  Particle resetParticle(int i) {
    Particle o = super.resetParticle(i);
    o.y = Rnd.ratio * height;
    return o;
  }

  void _activateParticle(int i) {
    _Particle o = particles[i] as _Particle;

    o.x = Rnd.ratio * width;
    o.y = 0.0;
    o.vx = Rnd.getDouble(-2, 2);
    o.vy = Rnd.ratio * 5;
    o.animate = Rnd.getBool(0.02);
    o.scale = Rnd.getDouble(0.8, 1.2);

    double h = (_hue + Rnd.ratio * 40.0 + o.x / width * 90.0) % 360;
    int color = HSLColor.fromAHSL(1.0, h, 1.0, o.animate ? 1.0 : 0.4).toColor().value;
    injectColor(i, colors, color);
  }

  // Called each tick by the parent & updates all the particles
  @override
  void tick(Duration duration) {
    if (spriteSheet.image == null) {
      return;
    }
    if (particles.isEmpty) {
      fillInitialData();
    }

    _hue -= 1;

    int frameCount = spriteSheet.length;
    const double maxD = 100.0;

    for (int i = 0; i < count; i++) {
      _Particle o = particles[i] as _Particle;
      double dx, dy, d;

      if (touchPoint != null &&
          (dy = touchPoint!.dy - o.y) < maxD &&
          (dx = touchPoint!.dx - o.x) < maxD &&
          (d = sqrt(dx * dx + dy * dy)) < maxD) {
        double a = atan2(dy, dx);
        double v = (maxD - d) / maxD * -1.0;
        o.vx += v * cos(a);
        o.vy += v * sin(a);
      }

      o.vy += 0.1;
      o.x += o.vx;
      o.vx *= 0.99;
      o.y += o.vy;

      if (o.y > height) {
        _activateParticle(i);
      }

      double r = 12.0 * o.scale;
      injectVertex(i, xy, o.x - r, o.y - r, o.x + r, o.y + r);
      if (o.animate) {
        spriteSheet.injectTexCoords(i, uv, (++o.frame % frameCount));
      }
    }

    super.tick(duration);
  }
}

class _Particle extends Particle {
  double scale = 1.0;
}
