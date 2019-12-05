import 'package:flutter/material.dart';

import 'package:shared/ui/blend_mask.dart';

import 'fx_renderer.dart';
import 'fx_entry.dart';
import 'main.dart';
import 'particlefx/fireworks.dart';
import 'particlefx/pinwheel.dart';
import 'particlefx/comet.dart';
import 'particlefx/waterfall.dart';
import 'fx_switcher.dart';
import 'touchpoint_notification.dart';
import 'utils/sprite_sheet.dart';

class SparklePartyDemo extends StatefulWidget {
  static final List<FXEntry> fxs = [
    FXEntry("Waterfall", create: ({spriteSheet, size}) => Waterfall(spriteSheet: spriteSheet, size: size)),
    FXEntry("Fireworks", create: ({spriteSheet, size}) => Fireworks(spriteSheet: spriteSheet, size: size)),
    FXEntry("Comet", create: ({spriteSheet, size}) => Comet(spriteSheet: spriteSheet, size: size)),
    FXEntry("Pinwheel", create: ({spriteSheet, size}) => Pinwheel(spriteSheet: spriteSheet, size: size)),
  ];

  static final List<String> instructions = [
    'TOUCH AND DRAG ON THE SCREEN',
    'TAP OR DRAG ON THE SCREEN',
    'DRAG ON THE SCREEN',
    'DRAG ON THE SCREEN',
  ];

  @override
  _SparklePartyDemoState createState() => _SparklePartyDemoState();
}

class _SparklePartyDemoState extends State<SparklePartyDemo> with TickerProviderStateMixin {
  int _fxIndex = 0;
  int _buttonIndex = 0;

  AnimationController _transitionController;
  AnimationController _textController;

  @override
  void initState() {
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Listenable.merge([_transitionController, _textController]).addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          //Main Background image
          Positioned.fill(
            child: Image.asset("assets/sparkleparty_bg.png", fit: BoxFit.cover, package: App.pkg),
          ),

          //Centered logo png
          Center(
            child: Image.asset("assets/sparkleparty_logo.png", package: App.pkg),
          ),
          Opacity(
            opacity: 1.0 - _transitionController.value,
            child: NotificationListener<TouchPointChangeNotification>(
              onNotification: _handleInteraction,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return FxRenderer(
                    fx: SparklePartyDemo.fxs[_fxIndex],
                    size: constraints.biggest,
                    spriteSheet: SpriteSheet(
                      imageProvider: AssetImage("assets/sparkleparty_spritesheet_2.png", package: App.pkg),
                      length: 16, // number of frames in the sprite sheet.
                      frameWidth: 64,
                      frameHeight: 64,
                    ),
                  );
                },
              ),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Image.asset("assets/sparkleparty_logo_outline.png", package: App.pkg),
            ),
          ),
          if (!_textController.isCompleted) ...{
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 136),
                child: BlendMask(
                  blendMode: BlendMode.srcOver,
                  opacity: 1.0 - _textController.value,
                  child: Text(
                    SparklePartyDemo.instructions[_fxIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12, package: App.pkg),
                  ),
                ),
              ),
            ),
          },
          FXSwitcher(activeEffect: _buttonIndex, callback: _handleFxChange),
        ],
      ),
    );
  }

  void _handleFxChange(int index) {
    if (index == _fxIndex) return;
    setState(() => _buttonIndex = index);
    _transitionController.forward(from: 0.0).whenComplete(() {
      setState(() => _fxIndex = index);
      _transitionController.reverse(from: 1.0);
      _textController.reverse();
    });
  }

  bool _handleInteraction(TouchPointChangeNotification notification) {
    if (_textController.velocity <= 0) {
      _textController.forward();
    }
    return false;
  }
}
