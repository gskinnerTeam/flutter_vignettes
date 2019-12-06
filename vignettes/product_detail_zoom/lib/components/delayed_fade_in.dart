import 'package:flutter/material.dart';

class DelayedFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const DelayedFadeIn({Key key, this.child, @required this.delay, this.duration = const Duration(milliseconds: 700)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DelayedFadeInState();
}

class _DelayedFadeInState extends State<DelayedFadeIn> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.duration = widget.duration + widget.delay;
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: CurvedAnimation(curve: Interval(.9, 1), parent: _animationController), child: widget.child);
  }
}
