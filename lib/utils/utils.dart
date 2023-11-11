import 'package:advanced_polygons/extensions/coord.dart';
import 'package:advanced_polygons/objects/polygon.dart';
import 'package:advanced_polygons/objects/polygon_args.dart';
import 'package:flutter/material.dart';

abstract class PolygonUtils {
  ///Here [size] is the size of the container, inside which the polygon will be.
  static Polygon genPolygon(PolygonArgs args, Size size) {
    //Here we are flipping Y for coords, to convert the coords to standard
    //plane.
    final coords = args.coords.flipY.toAbsolute(size).toList();

    args = args.copyWith(coords: coords, size: size);

    //Here once the [Polygon] object is generated we will convert back the whole
    //polygon to the non-standard drawing plane, by flipping Y again.
    return Polygon.fromArgs(args).flipY;
  }
}
