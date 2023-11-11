import 'package:advanced_polygons/extensions/coord.dart';

import 'line.dart';

class Circle {
  final Coord center;
  final num radius;

  const Circle(this.center, this.radius);

  ///Creates 2 circles tangent to the [line] and passing through [point], of
  ///given [radius].
  ///
  ///Note:- [point] should be on the [line], otherwise it will take the point
  ///closest to the given [point] on the [line].
  static (Circle, Circle) fromLineAndPoint(Line line, Coord point, num radius) {
    point = line.pointOnLineClosestTo(point);
    line = line.perpendicular(point);
    final centers = line.pointsOnLineFromPoint(point, radius);
    return (Circle(centers.$1, radius), Circle(centers.$2, radius));
  }

  Circle get flipY => Circle(center.flipY, radius);
}
