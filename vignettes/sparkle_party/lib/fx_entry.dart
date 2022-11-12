import 'package:flutter/material.dart';

import 'particlefx/particle_fx.dart';
import 'utils/sprite_sheet.dart';

class FXEntry {
  ParticleFX Function({required SpriteSheet spriteSheet, required Size size}) create;
  String name;
  ImageProvider? icon;

  FXEntry(this.name, {required this.create, this.icon});
}


