import 'package:flutter/material.dart';

import 'package:shared/ui/blend_mask.dart';
import './indie_3d_model_controller.dart';
import './indie_3d_model.dart';
import 'main.dart';

class _Indie3dTextClipper extends CustomClipper<Rect> {
  final double y;
  final double height;

  _Indie3dTextClipper({this.y = 0, this.height = 0});

  @override
  getClip(Size size) {
    return Rect.fromLTWH(0, height + y, size.width, size.height - height);
  }

  @override
  bool shouldReclip(_Indie3dTextClipper oldClipper) {
    return true;
  }
}

class Indie3dPage extends StatelessWidget {
  final String topTitle;
  final String bottomTitle;
  final Color backgroundColor;
  final ImageProvider image;
  final int pageIndex;
  final double bottomTitleScale;

  final Indie3dModelController controller;

  final double topTitleClipProgress;
  final double bottomTitleClipProgress;
  final double backgroundShapeOpacity;

  Indie3dPage({
    this.topTitle = "",
    this.bottomTitle = "",
    this.backgroundColor,
    this.image,
    this.pageIndex = 0,
    this.controller,
    this.topTitleClipProgress = 0.0,
    this.bottomTitleClipProgress = 0.0,
    this.bottomTitleScale = 1.0,
    this.backgroundShapeOpacity = 0.85,
  });

  @override
  Widget build(context) {
    final appSize = MediaQuery.of(context).size;
    var textScale = appSize.aspectRatio > 1? 1.15 : .8;
    return Container(
      color: backgroundColor,
      child: Stack(
        children: [
          BlendMask(
            blendMode: BlendMode.hardLight,
            opacity: backgroundShapeOpacity,
            child: Indie3dModel(controller: controller, pageIndex: pageIndex * 2 + 0),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: appSize.height * (appSize.aspectRatio > 1? 1 : .80),
              child: Image(fit: BoxFit.fitHeight, image: image),
            ),
          ),
          BlendMask(
            blendMode: BlendMode.exclusion,
            child: Indie3dModel(controller: controller, pageIndex: pageIndex * 2 + 1),
          ),
          Align(
            alignment: Alignment.topRight,
            child: BlendMask(
              blendMode: BlendMode.difference,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 8, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildClippedText(topTitle, topTitleClipProgress, 72 * textScale, 0, 6, 1),
                    _buildClippedText(bottomTitle, bottomTitleClipProgress, 120 * textScale * bottomTitleScale, -10, 8, .9),
                  ],
                ),
              ),
            ),
          ),
          BlendMask(
            opacity: 0.24,
            blendMode: BlendMode.colorDodge,
            child: Image(
              width: appSize.width,
              fit: BoxFit.none,
              image: AssetImage('images/noise.png', package: App.pkg),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0x00000000), const Color(0x99000000)],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                color: Colors.white,
                child: Text(
                  'EXPLORE NOW',
                  style: TextStyle(
                    package: App.pkg,
                    letterSpacing: 1.1,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ClipRect _buildClippedText(String text, double progress, double fontSize, double yOffset, double spacing, double height) {
    return ClipRect(
      clipper: _Indie3dTextClipper(height: progress * fontSize, y: yOffset),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          package: App.pkg,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'Staatliches',
          letterSpacing: spacing,
          height: height,
          color: Colors.white,
        ),
      ),
    );
  }
}
