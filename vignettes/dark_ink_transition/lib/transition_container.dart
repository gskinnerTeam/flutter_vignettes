import 'package:flutter/material.dart';

import 'package:shared/ui/widget_mask.dart';
import 'package:shared/ui/animated_sprite.dart';

import 'main.dart';

class TransitionContainer extends StatefulWidget {
  final Widget child;

  TransitionContainer({required this.child});

  @override
  State createState() {
    return _TransitionContainerState(child);
  }
}

class _TransitionContainerState extends State<TransitionContainer> with SingleTickerProviderStateMixin {
  _TransitionContainerState(this._childBackground);
  late AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
  late Animation<double> _animation = TweenSequence(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 0.0),
        weight: 30,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 34.0),
        weight: 70,
      ),
    ],
  ).animate(_controller);

  ImageProvider _image = AssetImage('assets/images/ink_mask.png', package: App.pkg);

  Widget? _childForeground;
  Widget? _childBackground;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _childBackground = _childForeground;
          _childForeground = null;
        });
        _controller.reset();
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(TransitionContainer oldWidget) {
    if (widget.child != oldWidget.child) {
      setState(() {
        _childForeground = widget.child;
      });
      _controller.forward();
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
}
