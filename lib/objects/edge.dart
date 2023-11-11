import 'package:advanced_polygons/extensions/coord.dart';
import 'package:flutter/services.dart';

import 'angle.dart';
import 'corner.dart';
import 'line.dart';

class Edge {
  final Coord first, second;

  Edge(this.first, this.second);

  factory Edge.sameRadiusDirectTangent(Corner prev, Corner current) {
    assert(prev.circle.radius == current.circle.radius,
        'This constructor is for corner with same border radius, use [Edge.fromTangent] constructor instead.');
    final clockwise = current.clockwise;

    final centerLine =
        Line.fromTwoPoints((prev.circle.center, current.circle.center));

    final perpLineFirst = centerLine.perpendicular(prev.circle.center);
    final perpLineSecond = centerLine.perpendicular(current.circle.center);

    final firstCoords = perpLineFirst.pointsOnLineFromPoint(
        prev.circle.center, prev.circle.radius);
    final secondCoords = perpLineSecond.pointsOnLineFromPoint(
        current.circle.center, current.circle.radius);

    for (final (first, second) in [
      (firstCoords.$1, secondCoords.$1),
      (firstCoords.$2, secondCoords.$2)
    ]) {
      //Checking if according to the direction tangent is correct.
      if (areCorrectPoints(first, second, current.circle.center, clockwise)) {
        return Edge(first, second);
      }
    }

    throw PlatformException(
      code: 'NO_CORRECT_TANGENTS',
      details: 'No correct tangent found between the given two corners.',
    );
  }

  factory Edge.fromTangent(Corner prev, Corner current) {
    final clockwise = current.clockwise;
    final transverse = (prev.clockwise != current.clockwise);
    if (!transverse && prev.circle.radius == current.circle.radius) {
      return Edge.sameRadiusDirectTangent(prev, current);
    }

    /* Setting the bigger circle as the first and the other as second. This is
    *  important in case of the direct tangent, as we will be using the
    *  section formula to find the external point, there. */
    var (first, second) = (prev.circle.radius > current.circle.radius)
        ? (prev, current)
        : (current, prev);

    /* In case of direct tangent we will be getting the external point,
    *  Otherwise will be getting the internal point. */
    final commonPoint = (
      first.circle.center,
      second.circle.center
    ).pointInBetween(
        (first.circle.radius, (transverse ? 1 : -1) * second.circle.radius));

    //Angle between a single direct tangent and the line joining the centres.
    final slopeDiff = Angle.fromSin(
        second.circle.radius, (second.circle.center, commonPoint).distance);

    final centerLine =
        Line.fromTwoPoints((prev.circle.center, current.circle.center));

    for (final value in const [true, false]) {
      final tangent = centerLine.rotate(commonPoint, slopeDiff, value);

      //Points of touch with the [prev] and [current] circles respectively
      final first = tangent.perpendicularFoot(prev.circle.center);
      final second = tangent.perpendicularFoot(current.circle.center);

      //Checking if according to the direction tangent is correct.
      if (areCorrectPoints(first, second, current.circle.center, clockwise)) {
        return Edge(first, second);
      }
    }

    throw PlatformException(
      code: 'NO_CORRECT_TANGENTS',
      details: 'No correct tangent found between the given two corners.',
    );
  }

  ///Set the values of [first] and [second] if the tangent is in correct
  ///direction, that is [clockwise].
  ///
  ///This is calculated by checking if the vector from [first] to [second] and
  ///the vector [second] to [radius] are in the [clockwise] direction.
  ///
  ///We check the direction of both by doing the cross product of both vectors.
  static bool areCorrectPoints(Coord first, Coord second, Coord center,
      [bool clockwise = true]) {
    final line = second - first;
    final radius = center - second;
    return (line.cross(radius) < 0) == clockwise;
  }

  Edge get flipY => Edge(first.flipY, second.flipY);
}
