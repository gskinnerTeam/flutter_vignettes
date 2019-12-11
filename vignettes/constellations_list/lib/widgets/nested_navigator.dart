import 'package:flutter/material.dart';

class NestedNavigator extends StatefulWidget {
  final Route Function(RouteSettings route) routeBuilder;
  final GlobalKey<NavigatorState> navKey;
  final Function onBackPop;

  const NestedNavigator({Key key, this.routeBuilder, this.navKey, this.onBackPop}) : super(key: key);

  @override
  _NestedNavigatorState createState() => _NestedNavigatorState();
}

class _NestedNavigatorState extends State<NestedNavigator> {
  @override
  Widget build(BuildContext context) {
    //Wrap navigator in a WillPop widget, so we can intercept the hardware back button event
    return WillPopScope(
      onWillPop: () async {
        var navigator = widget.navKey.currentState;
        if (navigator.canPop()) {
          if(widget.onBackPop != null) widget.onBackPop();
          return !navigator.pop();
        }
        return true;
      },
      child: Navigator(
        key: widget.navKey,
        //Generate a page, in response to a route request
        onGenerateRoute: (routeSettings) => widget.routeBuilder(routeSettings),
        //In order for the nested-navigator to handle hero animations, we must pass it an Observer of type HeroController
        observers: [
      HeroController(
        //Optional: Use a nice arc'd tween instead of the default linear
        createRectTween: (begin, end) => MaterialRectArcTween(begin: begin, end: end),
      )
        ],
      ),
    );
  }
}
