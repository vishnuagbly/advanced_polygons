import 'package:advanced_polygons/advanced_polygons.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Stack(
              children: [
                Container(
                  width: width,
                  height: width,
                  color: Colors.white10,
                ),
                CustomPaint(
                  painter: PolygonPainter(
                    args: const PolygonArgs(
                      coords: [
                        (0.4, 0.05),
                        (0.7, 0.3),
                        (0.5, 0.6),
                        (0.8, 0.95),
                        (0.3, 0.65),
                        (0.5, 0.35),
                      ],
                      radius: 20,
                      useInCircle: true,
                    ),
                    showCirclesAtCorner: false,
                    showOutlines: false,
                    showPoints: true,
                    showPolygon: true,
                    linePaint: PolygonPainter.defaultLinePaint
                      ..style = PaintingStyle.stroke,
                    outlinePaint: Paint()
                      ..color = Colors.white
                      ..strokeWidth = 2,
                    circlePaint: Paint()..color = Colors.green,
                    pointPaint: Paint()
                      ..color = Colors.blue
                      ..strokeWidth = 5,
                  ),
                  size: Size.square(width),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
