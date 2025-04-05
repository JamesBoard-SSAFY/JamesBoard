import 'package:flutter/material.dart';
import 'package:jamesboard/main.dart';

class CustomScrollPhysics extends ScrollPhysics {
  final double scrollSpeedFactor;

  const CustomScrollPhysics({this.scrollSpeedFactor = 1.0})
      : super(parent: null);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(scrollSpeedFactor: scrollSpeedFactor);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    logger.d("scrollSpeedFactor: $scrollSpeedFactor");
    logger.d("Scroll Offset: $offset, Adjusted: ${offset * scrollSpeedFactor}");
    return offset * scrollSpeedFactor;
  }
}
