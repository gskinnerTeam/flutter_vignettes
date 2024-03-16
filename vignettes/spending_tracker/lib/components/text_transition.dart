import 'package:flutter/material.dart';

class TextTransition extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration duration;
  final double? width;

  TextTransition({required this.text, required this.textStyle, required this.duration, this.width});

  @override
  State createState() => _TextTransitionState(text);
}

class _TextTransitionState extends State<TextTransition> with SingleTickerProviderStateMixin {
  _TextTransitionState(this._string0) {
    _string1 = _string0;
  }

  late AnimationController _controller = AnimationController(vsync: this, duration: widget.duration);
  String _string0;
  String? _string1;

  @override
  void initState() {
    _controller.addListener(() => setState(() {}));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _string0 = _string1 ?? _string0;
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
    final fontSize = widget.textStyle.fontSize!;
    final double width = widget.width ?? _string0.length * fontSize / 1.4;
    return Container(
      width: width,
      height: fontSize * 1.2,
      child: Stack(
        children: [
          Positioned(
            top: 0 - _controller.value * fontSize,
            width: width,
            child: Text(
              _string0,
              textAlign: TextAlign.center,
              style: widget.textStyle,
            ),
          ),
          if (_string1 != null) ...{
            Positioned(
              top: fontSize - (_controller.value * fontSize),
              width: width,
              height: fontSize,
              child: Text(
                _string1!,
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
