import 'package:flutter/material.dart';

import 'main.dart';

class DarkInkBar extends StatefulWidget {
  final ValueNotifier<bool> darkModeValue;

  DarkInkBar({required this.darkModeValue});

  @override
  State createState() {
    return _DarkInkBarState(darkModeValue);
  }
}

class _DarkInkBarState extends State<DarkInkBar> with SingleTickerProviderStateMixin {
  _DarkInkBarState(this._darkModeValue) {
    _darkModeValue.addListener(_handleDarkModeChange);
  }

  static final Color darkColor = Color(0xFF171137);
  static final Color lightColor = Color(0xFF67ECDC);

  ValueNotifier<bool> _darkModeValue;

  late AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  late Animation<double> _iconOpacityAnimation = TweenSequence<double>(
    [
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: .20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: .2),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: .20),
    ],
  ).animate(_controller);
  late Animation<double> _backgroundColorAnimation = TweenSequence<double>(
    [
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: .20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: .1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: .20),
    ],
  ).animate(_controller);
  late Animation<double> _foregroundColorAnimation = TweenSequence<double>(
    [
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: .35),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: .1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.0), weight: .55),
    ],
  ).animate(_controller);

  final _moonIcon = AssetImage('assets/images/icon-moon.png', package: App.pkg);
  final _sunIcon = AssetImage('assets/images/icon-sun.png', package: App.pkg);
  late ImageProvider _darkModeToggleIconImage = _moonIcon;

  @override
  void initState() {
    _iconOpacityAnimation.addListener(() {
      setState(() {
        _updateIcon();
      });
    });
    _updateIcon();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final appSize = MediaQuery.of(context).size;
    final backgroundColor =
        HSVColor.lerp(HSVColor.fromColor(lightColor), HSVColor.fromColor(darkColor), _backgroundColorAnimation.value)!
            .toColor();
    final foregroundColor =
        HSVColor.lerp(HSVColor.fromColor(lightColor), HSVColor.fromColor(darkColor), _foregroundColorAnimation.value)!
            .toColor();
    // Build a simple bar with 3 animated buttons and a bottom border
    return Positioned(
      left: 0,
      top: 0,
      width: appSize.width,
      child: Column(children: [
        Container(
          color: backgroundColor,
          child: SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Use flat buttons so we don't have to deal with the drop shadows
                children: [
                  TextButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(Colors.transparent),
                      foregroundColor: MaterialStatePropertyAll(foregroundColor),
                    ),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  TextButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(Colors.transparent),
                      foregroundColor: MaterialStatePropertyAll(foregroundColor),
                    ),
                    child: ImageIcon(AssetImage('assets/images/icon-r.png', package: App.pkg)),
                  ),
                  TextButton(
                    onPressed: () => _darkModeValue.value = !(_darkModeValue.value ?? true),
                    style: ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(Colors.transparent),
                      foregroundColor: MaterialStatePropertyAll(foregroundColor),
                    ),
                    child: Opacity(
                      opacity: _iconOpacityAnimation.value,
                      child: ImageIcon(_darkModeToggleIconImage),
                    ),
                  ),
                ]),
          ),
        ),
        Container(
          height: 2,
          color: _darkModeValue.value ? Color(0xFF0098A3) : Color(0xFF2B777E),
        ),
      ]),
    );
  }

  void _handleDarkModeChange() {
    if (_darkModeValue.value) {
      _controller.forward(from: 0.0);
    } else {
      _controller.reverse(from: 1.0);
    }
    setState(() {});
  }

  void _updateIcon() => _darkModeToggleIconImage = (_controller.value > 0.5) ? _sunIcon : _moonIcon;
}
