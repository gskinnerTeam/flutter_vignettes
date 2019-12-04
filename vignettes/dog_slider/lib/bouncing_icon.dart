import 'package:flutter/material.dart';

class BouncingWidget extends StatefulWidget {
  final bool isVisible;
  final Widget child;
  final double maxBounce;

  const BouncingWidget({Key key, this.isVisible, this.child, this.maxBounce = 20}) : super(key: key);

  @override
  _BouncingWidgetState createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget> {
  double _offsetY = 0;
  Duration _bounceDuration = Duration(milliseconds: 700);
  Curve _bounceCurve = Curves.easeOut;

  @override
  void initState() {
    _bounceIcon();
    super.initState();
  }

  void _bounceIcon() async {
    _bounceCurve = Curves.easeOut;
    setState(() => _offsetY = 20);
    await Future.delayed(_bounceDuration);
    _bounceCurve = Curves.easeIn;
    setState(() => _offsetY = 0);
    await Future.delayed(_bounceDuration);
    _bounceIcon();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isVisible? 1 : 0,
      duration: Duration(milliseconds: 350),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: _offsetY),
        curve: _bounceCurve,
        duration: _bounceDuration,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value, 0),
            child: widget.child,
          );
        },
      ),
    );
  }
}
