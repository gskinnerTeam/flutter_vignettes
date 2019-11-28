import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'star_field_painter.dart';

class StarField extends StatefulWidget {
  final double starSpeed;
  final int starCount;

  const StarField({Key key, this.starSpeed = 3, this.starCount = 500 }) : super(key: key);

  @override
  _StarFieldState createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField> {
  List<Star> _stars;
  double _maxZ = 500;
  double _minZ = 1;
  ui.Image _glowImage;

  Ticker _ticker;

  void _initStars(BuildContext context) {
    //Start async image load
    _loadGlowImage();
    //Create stars, randomize their starting values
    _stars = [];
    for (var i = widget.starCount; i-- > 0;) {
      var s = _randomizeStar(Star(), true);
      _stars.add(s);
    }
    _ticker = new Ticker(_handleStarTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_stars == null) {
      _initStars(context);
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: CustomPaint(
        painter: StarFieldPainter(
          _stars,
          glowImage: _glowImage,
        ),
      ),
    );
  }

  void _handleStarTick(Duration elapsed) {
    setState(() {
      advanceStars(widget.starSpeed);
    });
  }

  void advanceStars(double distance) {
    _stars.forEach((s) {
      //Move stars on the z, and reset them when they reach the viewport
      s.z -= distance; // * elapsed.inMilliseconds;
      if (s.z < _minZ) {
        _randomizeStar(s, false);
      } else if (s.z > _maxZ) {
        s.z = _minZ;
      }
    });
  }

  Star _randomizeStar(Star star, bool randomZ) {
    Random rand = Random();
    star.x = (-1 + rand.nextDouble() * 2) * 75;
    star.y = (-1 + rand.nextDouble() * 2) * 75;
    star.z = randomZ ? rand.nextDouble() * _maxZ : _maxZ;
    star.rotation = rand.nextDouble() * pi * 2;
    //Some fraction of stars are purple, and bigger than the rest
    if (rand.nextDouble() < .1) {
      star.color = Color(0xffD4A1FF);
      star.size = 2 + rand.nextDouble() * 2;
    } else {
      star.color = Colors.white;
      star.size = .5 + rand.nextDouble() * 2;
    }
    return star;
  }

  void _loadGlowImage() async {
    final ByteData data = await rootBundle.load('${App.bundle}/assets/glow.png');
    ui.decodeImageFromList(new Uint8List.view(data.buffer), (img) => _glowImage = img);
  }
}
