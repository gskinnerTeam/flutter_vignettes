import 'package:flutter/material.dart';

import 'swipe_item.dart';

// This replaces the list item widget when it is deleted, and implements the deletion animation.
class RemovedSwipeItem extends StatelessWidget {
  final Animation<double> animation;

  RemovedSwipeItem({required this.animation});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation, // animate height to 0
      child: Container(
        height: SwipeItem.nominalHeight,
        decoration: BoxDecoration(
          gradient: SwipeItem.getGradient(Color(0xffcb4a65), 1.0, 1.0),
        ),
      ),
    );
  }
}
