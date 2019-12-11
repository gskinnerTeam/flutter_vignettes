import 'package:flutter/material.dart';

class TextTransition extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration duration;
  final double width;

  TextTransition({this.text, this.textStyle, this.duration, this.width});

  @override
  State createState() => _TextTransitionState(text);
}

class _TextTransitionState extends State<TextTransition> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String _string0;
  String _string1;

  _TextTransitionState(this._string0);

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _string0 = _string1;
          _string1 = null;
          _controller.reset();
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextTransition oldWidget) {
    if (widget.text != oldWidget.text) {
      setState(() {
        _string1 = widget.text;
        _controller.forward();
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(context) {
    final double width = widget.width != null ? widget.width : _string0.length * widget.textStyle.fontSize / 1.4;
    return Container(
      width: width,
      height: widget.textStyle.fontSize * 1.2,
      child: Stack(
        children: [
          Positioned(
            top: 0 - _controller.value * widget.textStyle.fontSize,
            width: width,
            child: Text(
              _string0,
              textAlign: TextAlign.center,
              style: widget.textStyle,
            ),
          ),
          if (_string1 != null) ...{
            Positioned(
              top: widget.textStyle.fontSize - (_controller.value * widget.textStyle.fontSize),
              width: width,
              height: widget.textStyle.fontSize,
              child: Text(
                _string1,
                textAlign: TextAlign.center,
                style: widget.textStyle,
              ),
            ),
          },
        ],
      ),
    );
  }
}
