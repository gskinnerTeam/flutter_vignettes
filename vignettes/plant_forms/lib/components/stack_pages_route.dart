import 'package:flutter/material.dart';

import 'header.dart';

class StackPagesRoute extends PageRouteBuilder {
  final Widget enterPage;
  final List<Widget> previousPages;
  StackPagesRoute({required this.previousPages, required this.enterPage})
      : super(
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
            return Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: <Widget>[
                Header(),
                for (int i = 0; i < previousPages.length; i++)
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: Offset(0, ((previousPages.length - i) * -0.05) + 0.05),
                      end: Offset(0, (previousPages.length - i) * -0.05),
                    ).animate(CurvedAnimation(curve: Curves.easeInCubic, parent: animation)),
                    child: previousPages[i],
                  ),
                SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: enterPage,
                )
              ],
            );
          },
        );
}
