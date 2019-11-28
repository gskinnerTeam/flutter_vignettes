import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/physics.dart';

class ConstrainedScrollPhysics extends BouncingScrollPhysics {
  final double maxOverscroll;
  final double maxOverscrollFactor;

  const ConstrainedScrollPhysics({
    ScrollPhysics parent,
    this.maxOverscrollFactor,
    this.maxOverscroll
  }) : assert(maxOverscroll != null || maxOverscrollFactor != null), super(parent: parent);

  @override
  ConstrainedScrollPhysics applyTo(ScrollPhysics ancestor) {
    return ConstrainedScrollPhysics(parent: buildParent(ancestor), maxOverscroll:maxOverscroll, maxOverscrollFactor:maxOverscrollFactor);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (!position.outOfRange) return offset;

    final double overscrollPastStart = math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd = math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast = math.max(overscrollPastStart, overscrollPastEnd);

    final double direction = offset.sign;
    final double cur = offset + overscrollPast;
    final double max = maxOverscroll ?? maxOverscrollFactor * position.viewportDimension;
    final double ratio = math.max(0, 1-cur/max);
    
    return direction * offset.abs() * ratio;
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
    mass: 0.15, // 0.5
    stiffness: 250.0, // 100
    ratio: 1.25, // 1.1
  );
}