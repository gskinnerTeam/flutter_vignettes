import 'package:flutter/material.dart';

import 'components/circle_painter.dart';

class PulsingButton extends StatefulWidget {
  final Function onPressed;
  final IconData icon;

  const PulsingButton({Key key, @required this.onPressed, @required this.icon}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton> with SingleTickerProviderStateMixin {
  AnimationController _btnAnimController;
  CurvedAnimation _btnAnim;

  @override
  void initState() {
    super.initState();
    _btnAnimController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200))..repeat();
    _btnAnim = CurvedAnimation(curve: Curves.linear, parent: _btnAnimController);
  }

  @override
  void dispose() {
    _btnAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        FadeTransition(
          opacity: Tween<double>(begin: .7, end: 0).animate(_btnAnim),
          child: ScaleTransition(
            scale: Tween<double>(begin: .5, end: 1).animate(_btnAnim),
            child: CustomPaint(
              painter: CirclePainter(
                radius: 28,
                color: Color(0xff27aeef),
              ),
              //Add a sizedbox child to the CustomPaint, to give the button more hit area
              child: SizedBox(
                width: 70,
                height: 70,
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _btnAnimController,
          builder: (BuildContext context, Widget child) {
            double opacity = Tween<double>(begin: .7, end: .9).transform(_btnAnim.value);
            return MaterialButton(
              height: 28,
              splashColor: Color(0xff0f668f),
              hoverColor: Color(0xff0f668f),
              color: Color(0xff27aeef).withOpacity(opacity),
              textColor: Colors.white,
              child: Icon(widget.icon),
              shape: CircleBorder(),
              onPressed: widget.onPressed,
            );
          },
        )
      ],
    );
  }
}
