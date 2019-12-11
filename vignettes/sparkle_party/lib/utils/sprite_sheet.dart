import 'dart:typed_data';
import 'dart:ui' as ui;
import 'vertex_helpers.dart';
import 'package:flutter/material.dart';

// Simple sprite sheet helper.
class SpriteSheet {
  ui.Image image; // null until the ImageProvide finishes loading.
  int frameWidth;
  int frameHeight;
  int length;
  Float32List positions; // cached positions.

  SpriteSheet({@required ImageProvider imageProvider, @required this.length, @required this.frameWidth, this.frameHeight = 0}) {
    // Resolve the provider into a stream, then listen for it to complete.
    // This will happen synchronously if it's already loaded into memory.
    ImageStream stream = imageProvider.resolve(ImageConfiguration());
    ImageStreamListener listener = ImageStreamListener((info, _) { image = info.image; _calculatePositions(); });
    stream.addListener(listener);
  }

  Rect getFrame(int frame) {
    // Given a frame index, return the rect that describes that frame in the image.
    if (image == null || frame == null || frame < 0 || frame >= length) { return null; }
    int i = frame * 4;
    return Rect.fromLTRB(positions[i], positions[i+1], positions[i+2], positions[i+3]);
  }

  void injectTexCoords(int i, Float32List list, int frame) {
    int j = frame * 4;
    Float32List pos = positions;
    injectVertex(i, list, pos[j+0], pos[j+1], pos[j+2], pos[j+3]);
  }

  void _calculatePositions() {
    positions = Float32List(length * 4);
    int cols = (image.width / frameWidth).floor();
    int w = frameWidth;
    int h = frameHeight == 0 ? image.height : frameHeight; // default to the image's height

    for (int i=0; i< length; i++) {
      double x = (i % cols) * w + 0.0;
      double y = (i / cols).floor() * h + 0.0;
      positions[i * 4 + 0] = x; // x1
      positions[i * 4 + 1] = y; // y1
      positions[i * 4 + 2] = x + w; // x2
      positions[i * 4 + 3] = y + h; // y2
    }
  }
}
