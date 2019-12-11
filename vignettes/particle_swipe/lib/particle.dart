import 'package:flutter/material.dart';

// Stores the data associated with a particle.
class Particle {
  double x;
  double y;
  double hue;
  Color color;
  double vx; // velocity x
  double vy;
  double vhue;
  double life;

  Particle(
      {this.x = 0.0,
      this.y = 0.0,
      this.vx = 0.0,
      this.vy = 0.0,
      this.life = 1.0,
      this.hue = 0.0,
      this.vhue = 0.0,
      this.color = Colors.transparent});

  // Returns an offset representing this particles, optionally with a transformation applied.
  Offset toOffset([Matrix4 transform]) {
    Offset o = Offset(x, y);
    if (transform == null) {
      return o;
    }
    return MatrixUtils.transformPoint(transform, o);
  }
}
