import 'package:advanced_polygons/components/polygon_painter.dart';
import 'package:advanced_polygons/extensions/coord.dart';
import 'package:flutter/material.dart';

class PolygonArgs {
  final List<Coord> coords;
  final List<num>? radii;
  final num radius;
  final Size? size;
  final bool useInCircle;

  static const kDefaultRadius = 10;

  ///Provide either a single value [radius] or a list of values for each corner
  ///[radii].
  ///
  ///Here default value of [radius] is [kDefaultRadius].
  ///
  ///Here if length of [radii] is less then the length of [coords], then the
  ///list will be repeated.
  ///
  ///When [radii] is provided, it will be preferred over [radius].
  ///
  ///Here provide the [size] of the container inside which the polygon will be.
  ///Note: You don't need to provide this, in-case of using this inside
  ///[PolygonPainter].
  ///
  ///Set [useInCircle] to true, to get in-circles for corners.
  const PolygonArgs({
    required this.coords,
    this.radii,
    this.radius = kDefaultRadius,
    this.size,
    this.useInCircle = false,
  });

  PolygonArgs copyWith({
    List<Coord>? coords,
    List<num>? radii,
    num? radius,
    Size? size,
    bool? useInCircle,
  }) =>
      PolygonArgs(
        coords: coords ?? this.coords,
        radii: radii ?? this.radii,
        radius: radius ?? this.radius,
        size: size ?? this.size,
        useInCircle: useInCircle ?? this.useInCircle,
      );

  @override
  int get hashCode => Object.hash(coords, radii, radius, size, useInCircle);

  @override
  bool operator ==(Object other) {
    return other is PolygonArgs &&
        other.coords == coords &&
        other.radii == radii &&
        other.radius == radius &&
        other.size == size &&
        other.useInCircle == useInCircle;
  }
}
