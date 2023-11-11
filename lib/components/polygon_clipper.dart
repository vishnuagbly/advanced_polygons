import 'package:advanced_polygons/extensions/polygon.dart';
import 'package:advanced_polygons/objects/polygon_args.dart';
import 'package:advanced_polygons/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class PolygonClipper extends CustomClipper<Path> {
  final PolygonArgs args;

  const PolygonClipper(this.args);

  @override
  Path getClip(Size size) {
    final polygon = PolygonUtils.genPolygon(args, size);
    return polygon.genPath;
  }

  @override
  bool shouldReclip(covariant PolygonClipper oldClipper) {
    return oldClipper.args != args;
  }
}
