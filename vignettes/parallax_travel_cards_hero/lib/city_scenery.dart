import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'components/rotation_3d.dart';
import 'demo_data.dart';
import 'main.dart';
import 'styles.dart';

class CityScenery extends StatelessWidget {
  final double animationValue;
  final CityData city;

  const CityScenery({Key key, this.animationValue = 0, @required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var animation = AlwaysStoppedAnimation(animationValue);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _buildBackgroundTransition(animation),
        _buildCardInfo(animation, screenSize),
        _buildRoadTransition(animation, screenSize),
        _buildCloudsAnimation(animation),
        _buildCityAndTreesTransition(animation, screenSize),
        _buildLeavesAnimation(animation),
      ],
    );
  }

  Widget _buildCardInfo(Animation animation, Size screenSize) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0).animate(CurvedAnimation(curve: Interval(0, .22), parent: animation)),
      child: Container(
        padding: EdgeInsets.only(right: 35.0, left: 35.0, bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Sized box gives the space of the city image in the stack
            SizedBox(height: screenSize.height * .22),
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text(city.title, style: Styles.cardTitle),
            ),
            Text(city.description, textAlign: TextAlign.center, style: Styles.cardSubtitle),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text('Learn More'.toUpperCase(), style: Styles.cardAction),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundTransition(Animation animation) {
    var gradientStart =
        ColorTween(begin: city.color, end: Color(0xFFfde9c8)).animate(CurvedAnimation(curve: Curves.easeOut, parent: animation));
    var gradientEnd = ColorTween(begin: city.color, end: Color(0xFFfdf8f1)).evaluate(animation);
    var borderRadiusAnimation = Tween<double>(begin: Styles.cardBorderRadius, end: 0).transform(animationValue);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusAnimation),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientStart.value, gradientEnd],
          )),
    );
  }

  Widget _buildRoadTransition(Animation animation, Size screenSize) {
    double scale = .55 * .2;
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Interval(.7, 1, curve: Curves.easeIn), parent: animation)),
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, -1.4), end: Offset.zero).animate(animation),
        child: SizeTransition(
          sizeFactor: animation,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: Center(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/Road.png',
                width: double.infinity,
                height: screenSize.height * scale - 5,
                fit: BoxFit.fitHeight,
                package: App.pkg,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloudsAnimation(Animation animation) {
    return FadeTransition(
      opacity: animation,
      child: _Clouds(),
    );
  }

  Widget _buildCityAndTreesTransition(Animation animation, Size screenSize) {
    // City Image Animation
    var sizeStart = Size(screenSize.width * .55, screenSize.height * .24);
    var sizeEnd = Size(screenSize.width, screenSize.height * .35);
    var sizeTransition =
        Tween(begin: sizeStart, end: sizeEnd).animate(CurvedAnimation(curve: Interval(.25, 1, curve: Curves.easeIn), parent: animation));

    var cityPositionTransition = Tween(begin: Offset(0, -screenSize.height * .112), end: Offset.zero)
        .animate(CurvedAnimation(curve: Interval(0.5, 1, curve: Curves.easeIn), parent: animation));
    //Trees Animations
    var treesOpacityTransition =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Interval(.75, 1, curve: Curves.easeIn), parent: animation));

    return Transform.translate(
      offset: cityPositionTransition.value,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _CityImage(
            size: sizeTransition.value,
            city: city,
          ),
          FadeTransition(
            opacity: treesOpacityTransition,
            child: _Trees(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeavesAnimation(Animation animation) {
    return FadeTransition(
      opacity: animation,
      child: _Leaves(),
    );
  }
}

class _Clouds extends StatefulWidget {
  final double animationValue;

  _Clouds({this.animationValue = 0.5});

  @override
  _CloudsState createState() => _CloudsState();
}

class _CloudsState extends State<_Clouds> with SingleTickerProviderStateMixin {
  static Map<String, _CloudsState> _cachedState = {};
  Ticker _ticker;
  double _animationValue;

  @override
  void initState() {
    super.initState();
    //Restore old state from the static cache, workaround because Hero causes our widget to lose state
    var prevState = _cachedState[widget.key.toString()];
    if (prevState != null) {
      _animationValue = prevState._animationValue;
    } else {
      _animationValue = widget.animationValue;
    }
    //Replace cached state with ourselves
    _cachedState[widget.key.toString()] = this;
    _ticker = Ticker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  _onTick(Duration d) {
    double speed = .0003;

    setState(() {
      if (_animationValue <= 1)
        _animationValue += speed;
      else
        _animationValue = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var dxPosition = Tween<double>(begin: -screenSize.width * .1, end: screenSize.width * 1.8).transform(_animationValue);

    return Stack(
      children: <Widget>[
        Positioned(
          top: screenSize.height * .065,
          left: dxPosition - (screenSize.width * 0.65),
          child: Image.asset(
            'images/CloudLarge.png',
            width: screenSize.width * .2,
            package: App.pkg,
          ),
        ),
        Positioned(
          top: screenSize.height * .12,
          left: dxPosition * .5,
          child: Image.asset(
            'images/CloudSmall.png',
            width: screenSize.width * .15,
            package: App.pkg,
          ),
        )
      ],
    );
  }
}

class _Leaves extends StatefulWidget {
  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<_Leaves> with SingleTickerProviderStateMixin {
  static Map<String, _LeavesState> _cachedState = {};
  Ticker _ticker;
  double _animationValue;

  @override
  initState() {
    super.initState();
    //Restore old state from the static cache, workaround because Hero causes our widget to lose state
    var prevState = _cachedState[widget.key.toString()];
    if (prevState != null) {
      _animationValue = prevState._animationValue;
    } else {
      _animationValue = 0;
    }
    //Replace cached state with ourselves
    _cachedState[widget.key.toString()] = this;

    _ticker = Ticker(_onTick)..start();
  }

  _onTick(Duration d) {
    double speed = .001;
    setState(() {
      if (_animationValue + speed < 1)
        _animationValue += speed;
      else
        _animationValue = 0;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _Leaf(
            animationValue: _animationValue,
            rotationScale: 1.5,
            curve: Curves.easeInOutSine,
            getCurvePath: (double screenPosition) => sin(screenPosition) * 15 + 200),
        _Leaf(
            animationValue: _animationValue,
            rotationScale: 1.7,
            curve: Curves.linearToEaseOut,
            getCurvePath: (double screenPosition) => -cos(screenPosition) * 30 + 130),
        _Leaf(
            animationValue: _animationValue,
            rotationScale: 1.2,
            curve: Curves.ease,
            getCurvePath: (double screenPosition) => atan(screenPosition) * 10 + 150),
      ],
    );
  }
}

class _Leaf extends StatelessWidget {
  final double animationValue;
  final double rotationScale;
  final Function getCurvePath;
  final Curve curve;

  _Leaf({@required this.animationValue, @required this.getCurvePath, this.curve = Curves.linear, this.rotationScale = 1});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    var dxPosition =
        Tween<double>(begin: -10, end: screenSize.width + 10).transform(Interval(0, .9, curve: this.curve).transform(animationValue));
    var dyPosition = Tween<double>(begin: 0, end: pi * 2).transform(animationValue);
    var rotation = Tween<double>(begin: 0, end: 360).transform(Curves.easeOutSine.transform(animationValue));

    return Positioned(
      child: Rotation3d(
          rotationY: rotation * rotationScale,
          child: Image.asset(
            'images/BlowingLeaf.png',
            width: screenSize.width * .015 + Random().nextDouble() * .01,
            package: App.pkg,
          )),
      bottom: getCurvePath(dyPosition),
      left: dxPosition,
    );
  }
}

class _Trees extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: screenSize.height * .07,
          right: screenSize.width * .2,
          child: _getTreeAsset(screenSize, false),
        ),
        Positioned(
          bottom: screenSize.height * .07,
          left: screenSize.width * .2,
          child: _getTreeAsset(screenSize, false),
        ),
        Positioned(
          bottom: screenSize.height * .01,
          right: screenSize.width * .1,
          child: _getTreeAsset(screenSize, true),
        ),
        Positioned(
          bottom: screenSize.height * .01,
          left: screenSize.width * .1,
          child: _getTreeAsset(screenSize, true),
        ),
      ],
    );
  }

  Widget _getTreeAsset(Size screenSize, bool isFront) {
    double sizeProportion = isFront ? .08 : .05;
    return Image.asset(
      'images/Tree.png',
      width: screenSize.width * sizeProportion,
      package: App.pkg,
    );
  }
}

class _CityImage extends StatelessWidget {
  final Size size;
  final CityData city;

  const _CityImage({Key key, this.size, this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            width: size.width,
            height: size.height,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Image.asset('images/${city.name}/${city.name}-Back.png', package: App.pkg,),
                Image.asset('images/${city.name}/${city.name}-Middle.png', package: App.pkg,),
                Image.asset('images/${city.name}/${city.name}-Front.png', package: App.pkg,),
              ],
            )),
        Image.asset('images/Ground.png', width: size.width, package: App.pkg,)
      ],
    );
  }
}
