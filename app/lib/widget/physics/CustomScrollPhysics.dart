import 'dart:io'; // 플랫폼 확인을 위한 패키지
import 'package:flutter/widgets.dart';

class CustomScrollPhysics extends ScrollPhysics {
  final double scrollSpeedFactor;

  const CustomScrollPhysics(
      {this.scrollSpeedFactor = 1.0, ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
      scrollSpeedFactor: scrollSpeedFactor,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset * scrollSpeedFactor;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (velocity.abs() < 10) return null; // 작은 속도는 즉시 정지

    if (Platform.isIOS) {
      return BouncingScrollSimulation(
        position: position.pixels,
        velocity: velocity * scrollSpeedFactor,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        spring: SpringDescription.withDampingRatio(
          mass: 0.5,
          stiffness: 100,
          ratio: 1.1,
        ),
      );
    } else {
      return ClampingScrollSimulation(
        position: position.pixels,
        velocity: velocity * scrollSpeedFactor,
        friction: 0.015, // 마찰 조절
      );
    }
  }
}
