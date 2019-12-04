import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/rnd.dart';
import '../utils/sprite_sheet.dart';
import '../utils/vertex_helpers.dart';
import 'particle_fx.dart';

// Animated particle effects. Note that this just manages the data, ParticleFieldPainter renders the effect.
class Fireworks extends ParticleFX {
  double _hue = 120.0;
  int _cooldown = 0; // ticks before another firework is allowed
  int _nextAuto = 10; // ticks before another firework is automatically triggered
  Offset _touchPoint;

  Fireworks({@required SpriteSheet spriteSheet, @required Size size}) :
    super(spriteSheet: spriteSheet, size: size);

  @override
  void fillInitialData() {
    for (int i=0; i<count; i++) {
      particles[i] = _Particle();
      resetParticle(i);
    }
  }

  @override
  set touchPoint(Offset pt) {
    // avoid premature clears from fast taps.
    if (pt != null && _cooldown <= 0) {
      _touchPoint = pt;
      _cooldown = 4;
    }
  }

  void _activateParticle(int i, Offset pt, double wow) {
    _Particle o = particles[i];
    o.x = pt.dx;
    o.y = pt.dy;
    double maxv = wow * 18;
    double a = Rnd.getRad();
    double v = Rnd.getDouble(0.5, maxv);
    o.vx = sin(a) * v;
    o.vy = cos(a) * v - 5;

    // fake 3d effect:
    o.z = 0.0;
    o.vz = cos(v/maxv * pi/2) * wow;

    o.animate = false;
    o.life = Rnd.getDouble(60, 100);

    double h = (_hue + Rnd.getDouble(0, 40.0)) % 360.0;
    int color = HSLColor.fromAHSL(1.0, h, 1.0, 0.45).toColor().value;
    injectColor(i, colors, color);
  }

  // Called each tick by the parent & updates all the particles
  @override
  void tick(Duration duration) {
    if (spriteSheet.image == null) { return; }
    if (particles[0] == null) { fillInitialData(); }

    int frameCount = spriteSheet.length;
    int addCount = 0;
    double wow = 0.0;

    if (_touchPoint != null) {
      wow = Rnd.getDouble(0.4, 1.0);
      addCount = (wow * 600).floor();
      _hue = Rnd.getDeg();
    }

    for (int i=0; i<count; i++) {
      _Particle o = particles[i];

      if (o.life == 0 && --addCount > 0) { _activateParticle(i, _touchPoint, wow); }
      else if (o.life == 0) { continue; }

      o.vy += 0.2;
      o.vy *= 0.95;
      o.y += o.vy;

      o.vx *= 0.95;
      o.x += o.vx;

      o.vz *= 0.98;
      o.z += o.vz;

      if (--o.life <= 0) {
        resetParticle(i);
        continue;
      }

      double r = (o.life/100 * 0.7 + 0.3) * (8 + (o.z));
      injectVertex(i, xy, o.x - r, o.y - r, o.x + r, o.y + r);

      if (o.life < 30 && !o.animate) {
        o.animate = true;
        injectColor(i, colors, 0xFFFFFFFF);
      }
      if (o.animate) { spriteSheet.injectTexCoords(i, uv, Rnd.getInt(0, frameCount)); }
    }

    _touchPoint = null;
    if (--_cooldown < -_nextAuto) {
      touchPoint = Offset(Rnd.getDouble(0.2, 0.8) * width, Rnd.getDouble(0.2, 0.6) * height);
      _nextAuto = Rnd.getInt(10, 90);
    }

    super.tick(duration);
  }
}

class _Particle extends Particle {
  double z = 0.0; // fake 3d
  double vz = 0.0;
}
