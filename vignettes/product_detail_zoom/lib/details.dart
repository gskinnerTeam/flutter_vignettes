import 'package:flutter/material.dart';
import 'package:product_detail_zoom/pulsing_button.dart';
import 'package:shared/ui/sprite.dart';

import 'components/delayed_fade_in.dart';
import 'main.dart';
import 'product_details_transition.dart';

class ProductDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenRatio = screenSize.height / screenSize.width;
    double frameRatio = screenRatio < 2 ? screenRatio / 2 : .95;
    double frameWidth = screenSize.width * frameRatio;
    double frameHeight = (500 * frameWidth) / 360;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'hero-speaker',
                child: Container(
                    width: frameWidth,
                    height: frameHeight,
                    child: Sprite(
                        image: AssetImage("images/speaker_sprite.png", package: App.pkg), frameWidth: 360, frameHeight: 500, frame: 59)),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(width: frameWidth, height: frameHeight, child: ProductDetailsTransition())),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0, left: 76, right: 76),
                child: MaterialButton(
                  height: 55,
                  minWidth: double.infinity,
                  onPressed: () {},
                  color: Colors.white,
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    'Buy Now \$349.95'.toUpperCase(),
                    style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2, package: App.pkg),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(.6, 0),
              child: DelayedFadeIn(
                delay: Duration(seconds: 1),
                child: PulsingButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icons.remove,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
