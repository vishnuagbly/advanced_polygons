import 'dart:math';

import 'package:advanced_polygons/extensions/num.dart';
import 'package:advanced_polygons/objects/angle.dart';
import 'package:flutter/material.dart';

typedef Coord = (num, num);
typedef LineSegment = (Coord, Coord);
typedef CoordPair = LineSegment;

extension PointExt on Coord {
  Angle slopeWithCoord(Coord coord) => Angle.fromTwoPoints(this, coord);

  Offset get toOffset => Offset($1.toDouble(), $2.toDouble());

  ///To reverse the direction of Y-axis
  Coord get flipY => ($1, -$2);

  Coord toAbsolute(Size size) => ($1 * size.width, $2 * size.height);

  Coord toRelative(Size size) => ($1 / size.width, $2 / size.width);

  Coord get normalize {
    final maxValue = max($1.abs(), $2.abs());
    return ($1 / maxValue, $2 / maxValue);
  }

  Coord operator +(Coord coord) => ($1 + coord.$1, $2 + coord.$2);

  Coord operator -(Coord coord) => ($1 - coord.$1, $2 - coord.$2);

  ///Performs the cross product of two vectors represented using [Coord]
  num cross(Coord point) => ($1 * point.$2) - ($2 * point.$1);
}

extension CoordPairExt on CoordPair {
  num get distance {
    return sqrt(($1.$1 - $2.$1).sq + ($1.$2 - $2.$2).sq);
  }

  ///Returns the point in between whose distance from first point and from
  ///second point is in the given [ratio].
  ///
  ///This function uses the section formula, assuming [ratio] = (m : n) :-
  ///
  ///x = (mx2 + nx1) / (m + n)
  ///
  ///y = (my2 + my1) / (m + n)
  ///
  ///Note:- (m + n) should always be positive.
  ///
  ///This can also be used to calculate the external point, by setting either
  ///'m' or 'n' negative, appropriately, ensuring (m + n) is positive.
  Coord pointInBetween((num, num) ratio) {
    final denominator = ratio.$1 + ratio.$2;
    assert(denominator > 0, '(m + n) should be +ve but found $denominator');
    return (
      (($1.$1 * ratio.$2) + ($2.$1 * ratio.$1)) / denominator,
      (($1.$2 * ratio.$2) + ($2.$2 * ratio.$1)) / denominator,
    );
  }
}

extension PointListExt on Iterable<Coord> {
  Iterable<Offset> get toOffset sync* {
    for (final coord in this) {
      yield coord.toOffset;
    }
  }

  Iterable<Coord> get flipY sync* {
    for (final coord in this) {
      yield coord.flipY;
    }
  }

  Iterable<Coord> toAbsolute(Size size) =>
      map((coord) => coord.toAbsolute(size));

  Iterable<Coord> toRelative(Size size) =>
      map((coord) => coord.toRelative(size));
}
