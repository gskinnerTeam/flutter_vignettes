import 'package:flutter/material.dart';

//Create a transition that fades in the new view, while fading out a white background
class WhitePageRoute extends PageRouteBuilder {
  final Widget enterPage;

  WhitePageRoute({required this.enterPage})
      : super(
            transitionDuration: Duration(milliseconds: 1700),
            pageBuilder: (context, animation, secondaryAnimation) => enterPage,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var fadeIn =
                  Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Interval(.7, 1), parent: animation));
              var fadeOut =
                  Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Interval(0, .2), parent: animation));
              return Stack(children: <Widget>[
                FadeTransition(opacity: fadeOut, child: Container(color: Colors.white)),
                FadeTransition(opacity: fadeIn, child: child)
              ]);
            });
}
