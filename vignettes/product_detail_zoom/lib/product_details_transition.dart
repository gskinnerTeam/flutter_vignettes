import 'dart:math';

import 'package:flutter/material.dart';

import 'components/circle_painter.dart';
import 'main.dart';

class ProductDetailsTransition extends StatelessWidget {
  final double animationValue;
  final CurvedAnimation _curvedAnimation;
  final TextStyle bodyStyle =
      TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2, package: App.pkg);

  ProductDetailsTransition({Key key, this.animationValue = 1})
      : _curvedAnimation = CurvedAnimation(curve: Interval(0, .8, curve: Curves.easeOut), parent: AlwaysStoppedAnimation(animationValue)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Positioned(
          top: 25,
          left: 45,
          child: _SpeakerAttribute(
            attribute: 'Spectacular tonal range',
            animation: _getAttributeAnimWithInterval(0, .85),
            lineHeight: 270,
          ),
        ),
        Positioned(
          top: 75,
          left: 95,
          child: _SpeakerAttribute(
            attribute: 'Superior-grade aluminum',
            animation: _getAttributeAnimWithInterval(.35, .95),
            lineHeight: 250,
          ),
        ),
        Positioned(
          top: 120,
          left: 175,
          child: _SpeakerAttribute(
            attribute: 'Deep 30Hz bass',
            animation: _getAttributeAnimWithInterval(.45, 1),
            lineHeight: 185,
          ),
        ),
        ScaleTransition(
          scale: Tween<double>(begin: .6, end: 1).animate(_curvedAnimation),
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(.6, .7), end: Offset(.1, .95)).animate(_curvedAnimation),
            child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(_getCurvedAnimWithInterval(.2, 1)),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.01)
                    ..rotateY(Tween<double>(begin: -.09, end: 0).transform(CurvedAnimation(
                      curve: Interval(0, .8),
                      parent: AlwaysStoppedAnimation(animationValue),
                    ).value)),
                  child: Container(
                    width: 300,
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Perfect Sound'.toUpperCase(),
                            style: bodyStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 52, height: .9)),
                        Text(
                          'This is our best speaker yet.',
                          textAlign: TextAlign.start,
                          style: bodyStyle.copyWith(color: Colors.white, height: 1.5, fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  CurvedAnimation _getCurvedAnimWithInterval(double begin, double end) {
    return CurvedAnimation(curve: Interval(begin, end), parent: _curvedAnimation);
  }

  CurvedAnimation _getAttributeAnimWithInterval(double begin, double end) {
    var attributeAnim = CurvedAnimation(curve: Interval(.65, 1), parent: AlwaysStoppedAnimation(animationValue));
    return CurvedAnimation(curve: Interval(begin, end), parent: attributeAnim);
  }
}

class _SpeakerAttribute extends StatelessWidget {
  final double lineHeight;
  final Animation animation;
  final String attribute;

  const _SpeakerAttribute({Key key, this.lineHeight = 150, this.attribute, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double lineHeight = Tween<double>(begin: 0, end: this.lineHeight).transform(Curves.easeInOutQuad.transform(animation.value));
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        SlideTransition(
          position: Tween<Offset>(begin: Offset(0, -.5), end: Offset.zero).animate(_getAnimationWithInterval(.2, 1)),
          child: FadeTransition(
            opacity: _getAnimationWithInterval(.15, .95),
            child: Text(
              attribute,
              style: TextStyle(fontFamily: 'WorkSans', letterSpacing: 3, color: Colors.white, fontSize: 13.5, package: App.pkg),
            ),
          ),
        ),
        Positioned(
          top: lineHeight / 2 + 17,
          left: -lineHeight / 2 + 5,
          child: Transform.rotate(
            angle: pi / 2,
            child: Container(
              width: lineHeight,
              height: 1,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: lineHeight + 17,
          left: 5,
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(_getAnimationWithInterval(0, .3)),
            child: CustomPaint(
                painter: CirclePainter(
              radius: 3,
              color: Colors.white,
            )),
          ),
        ),
      ],
    );
  }

  CurvedAnimation _getAnimationWithInterval(double begin, double end) {
    return CurvedAnimation(curve: Interval(begin, end), parent: animation);
  }
}
