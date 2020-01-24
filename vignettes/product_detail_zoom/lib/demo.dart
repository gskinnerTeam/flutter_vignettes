import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_detail_zoom/components/delayed_fade_in.dart';
import 'package:product_detail_zoom/product_details_hero_flight.dart';
import 'package:shared/env.dart';
import 'package:shared/ui/sprite.dart';

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
  bool hasLoadedOnce = false;
  Size _screenSize;
  double _frameHeight;
  double _frameWidth;
  double _buttonAlpha = 0;
  double _speakerAlpha = 0;

  TextStyle bodyStyle = TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2, package: App.pkg);

  @override
  void initState() {
    super.initState();
    _buttonAlpha = 0;
    _transitionAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _transitionIn();
  }

  void _transitionIn() async {
    await Future.delayed(Duration(milliseconds: 1));
    setState(()=>_speakerAlpha=1);
    _transitionAnimController.value = 1;
    await Future.delayed(Duration(milliseconds: !hasLoadedOnce? 500 : 2000));
    _transitionAnimController.reverse();
    setState(() => _buttonAlpha = 1);
    hasLoadedOnce = true;
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
          AnimatedOpacity(
            opacity: _speakerAlpha,
            duration: Duration(seconds: 1),
            child: Hero(
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
                  margin: EdgeInsets.only(top: Env.isGalleryActive? 0 : 30),
                    width: _frameWidth,
                    height: _frameHeight,
                    child: Sprite(
                        image: AssetImage("images/speaker_sprite.png", package: App.pkg), frameWidth: 360, frameHeight: 500, frame: 1)),
              ),
            ),
          ),

          //PULSING BUTTON - Uses AnimatedOpacity to fade in and out
          Center(
            child: Transform.translate(
              offset: Offset(100, -70),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 350),
                opacity: _buttonAlpha,
                child: PulsingButton(onPressed: _handleLearnMorePressed, icon: Icons.add),
              ),
            ),
          ),

          //
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0).animate(_transitionAnimController),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //DESCRIPTION
                  SlideTransition(
                    position: Tween(begin: Offset.zero, end: Offset(-.1, 0))
                        .animate(CurvedAnimation(curve: Interval(0, 1, curve: Curves.easeOut), parent: _transitionAnimController)),
                    child: Column(
                      children: <Widget>[
                        Text('Classic Speaker 2700'.toUpperCase(),
                            textAlign: TextAlign.justify,
                            style: bodyStyle.copyWith(
                                fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, fontSize: 30, letterSpacing: 5)),
                        SizedBox(height: 8),
                        Text(
                            'This speaker provides a home soundscape unlike any other with its high quality sound and sleek design. You won\'t believe it until you hear it.',
                            textAlign: TextAlign.start,
                            style: bodyStyle.copyWith(color: Colors.white, fontSize: 12, letterSpacing: 2.8, height: 1.3))
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildRoundedBtn("BUY NOW \$349.95", _handleLearnMorePressed, true),
                      SizedBox(height: 12),
                      //LEARN MORE
                      _buildRoundedBtn("LEARN MORE", _handleLearnMorePressed, false),
                    ],
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

  Widget _buildRoundedBtn(String label, Function onPressed, bool useWhiteBg) {
    var border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.white, width: 1.5));
    return MaterialButton(
        minWidth: 225,
        height: 55,
        onPressed: onPressed,
        color: useWhiteBg ? Colors.white : Colors.black,
        textColor: Colors.black,
        shape: border,
        child: Text(label, style: bodyStyle.copyWith(color: useWhiteBg ? Colors.black : Colors.white)));
  }

  Widget _buildAppBar() {
    return AppBar(
      primary: !Env.isGalleryActive,
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

  void _handleLearnMorePressed() async {
    //Don't accept button presses if we're currently fading the btn in or out
    if (_buttonAlpha < 1) return;
    //Fade button out
    setState(() => _buttonAlpha = 0);
    //Kick off main animation sequence
    await _transitionAnimController.forward();
    //Show new page route, which will place the Hero on top of everything
    await Navigator.push(
        context,
        FadeColorPageRoute(
          color: Colors.black,
          enterPage: ProductDetailView()
        ));
    _transitionIn();
    //Fade button back in, now that hero is covering it
  }
}
