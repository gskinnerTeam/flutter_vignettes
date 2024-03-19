import 'package:flutter/material.dart';

class DarkInkControls extends StatefulWidget {
  final ValueNotifier<bool> darkModeValue;

  DarkInkControls({required this.darkModeValue});

  @override
  State createState() {
    return _DarkInkControlsState(darkModeValue);
  }
}

class _DarkInkControlsState extends State<DarkInkControls> with SingleTickerProviderStateMixin {
  ValueNotifier<bool> _darkModeValue;

  late AnimationController _controller;
  late Animation<double> _buttonAnimation0;
  late Animation<double> _buttonAnimation1;
  late Animation<double> _buttonAnimation2;

  late Color _backgroundColor;
  late Color _foregroundColor;

  _DarkInkControlsState(ValueNotifier<bool> darkModeValue) : _darkModeValue = darkModeValue {
    _darkModeValue.addListener(_handleDarkModeChange);
    _updateColor();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _buttonAnimation0 = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 100.0),
          weight: 10,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 100.0, end: 100.0),
          weight: 76,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 100.0, end: 0.0),
          weight: 10,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 4,
        ),
      ],
    ).animate(_controller);
    _buttonAnimation1 = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 2,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 100.0),
          weight: 10,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 100.0, end: 100.0),
          weight: 76,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 100.0, end: 0.0),
          weight: 10,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 2,
        ),
      ],
    ).animate(_controller);
    _buttonAnimation2 = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 4,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 100.0),
          weight: 10,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 100.0, end: 100.0),
          weight: 76,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 100.0, end: 0.0),
          weight: 10,
        ),
      ],
    ).animate(_controller);
    _buttonAnimation0.addListener(() {
      setState(() {
        if (_controller.value > 0.5) {
          _updateColor();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    // Show some animated control buttons
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // Animate the controls moving offscreen using slightly offset animations
      children: [
        Transform(
          transform: Matrix4.translationValues(0, _buttonAnimation0.value, 0),
          child: FloatingActionButton(
            mini: true,
            heroTag: 0,
            onPressed: () => {},
            backgroundColor: _backgroundColor,
            foregroundColor: _foregroundColor,
            child: Icon(Icons.bookmark_border),
          ),
        ),
        Padding(padding: EdgeInsets.all(10)),
        Transform(
          transform: Matrix4.translationValues(0, _buttonAnimation1.value, 0),
          child: FloatingActionButton(
            mini: true,
            heroTag: 1,
            onPressed: () => {},
            backgroundColor: _backgroundColor,
            foregroundColor: _foregroundColor,
            child: Icon(Icons.more_horiz),
          ),
        ),
        Padding(padding: EdgeInsets.all(10)),
        Transform(
          transform: Matrix4.translationValues(0, _buttonAnimation2.value, 0),
          child: FloatingActionButton(
            heroTag: 2,
            mini: true,
            onPressed: () => {},
            backgroundColor: _backgroundColor,
            foregroundColor: _foregroundColor,
            child: Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }

  void _handleDarkModeChange() {
    _controller.forward(from: 0.0);
    setState(() {});
  }

  void _updateColor() {
    final darkColor = Color(0xFF171137);
    final lightColor = Color(0xFF67ECDC);
    _backgroundColor = _darkModeValue.value ? darkColor : lightColor;
    _foregroundColor = _darkModeValue.value ? lightColor : darkColor;
  }
}
