import 'demo_data.dart';
import 'constellation_detail_view.dart';
import 'star_field/star_field.dart';
import 'widgets/fade_route_builder.dart';
import 'widgets/nested_navigator.dart';
import 'constellation_list_view.dart';

import 'package:flutter/material.dart';

class ConstellationsListDemo extends StatefulWidget {
  @override
  _ConstellationsListDemoState createState() => _ConstellationsListDemoState();
}

class _ConstellationsListDemoState extends State<ConstellationsListDemo> with TickerProviderStateMixin {
  static const double idleSpeed = .2;
  static const double maxSpeed = 10;
  static const int starAnimDurationIn = 3000;

  //double _speed = idleSpeed;
  GlobalKey<NavigatorState> _navigationStackKey = GlobalKey<NavigatorState>();

  ValueNotifier<double> _speedValue = ValueNotifier(idleSpeed);

  late AnimationController _starAnimController;
  late Animation<double> _starAnimSequence;
  late List<ConstellationData> _constellationsData;

  @override
  void initState() {
    _constellationsData = DemoData().getConstellations();
    _starAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: starAnimDurationIn),
      reverseDuration: Duration(milliseconds: starAnimDurationIn ~/ 2),
    );
    _starAnimController.addListener(() {
      _speedValue.value = _starAnimSequence.value;
    });

    //Create an animation sequence that moves our stars back, then forwards, then to rest at 0.
    //This will be played each time we load a detail page, to create a flying through space transition effect
    _starAnimSequence = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: idleSpeed, end: -2).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -2, end: 20).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 20, end: 0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      )
    ]).animate(_starAnimController);
    super.initState();
  }

  @override
  void dispose() {
    _starAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int starCount = 400;
    //The main content for the app is a Stack, with the StarField as a constant background element, and a Nested Navigator to handle content transitions
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //Wrap stars in a ValueListenableBuilder so it will get rebuilt whenever the _speedValue changes
          ValueListenableBuilder<double>(
            valueListenable: _speedValue,
            builder: (context, value, child) {
              //Scrolling star background
              return StarField(starSpeed: value, starCount: starCount);
            },
          ),
          //Main content
          SafeArea(
            child: NestedNavigator(
              //Need to assign a key to our navigator, so we can pop/push it later
              navKey: _navigationStackKey,
              routeBuilder: _buildPageRoute,
              //When nested navigator has been popped, reverse the star anim back to start
              onBackPop: _reverseStarAnim,
            ),
          ),
        ],
      ),
    );
  }

  //Create a PageRoute to handle the new page transition
  Route _buildPageRoute(RouteSettings route) {
    Widget page;
    //DetailView
    if (route.name == ConstellationDetailView.route) {
      //Get the data for the new view from the .arguments property
      var args = route.arguments as _DetailViewRouteArguments;
      page = ConstellationDetailView(
          data: args.data,
          redMode: args.redMode,
          //Pass a time value into the content view, so it knows how long to delay the fadeIn. This allows us to choreograph the star animation, with the page content, without a direct dependency
          contentDelay: starAnimDurationIn + 1000,
          //When the back button is tapped in the detail view, pop the nested navigator and reverse the animation controller for the stars
          onBackTap: () {
            _navigationStackKey.currentState?.pop();
            _reverseStarAnim();
          });
    }
    //Default to ListView as our home route
    else {
      page = ConstellationListView(
        constellations: _constellationsData,
        onItemTap: _handleListItemTap,
        onScrolled: _handleListScroll,
      );
    }
    //Use a FadeRouteBuilder which fades the new view in, while fading the old page out. Necessary as the content pages have transparent backgrounds.
    return FadeRouteBuilder(page: page);
  }

  //When the list is scrolled, use it's velocity to control the speed of the starfield
  void _handleListScroll(delta) {
    setState(() {
      if (delta == 0) {
        _speedValue.value = idleSpeed; //If we've stopped scrolling, revert to the idle speed
      } else {
        _speedValue.value = delta.clamp(-maxSpeed, maxSpeed); //clamp scrollDelta to min/max values
      }
    });
  }

  //When an item in the list is tapped, push a Detail view onto the navigator. Pass along the data as as route argument.
  void _handleListItemTap(ConstellationData data, bool redMode) {
    //Add details page to Navigator
    _navigationStackKey.currentState?.pushNamed(
      ConstellationDetailView.route,
      arguments: _DetailViewRouteArguments(data, redMode),
    );
    //Start star transition
    _starAnimController.forward(from: 0);
  }

  void _reverseStarAnim() {
    if (_starAnimController.isAnimating) {
      _starAnimController.reverse();
    } else {
      _speedValue.value = idleSpeed;
    }
  }
}

class _DetailViewRouteArguments {
  final ConstellationData data;
  final bool redMode;

  _DetailViewRouteArguments(this.data, this.redMode);
}
