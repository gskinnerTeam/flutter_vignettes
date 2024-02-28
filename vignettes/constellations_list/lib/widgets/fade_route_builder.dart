import 'package:flutter/material.dart';

class FadeRouteBuilder extends PageRouteBuilder {
  final Widget page;
  final int duration;

  FadeRouteBuilder({required this.page, this.duration = 1000})
      : super(
          transitionDuration: Duration(milliseconds: duration),
          //Page builder doesn't do anything special, just return the page we were passed in.
          pageBuilder: (context, animation, secondaryAnimation) => page,
          //transitionsBuilder builds 2 nested transitions, one for transitionIn (animation), and one for transitionOut (secondaryAnimation)
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
                //Transition from 0 - 1 when coming on the screen
                opacity: Tween<double>(begin: 0, end: 1).animate(animation),
                child: FadeTransition(
                  //Transition from 1 to 0 when leaving the screen
                  opacity: Tween<double>(begin: 1, end: 0).animate(secondaryAnimation),
                  child: child,
                ));
          },
        );
}
