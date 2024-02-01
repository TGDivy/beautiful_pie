// given a box, a point, and a radius, return true if the point is inside the circle
import 'dart:math';

import 'package:flutter/material.dart';

bool isInsideCircle(Offset center, double radius, Offset point) {
  return (point - center).distanceSquared <= radius * radius;
}

bool isInsideBoxCircle(RenderBox box, Offset point, double radius) {
  final Offset localOffset = box.globalToLocal(point);
  final Offset center = Offset(box.size.width / 2, box.size.height / 2);
  return isInsideCircle(center, radius, localOffset);
}

// find angle of point relative to center of box
double findAngle(RenderBox box, Offset point) {
  final Offset localOffset = box.globalToLocal(point);
  final Offset center = Offset(box.size.width / 2, box.size.height / 2);
  final Offset offset = localOffset - center;
  double angle = atan2(offset.dy, offset.dx) + pi / 2;
  if (angle < 0) {
    angle += 2 * pi;
  }
  return angle;
}
