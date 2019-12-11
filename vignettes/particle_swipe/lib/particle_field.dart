import 'dart:math';

import 'package:flutter/material.dart';

import 'particle.dart';

// Animated particle effects. Note that this just manages the data, ParticleFieldPainter renders the effect.
class ParticleField with ChangeNotifier {
  List<Particle> particles = [];
  int lastT = 0;

  ParticleField();

  // Creates the "delete" effect: red particles exploding from a horizontal line
  void lineExplosion(x, y, w, [count = 150]) {
    for (int i = 0; i < count; i++) {
      particles.add(Particle(
          x: x + i / count * w, // evenly spaced along the line
          y: y,
          vx: Random().nextDouble() * 5.0 - 5.0,
          vy: Random().nextDouble() * 3.0 - 2.5,
          life: Random().nextDouble() * 0.5 + 0.5,
          color: Color(0xffcb4a65).withOpacity(i.isEven ? 0.8 : 0.3)
          ));
    }
  }

  // Creates the "favorite" effect: blue particles exploding out from a central point (like a firework)
  void pointExplosion(x, y, [count = 55]) {
    for (int i = 0; i < count; i++) {
      double rot = i / count * pi * 2; // angle to apply velocity
      double vel = Random().nextDouble() * 2 + .5;
      particles.add(Particle(
          x: x + 18 * cos(rot),
          y: y + 18 * sin(rot),
          vx: cos(rot) * vel,
          vy: sin(rot) * vel,
          life: Random().nextDouble() * 0.5 + 0.5,
          color: Color(0xff54d8e6).withOpacity(i.isEven ? 0.8 : 0.3)
          ));
    }
  }

  // Called each tick by the parent & updates all the particles
  void tick(Duration duration) {
    // Calculate how much time has ellapsed since the last tick, and calculate a multiplier from that.
    double t = min(1.5, (duration.inMilliseconds - lastT) / 1000 * 60);
    lastT = duration.inMilliseconds;

    int l = particles.length;
    for (int i = l - 1; i >= 0; i--) {
      // Update each particle's properties.
      Particle o = particles[i];
      o.vy += 0.05 * t; // "gravity"
      o.x += o.vx * t;
      o.y += o.vy * t;
      o.hue = (o.hue + o.vhue) % 360;

      o.life -= 0.01 * t;
      if (o.life <= 0.0) {
        particles.removeAt(i);
      }
    }

    // If we started this tick with particles, then notify the ParticleFieldPainter that it needs to re-paint.
    if (l > 0) {
      notifyListeners();
    }
  }
}
