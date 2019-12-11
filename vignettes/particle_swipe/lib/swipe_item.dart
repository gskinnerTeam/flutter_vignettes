import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared/physics/constrained_scroll_physics.dart';

import 'demo_data.dart';
import 'message_card.dart';

enum SwipeAction { remove, favorite }

// List item that handles right & left swiping.
class SwipeItem extends StatefulWidget {
  static const double swipeDistance = 96.0;
  static const double nominalHeight = 110.0;

  // Exposed as a static helper method so it can also be used by RemovedSwipeItem:
  static LinearGradient getGradient(Color color, double ratio, double sign) {
    return LinearGradient(
      colors: [
        color.withOpacity(ratio * 1.0),
        color.withOpacity(ratio * 0.30),
        color.withOpacity(ratio * 0.10),
      ],
      stops: [
        0.012,
        0.012,
        1.0,
      ],
      begin: Alignment(sign, 0.0),
      end: Alignment(-sign * ratio, 0.0),
    );
  }

  final Email data;
  final bool isEven;
  final Function(GlobalKey, {SwipeAction action}) onSwipe; // called when a row is swiped left.

  SwipeItem({@required this.data, this.onSwipe, @required this.isEven});

  @override
  State<SwipeItem> createState() {
    return SwipeItemState();
  }
}

class SwipeItemState extends State<SwipeItem> {
  ScrollController _scrollController;
  double _swipeDistance = 0.0;
  Key _key = GlobalKey();
  bool _isPerformingAction = false;

  SwipeItemState();

  @override
  void initState() {
    _resetScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the swipe state. How far, what direction, etc.
    final double swipeRatio = math.min(1.0, _swipeDistance.abs() / SwipeItem.swipeDistance);
    final bool lToR = _swipeDistance < 0.0;
    final double swipeSign = _swipeDistance.sign;
    final double swipeDistance = _swipeDistance.abs();

    final Color indicatorColor = lToR ? Color(0xff4ac0cb) : Color(0xffcb4a65);

    // Draw the item based on the swipe state:
    return Container(
      key: _key,
      alignment: Alignment.center,
      height: SwipeItem.nominalHeight,

      // Gradient background:
      decoration: BoxDecoration(
        gradient: SwipeItem.getGradient(indicatorColor, swipeRatio, swipeSign),
      ),

      child: Stack(children: [
        // The swipe indicator icon:
        Positioned.fill(
          child: Align(
            alignment: Alignment(swipeSign, 0.0),
            child: Transform(
              alignment: FractionalOffset(0.5, 0.5),
              transform: Matrix4.identity()
                ..translate(swipeDistance * swipeSign * -0.5, 0.0)
                ..scale(0.5 + 0.5 * swipeRatio),
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      boxShadow: [
                        if (widget.data.isFavorite && lToR)
                          BoxShadow(color: Colors.white70.withOpacity(swipeRatio), blurRadius: 18)
                      ],
                      borderRadius: BorderRadius.circular(50),
                      color: widget.data.isFavorite || !lToR ? Colors.white : Colors.transparent),
                ),
                Icon(
                  lToR ? Icons.stars : Icons.cancel,
                  color: indicatorColor,
                  size: 36.0,
                )
              ]),
            ),
          ),
        ),

        // The item content inside a horizontal scroll view that will provide the swipe physics for us:
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: ConstrainedScrollPhysics(
              maxOverscroll: SwipeItem.swipeDistance * 1.2,
            ),
            controller: _scrollController,
            child: Opacity(
              opacity: 1.0 - swipeRatio * 0.9,
              child: Transform.scale(
                  scale: 1.0 - swipeRatio * 0.1,
                  child: EmailCard(
                    email: widget.data,
                    backgroundColor: widget.isEven ? Color(0xff272845) : Color(0xff323052),
                  )),
            )),
      ]),
    );
  }

  void _resetScrollController() {
    // _scrollController is attached to the horizontal scroll view, and notifies _handleSwipe of changes.
    _scrollController?.dispose();
    _scrollController = new ScrollController();
    _scrollController.addListener(_handleSwipe);
  }

  void _handleSwipe() {
    double d = _scrollController.position.pixels;
    if (d > SwipeItem.swipeDistance && !_isPerformingAction) {
      // Completed a left swipe. Call onRemove, and reset the scroll controller to release the swipe.
      widget.onSwipe?.call(_key, action: SwipeAction.remove);
      _resetScrollController();
    } else if (d < -SwipeItem.swipeDistance && !_isPerformingAction) {
      _isPerformingAction = true;
      // Right swipe.
      widget.onSwipe?.call(_key, action: SwipeAction.favorite);
      _scrollController
          .animateTo(0, duration: Duration(milliseconds: 800), curve: Interval(.25, 1, curve: Curves.easeOutQuad))
          .whenComplete(() => _isPerformingAction = false);
    }
    // Redraw the item with the new swipe distance:
    setState(() {
      _swipeDistance = d;
    });
  }
}
