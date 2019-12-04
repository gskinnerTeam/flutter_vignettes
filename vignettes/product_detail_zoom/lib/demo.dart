import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_detail_zoom/product_details_hero_flight.dart';
import 'package:shared/ui/sprite.dart';

import 'components/circle_painter.dart';
import 'components/fade_color_page_route.dart';
import 'details.dart';
import 'main.dart';
import 'pulsing_button.dart';

class ProductDetailZoomDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductDetailZoomDemoState();
}

class _ProductDetailZoomDemoState extends State<ProductDetailZoomDemo> with SingleTickerProviderStateMixin {
  AnimationController _transitionAnimController;
  bool _isFirstInit;
  Size _screenSize;
  double _frameHeight;
  double _frameWidth;
  double _buttonAlpha = 0;

  TextStyle bodyStyle = TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2, package: App.pkg);

  @override
  void initState() {
    super.initState();
    _isFirstInit = true;
    _buttonAlpha = 0;
    _transitionAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 1600));
    _transitionIn();
  }

  void _transitionIn() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() => _buttonAlpha = 1);
  }

  @override
  void dispose() {
    _transitionAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _initFrameValues();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          _buildAppBar(),
          //Create a Hero tagged to match the instance details view
          Hero(
            tag: 'hero-speaker',
            //Use a custom flightShuttleBuilder to control the hero transition
            flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
              return ProductDetailsHeroFlight(
                animation: animation,
                toHeroContext: toHeroContext,
                framwWidth: _frameWidth,
                framwHeight: _frameHeight,
              );
            },
            //The child of the hero, is the main speaker animation
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  width: _frameWidth,
                  height: _frameHeight,
                  child: Sprite(
                      image: AssetImage("images/speaker_sprite.png", package: App.pkg), frameWidth: 360, frameHeight: 500, frame: 1)),
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Transform.translate(
              offset: Offset(100, -70),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 350),
                opacity: _buttonAlpha,
                child: PulsingButton(
                  onPressed: _handleOnPressed,
                  icon: Icons.add,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: _screenSize.height * .43,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildSpeakerDescription(),
                  Container(
                    padding: const EdgeInsets.only(right: 36.0, left: 36.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 18, bottom: 12.0),
                          child: _buildBuyNowButton(),
                        ),
                        _buildLearnMoreButton()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _initFrameValues() {
    double screenRatio = _screenSize.height / _screenSize.width;
    double frameRatio = screenRatio < 2 ? screenRatio / 2 : .95;
    _frameWidth = _screenSize.width * frameRatio;
    _frameHeight = (500 * _frameWidth) / 360;
  }

  Widget _buildSpeakerDescription() {
    return SlideTransition(
      position: Tween(begin: Offset.zero, end: Offset(-.1, 0))
          .animate(CurvedAnimation(curve: Interval(.5, 1, curve: Curves.easeOut), parent: _transitionAnimController)),
      child: Column(
        children: <Widget>[
          Text('Classic Speaker 2700'.toUpperCase(),
              textAlign: TextAlign.justify,
              style: bodyStyle.copyWith(fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, fontSize: 30, letterSpacing: 5)),
          SizedBox(height: 8),
          Text(
              'This speaker provides a home soundscape unlike any other with its high quality sound and sleek design. You won\'t believe it until you hear it.',
              textAlign: TextAlign.start,
              style: bodyStyle.copyWith(color: Colors.white, fontSize: 12, letterSpacing: 2.8, height: 1.3))
        ],
      ),
    );
  }

  Widget _buildBuyNowButton() {
    return MaterialButton(
      height: 55,
      onPressed: () {},
      color: Colors.white,
      textColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Text(
        'Buy Now \$349.95'.toUpperCase(),
        style: bodyStyle,
      ),
    );
  }

  Widget _buildLearnMoreButton() {
    return MaterialButton(
      height: 55,
      onPressed: () {},
      color: Colors.transparent,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.white, width: 1.5)),
      child: Text(
        'Learn More'.toUpperCase(),
        style: bodyStyle,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: Icon(CupertinoIcons.left_chevron, color: Colors.white, size: 36),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: Image.asset('images/shopping_bag.png', width: 20, height: 20, fit: BoxFit.contain, package: App.pkg),
        )
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  bool _isTransitioning = false;

  void _handleOnPressed() async {
    this._isFirstInit = false;
    //Don't accept button presses if we're currently fading the btn in or out
    if (_buttonAlpha < 1) return;
    //Fade button out
    setState(() => _buttonAlpha = 0);
    //Kick off main animation sequence
    _transitionAnimController.forward().whenComplete(() => _transitionAnimController.reset());
    //Wait a bit to let the btn fade out
    await Future.delayed(Duration(milliseconds: 300));
    //Show new page route, which will place the Hero on top of everything
    Navigator.push(
        context,
        FadeColorPageRoute(
          color: Colors.black,
          enterPage: ProductDetailView(),
        ));
    //Fade button back in, now that hero is covering it
    setState(() => _buttonAlpha = 1);
  }
}
