import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// Simple sprite sheet helper.
class SpriteSheet {
  ui.Image image; // null until the ImageProvide finishes loading.
  int frameWidth;
  int frameHeight;
  int length;

  SpriteSheet({@required ImageProvider imageProvider, @required this.length, @required this.frameWidth, this.frameHeight = 0}) {
    // Resolve the provider into a stream, then listen for it to complete.
    // This will happen synchronously if it's already loaded into memory.
    ImageStream stream = imageProvider.resolve(ImageConfiguration());
    ImageStreamListener listener = ImageStreamListener((info, _) { image = info.image; });
    stream.addListener(listener);
  }

  Rect getFrame(int index) {
    // Given a frame index, return the rect that describes that frame in the image.
    if (image == null || index < 0 || index >= length) { return null; }

    int cols = (image.width / frameWidth).floor();
    int x = index % cols;
    int y = (index / cols).floor();
    int h = frameHeight == 0 ? image.height : frameHeight; // default to the image's height

    return Rect.fromLTWH(x * frameWidth + 0.0, y * h + 0.0, frameWidth + 0.0, h + 0.0);
  }
}
