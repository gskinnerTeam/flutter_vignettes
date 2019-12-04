import 'package:flutter/material.dart';

class FadeColorPageRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Color color;

  FadeColorPageRoute({this.enterPage, @required this.color})
      : super(
          transitionDuration: Duration(seconds: 3),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            Animation fadeOut = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Interval(0, .2), parent: animation));
            Animation fadeIn = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Interval(.8, 1), parent: animation));
            return Stack(children: <Widget>[
              FadeTransition(
                opacity: fadeOut,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: color,
                ),
              ),
              FadeTransition(
                opacity: fadeIn,
                child: child,
              )
            ]);
          },
        );
}
