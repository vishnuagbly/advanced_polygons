import 'package:advanced_polygons/extensions/coord.dart';
import 'package:advanced_polygons/extensions/list.dart';
import 'package:advanced_polygons/extensions/polygon.dart';
import 'package:advanced_polygons/objects/polygon_args.dart';
import 'package:advanced_polygons/utils/utils.dart';
import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final PolygonArgs args;
  final Paint? linePaint;
  final Paint? circlePaint;
  final Paint? outlinePaint;
  final Paint? pointPaint;
  final bool showCirclesAtCorner;
  final bool showOutlines;
  final bool showPoints;
  final bool showPolygon;

  ///Here provide [args] defining the properties of the polygon.
  ///
  ///Set [showPolygon] to false, to hide the polygon.
  ///
  ///Set [showCirclesAtCorner] to true, to show circles at corner instead of
  ///simply rounder corner, i.e instead of simply just an arc.
  ///
  ///Set [showOutlines] to true, to show the outlines around the whole polygon,
  ///i.e the original polygon connecting the coords directly without border
  ///radius.
  ///
  ///Set [showPoints] to true, to show the points at coords.
  ///
  ///Specify [linePaint] for custom [Paint] object, to use for drawing the
  ///lines of the polygon. Its default value is [defaultLinePaint]
  ///
  ///Specify [circlePaint] for the circles to be drawn when
  ///[showCirclesAtCorner] is true. If not specified this will be the same as
  ///the [linePaint] as default.
  ///
  ///Specify [outlinePaint] for the outlines to be drawn when [showOutlines] is
  ///true. If not specified this will be the same as the [linePaint] as default.
  ///
  ///Specify [pointPaint] for the outlines to be drawn when [showPoints] is
  ///true. If not specified this will be the same as the [linePaint] as default.
  const PolygonPainter({
    required this.args,
    this.showCirclesAtCorner = false,
    this.showOutlines = false,
    this.showPoints = false,
    this.showPolygon = true,
    this.linePaint,
    this.circlePaint,
    this.outlinePaint,
    this.pointPaint,
  }) : super();

  static Paint get defaultLinePaint => Paint()
    ..strokeWidth = 2
    ..color = Colors.red.shade900;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = this.linePaint ?? defaultLinePaint;
    final circlePaint = this.circlePaint ?? linePaint;
    final outlinePaint = this.outlinePaint ?? linePaint;
    final pointPaint = this.pointPaint ?? linePaint;

    final polygon = PolygonUtils.genPolygon(args, size);
    final path = polygon.genPath;

    if (showPolygon) canvas.drawPath(path, linePaint);

    if (showCirclesAtCorner) {
      for (int i = 0; i < polygon.corners.length; i++) {
        canvas.drawCircle(
          polygon.corners[i].circle.center.toOffset,
          polygon.corners[i].circle.radius.toDouble(),
          circlePaint,
        );
      }
    }

    if (showOutlines) {
      for (int i = 0; i < polygon.corners.length; i++) {
        final prevPoint = polygon.corners.getAlways(i - 1).point.toOffset;
        final currPoint = polygon.corners[i].point.toOffset;
        canvas.drawLine(prevPoint, currPoint, outlinePaint);
      }
    }

    if (showPoints) {
      for (int i = 0; i < polygon.corners.length; i++) {
        canvas.drawCircle(
          polygon.corners[i].point.toOffset,
          pointPaint.strokeWidth,
          pointPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PolygonPainter oldDelegate) {
    return oldDelegate.args != args ||
        oldDelegate.linePaint != linePaint ||
        oldDelegate.circlePaint != circlePaint ||
        oldDelegate.outlinePaint != outlinePaint ||
        oldDelegate.showOutlines != showOutlines ||
        oldDelegate.showPoints != showPoints ||
        oldDelegate.pointPaint != pointPaint ||
        oldDelegate.showPolygon != showPolygon ||
        oldDelegate.showCirclesAtCorner != showCirclesAtCorner;
  }
}
