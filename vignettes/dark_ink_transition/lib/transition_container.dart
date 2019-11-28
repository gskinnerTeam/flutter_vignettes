import 'package:flutter/material.dart';

import 'package:shared/ui/widget_mask.dart';
import 'package:shared/ui/animated_sprite.dart';

import './demo.dart';
import 'main.dart';

class TransitionContainer extends StatefulWidget {

  final ValueNotifier<bool> darkModeValue;
  final Widget child;

  TransitionContainer({ this.darkModeValue, this.child });

  @override
  State createState() {
    return _TransitionContainerState(darkModeValue, child);
  }
}

class _TransitionContainerState extends State<TransitionContainer>
    with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _animation;

  ImageProvider _image;

  Widget _childForeground;
  Widget _childBackground;

  _TransitionContainerState(ValueNotifier<bool> darkModeValue, this._childBackground) {
    darkModeValue?.addListener(handleDarkModeChange);
  }

  @override
  void initState() {
    _image = AssetImage('assets/images/mask_transition_sheet.png', package: App.pkg);

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 30,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 35.0),
          weight: 70,
        ),
      ],
    ).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _controller.reset();
          _childBackground = _childForeground;
          _childForeground = null;
        });
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(TransitionContainer oldWidget) {
    if (widget.child != oldWidget.child) {
      _childForeground = widget.child;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final appSize = MediaQuery.of(context).size;
    final width = appSize.width;
    final height = appSize.height;

    List<Widget> children = <Widget>[
        Container(
          width: width,
          height: height,
          child: _childBackground,
        ),
    ];

    // If we swapped the child then add the foreground to the list of children when animating
    if (_childForeground != null) {
      children.add(
        // Draw the foreground masked over the background
        WidgetMask(
          maskChild: Container(
            width: width,
            height: height,
            // Draw the transition animation as the mask
            child: AnimatedSprite(
              image: _image,
              frameWidth: 360,
              frameHeight: 720,
              animation: _animation,
            ),
          ),
          child: Container(
            width: width,
            height: height,
            child: _childForeground,
          ),
        ),
      );
    }

    return Positioned(
      left: 0,
      width: width,
      height: height,
      child: Stack(
        children: children,
      ),
    );
  }

  void handleDarkModeChange() {
    _controller.forward(from: 0.0);
  }
}

