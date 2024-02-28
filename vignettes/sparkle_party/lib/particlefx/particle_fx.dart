import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../utils/sprite_sheet.dart';
import '../utils/vertex_helpers.dart';

// Abstract particle effects class, extended by specific effects implementations.
abstract class ParticleFX with ChangeNotifier {
  SpriteSheet spriteSheet;
  late double width;
  late double height;
  int count;

  Offset? touchPoint;
  late Offset center;

  List<Particle> particles = [];
  late Int32List colors;
  late Float32List xy;
  late Float32List uv;
  ui.Vertices? vertices;

  ParticleFX({required this.spriteSheet, required Size size, this.count = 10000}) {
    width = size.width;
    height = size.height;
    xy = Float32List(12 * count);
    uv = Float32List(12 * count);
    colors = Int32List(6 * count);
    center = Offset(width / 2, height / 2);
  }

  // Fills in the Particle list, and resets each Particle.
  // Override to add more capability if needed.
  void fillInitialData() {
    for (int i = 0; i < count; i++) {
      particles.add(Particle());
      resetParticle(i);
    }
  }

  // resets the basic Particle, and hides it.
  Particle resetParticle(int i) {
    Particle o = particles[i];
    o.x = o.y = o.vx = o.vy = o.life = 0;
    o.frame = spriteSheet.length ~/ 2;
    o.animate = false;
    injectColor(i, colors, 0);
    injectVertex(i, xy, 0, 0, 0, 0);
    spriteSheet.injectTexCoords(i, uv, o.frame);
    return o;
  }

  // Called each tick by the parent & updates all the particles.
  // Override to add effect specific logic, and call super to initiate the draw.
  void tick(Duration duration) {
    if (spriteSheet.image == null) {
      return;
    }

    vertices = ui.Vertices.raw(VertexMode.triangles, xy, textureCoordinates: uv, colors: colors);
    notifyListeners();
  }
}

// Basic Particle class, which can be extended to add additional data.
class Particle {
  double x;
  double y;
  double vx; // velocity x
  double vy;
  double life;
  int frame;
  bool animate;

  Particle({
    this.x = 0.0,
    this.y = 0.0,
    this.vx = 0.0,
    this.vy = 0.0,
    this.life = 0,
    this.frame = 0,
    this.animate = false,
  });
}
