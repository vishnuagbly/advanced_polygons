import 'package:advanced_polygons/extensions/coord.dart';
import 'package:advanced_polygons/extensions/list.dart';
import 'package:advanced_polygons/extensions/num.dart';
import 'package:flutter/material.dart';

import 'angle.dart';
import 'circle.dart';
import 'line.dart';

class Corner {
  late final Coord prev;
  final Coord point;
  late final Coord next;
  late final Circle circle;
  late final bool clockwise;
  final bool inCircle;

  Corner.raw(this.prev, this.point, this.next, this.circle, this.clockwise,
      this.inCircle);

  ///Provide [rect] in case the object is bounded inside a box, [rect].
  Corner(Coord? prev, this.point, Coord? next, num radius,
      [Rect? rect, this.inCircle = false]) {
    this.prev = prev ?? next ?? point;
    this.next = next ?? prev ?? point;

    final crossProduct = (point - this.prev).cross(this.next - point);
    if (crossProduct == 0) {
      throw ArgumentError('Given corner is a straight line');
    }

    clockwise = crossProduct < 0;

    circle =
        _circleIfPointCloseToEdge(_circleAccordingToLine(radius), radius, rect);
  }

  Circle _circleIfPointCloseToEdge(Circle circle, num radius, [Rect? rect]) {
    if (rect == null) return circle;

    num? x, y;
    if ((circle.center.$1 - radius) <= rect.left) x = rect.left + radius;
    if ((circle.center.$1 + radius) >= rect.right) x = rect.right - radius;
    if ((circle.center.$2 - radius) <= rect.bottom) y = rect.bottom + radius;
    if ((circle.center.$2 + radius) >= rect.top) y = rect.top - radius;
    var center = circle.center;
    if (x != null || y != null) {
      center = (x ?? point.$1, y ?? point.$2);
    }
    return Circle(center, radius);
  }

  Circle _circleAccordingToLine(num radius) {
    /*
    Here we are trying to find the angle bisector [Line] of the corner,
    using the Angle Bisector Theorem of Triangle. According to which the
    angle bisector, intersects the opposite side of the triangle in the ratio of
    the other two sides.
    */

    //Sides of the triangle formed by the 3 coordinates.
    final a = (prev, point).distance;
    final b = (point, next).distance;
    final c = (prev, next).distance;

    /* Finding the ratio of two sides of the corner triangle, i.e, (prev, point)
    and (point, next) sides. */
    final ratio = (a, b).normalize;

    /* In the Corner Triangle, finding the point on the opposite side to the
    [point], i.e the side made by (prev, next) points. Through this point the
    angle bisector from (point) will pass through. */
    final betweenPoint = (prev, next).pointInBetween(ratio);

    //Getting the angle bisector line.
    final line = Line.fromTwoPoints((point, betweenPoint));

    /* Center of the corner circle will be on the angle bisector line, at the
    [radius] away from [point], this will return 2 possible points for the
    centers. */
    var distanceFromPoint = radius;
    if (inCircle) {
      /*Law of Cosines: c^2 = a^2 + b^2 - (2ab * cosC)
        Where, C is the angle between two lines.
        Using the above law to find the angle between two lines */
      final angle = Angle.fromCos((a.sq + b.sq - c.sq), (2 * a * b));
      final halfAngle = angle.half;

      distanceFromPoint /= halfAngle.sinValue;
    }
    final centers = line.pointsOnLineFromPoint(point, distanceFromPoint);

    //Selecting the center closer to the [betweenPoint].
    if ((centers.$1, betweenPoint).distance <
        (centers.$2, betweenPoint).distance) {
      return Circle(centers.$1, radius);
    }
    return Circle(centers.$2, radius);
  }

  ///Here provide the [size] of the Container inside which the figure will be.
  factory Corner.fromList(List<Coord> coords, int index, num radius,
          [Size? size, bool inCircle = false]) =>
      Corner(
        coords.getAlways(index - 1),
        coords.getAlways(index),
        coords.getAlways(index + 1),
        radius,
        ((size != null) ? Rect.fromLTWH(0, 0, size.width, -size.height) : null),
        inCircle,
      );

  Corner get flipY => Corner.raw(
        prev.flipY,
        point.flipY,
        next.flipY,
        circle.flipY,
        clockwise,
        inCircle,
      );
}
