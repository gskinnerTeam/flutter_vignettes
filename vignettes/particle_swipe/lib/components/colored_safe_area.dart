
import 'package:flutter/material.dart';

class ColoredSafeArea extends StatelessWidget {

  //Color properties, gradient takes priority
  final Color color;
  final Gradient gradient;

  //Passed through to SafeArea
  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final EdgeInsets minimum;
  final Widget child;

  const ColoredSafeArea({Key key, this.left = true, this.top = true, this.right = true, this.bottom = true, this.minimum, this.child, this.color, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (gradient != null)
            ? Container(
          decoration: BoxDecoration(gradient: gradient),
        )
            : Container(
          color: color ?? Color(0x0),
        ),
        SafeArea(child: child, left: left, right: right, top: top, bottom: bottom, minimum: minimum ?? EdgeInsets.all(0))
      ],
    );
  }
}
