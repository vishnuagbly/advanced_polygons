import 'dart:math';

import 'package:advanced_polygons/extensions/coord.dart';
import 'package:advanced_polygons/extensions/num.dart';

import 'angle.dart';

const kDefaultError = 1e-3;

class Line {
  final Angle slope;
  final num bias;

  const Line(this.slope, this.bias);

  Line.fromSlopePoint(this.slope, Coord point)
      : bias = ((point.$2 * slope.base) - (point.$1 * slope.front));

  factory Line.fromTwoPoints((Coord, Coord) coords) =>
      Line.fromSlopePoint(Angle.fromTwoPoints(coords.$1, coords.$2), coords.$1);

  Line rotate(Coord point, Angle theta, [bool antiClockwise = true]) =>
      Line.fromSlopePoint(slope.rotate(theta, antiClockwise), point);

  ///Perpendicular line passing through [point].
  Line perpendicular(Coord point) =>
      Line.fromSlopePoint(slope.perpendicular, point);

  ///Value of 'c' in eqn: ax + by + c = 0
  num get c => bias;

  ///Returns null if lines are parallel
  Coord? intersect(Line line, [num error = kDefaultError]) {
    final denominator = ((slope.a * line.slope.b) - (slope.b * line.slope.a));
    if (denominator.abs() <= error) return null;
    final x = ((line.c * slope.b) - (line.slope.b * c)) / denominator;
    final y = ((c * line.slope.a) - (slope.a * line.c)) / denominator;
    return (x, y);
  }

  Coord pointOnLineClosestTo(Coord point) {
    final perpLine = Line.fromSlopePoint(slope.perpendicular, point);
    return intersect(perpLine)!;
  }

  num evaluate(Coord point) {
    return (slope.a * point.$1) + (slope.b * point.$2) + bias;
  }

  bool contains(Coord point, [num error = kDefaultError]) {
    return (evaluate(point)).abs() <= kDefaultError;
  }

  num distanceFromPoint(Coord point) {
    final numerator = evaluate(point).abs();
    final denominator = sqrt(slope.a.sq + slope.b.sq);
    return numerator / denominator;
  }

  static Coord _addDistToPointOnLine(
      Coord point, Angle slopeAngle, num distance) {
    return (
      point.$1 + (slopeAngle.cosValue * distance),
      point.$2 + (slopeAngle.sinValue * distance)
    );
  }

  ///Returns two coords equal distance, [distance] from the given point on the line.
  ///
  ///Note:- if [distance] is less than the [distanceFromPoint], function will
  ///return the 2 same points, i.e [pointOnLineClosestTo];
  (Coord, Coord) pointsOnLineFromPoint(Coord point, num distance) {
    final pointOnLine = pointOnLineClosestTo(point);

    final distFromPoint = distanceFromPoint(point);
    if (distFromPoint > distance) return (pointOnLine, pointOnLine);

    final angleMadeByPoint = Angle.fromCos(distFromPoint / distance);
    final distOnLine = distance * angleMadeByPoint.sinValue;

    final first = _addDistToPointOnLine(pointOnLine, slope, distOnLine);
    final second = _addDistToPointOnLine(pointOnLine, slope, -distOnLine);
    return (first, second);
  }

  ///Returns -1 for left, 1 for right and 0 in case the [point] lies on the
  ///line and null in case the line is horizontal.
  num? pointXDirectionToLine(Coord point) {
    if (slope.a == 0) return null;
    final res = evaluate(point);
    return (slope.a < 0) ? -res.sign : res.sign;
  }

  /// Value of the perpendicular foot from a point on the line. i.e the
  /// intersection of the perpendicular
  ///
  /// Using Eqn:-
  /// (x - x1) / a  =  (y - y1) / b  =  -(ax1 + by1 + c) / (a^2 + b^2)
  Coord perpendicularFoot(Coord point) {
    final numerator = -evaluate(point);
    final denominator = (slope.a.sq + slope.b.sq);
    return (
      ((numerator * slope.a) / denominator) + point.$1,
      ((numerator * slope.b) / denominator) + point.$2
    );
  }
}
