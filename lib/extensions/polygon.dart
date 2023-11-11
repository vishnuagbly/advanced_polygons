import 'package:advanced_polygons/extensions/coord.dart';
import 'package:advanced_polygons/extensions/list.dart';
import 'package:advanced_polygons/objects/polygon.dart';
import 'package:flutter/material.dart';

extension PolygonExt on Polygon {
  Path get genPath {
    final path = Path();
    path.moveTo(
      edges[0].first.$1.toDouble(),
      edges[0].first.$2.toDouble(),
    );
    for (int i = 0; i < corners.length; i++) {
      final edge = edges[i];
      path.lineTo(edge.second.$1.toDouble(), edge.second.$2.toDouble());

      final next = edges.getAlways(i + 1);
      path.arcToPoint(
        next.first.toOffset,
        radius: Radius.circular(radii[i].toDouble()),
        clockwise: corners[i].clockwise,
      );
    }

    return path;
  }
}
