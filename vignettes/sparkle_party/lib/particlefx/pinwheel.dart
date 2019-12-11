import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/rnd.dart';
import '../utils/sprite_sheet.dart';
import '../utils/vertex_helpers.dart';
import 'particle_fx.dart';

// Animated particle effects. Note that this just manages the data, ParticleFieldPainter renders the effect.
class Pinwheel extends ParticleFX {
  double _hue = 0.0;
  Offset _point;
  int arms = 11;

  Pinwheel({@required SpriteSheet spriteSheet, @required Size size}) :
  super(spriteSheet: spriteSheet, size: size) {
    _point = center;
  }

  void _activateParticle(int i, Offset pt) {
    Particle o = particles[i];

    o.x = pt.dx;
    o.y = pt.dy;
    double a = Rnd.getInt(0, arms) / arms * pi * 2 - _hue * 0.007 + Rnd.getDouble(0, pi/arms/2);
    double v = Rnd.getDouble(10, 12.0);
    o.vx = sin(a) * v;
    o.vy = cos(a) * v;

    o.animate = true;
    o.life = Rnd.getDouble(60, 100);
    o.frame = 0;

    double h = (_hue*0.2 + Rnd.ratio * 40.0 + a/pi * 180) % 360;
    int color = HSLColor.fromAHSL(1.0, h, 1.0, Rnd.getBit(0.05) * 0.6 + 0.4).toColor().value;
    injectColor(i, colors, color);

    if (o.animate) { o.frame = Rnd.getInt(0, spriteSheet.length); }
  }

  // Called each tick by the parent & updates all the particles
  @override
  void tick(Duration duration) {
    if (spriteSheet.image == null) { return; }
    if (particles[0] == null) { fillInitialData(); }

    _point += ((touchPoint ?? center) - _point) * (touchPoint == null ? 0.05 : 0.2);

    _hue += 10;

    int frameCount = spriteSheet.length;
    int addCount = touchPoint != null ? 200 : 20;

    for (int i=0; i<count; i++) {
      Particle o = particles[i];
      if (o.life == 0 && --addCount > 0) { _activateParticle(i, _point); }
      else if (o.life == 0) { continue; }

      o.x += o.vx;
      o.y += o.vy;

      o.life *= 0.95;
      o.life -= 1;
      if (o.life <= 0) {
        resetParticle(i);
        continue;
      }

      double r = o.life/100 * 48;
      injectVertex(i, xy, o.x - r, o.y - r, o.x + r, o.y + r);

      if (o.animate) { spriteSheet.injectTexCoords(i, uv, (++o.frame % frameCount)); }
    }

    super.tick(duration);
  }
}
