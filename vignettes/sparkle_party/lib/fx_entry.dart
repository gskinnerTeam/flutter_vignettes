import 'package:flutter/material.dart';

import 'particlefx/particle_fx.dart';
import 'utils/sprite_sheet.dart';

class FXEntry {
  ParticleFX Function(SpriteSheet spriteSheet, Size size) create;
  String name;
  ImageProvider? icon;

  FXEntry(this.name, {required this.create, this.icon});
}
