import 'dart:math';

import 'package:advanced_polygons/advanced_polygons.dart';
import 'package:exmaple/globals.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const kShowCornerCircles = 'Show Corner Circles: ';
  static const kShowPoints = 'Show Points: ';
  static const kShowOutlines = 'Show Outlines: ';
  static const kShowPolygon = 'Show Polygon: ';
  static const kShowInCirclePolygon = 'Show In-Circle Polygon: ';

  static const kAllBooleanArgsNames = [
    kShowCornerCircles,
    kShowPoints,
    kShowOutlines,
    kShowPolygon,
    kShowInCirclePolygon,
  ];

  late final Map<String, Object?> args;

  @override
  void initState() {
    args = {
      for (final name in kAllBooleanArgsNames) name: false,
    };
    args[kShowPolygon] = true;
    super.initState();
  }

  static _genSideLength(BoxConstraints constraints) {
    return min(constraints.maxWidth, constraints.maxHeight);
  }

  List<Widget> _elements(Axis axis) => [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            final side = _genSideLength(constraints);
            return Flex(
              direction: axis,
              children: [
                const Spacer(),
                Stack(
                  children: [
                    Container(
                      width: side,
                      height: side,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: Globals.borderRadius,
                      ),
                    ),
                    CustomPaint(
                      painter: PolygonPainter(
                        args: PolygonArgs(
                          coords: [
                            (0.4, 0.05),
                            (0.7, 0.3),
                            (0.5, 0.6),
                            (0.8, 0.95),
                            (0.3, 0.65),
                            (0.5, 0.35),
                          ],
                          radius: 20,
                          useInCircle: args[kShowInCirclePolygon] as bool,
                        ),
                        showCirclesAtCorner: args[kShowCornerCircles] as bool,
                        showOutlines: args[kShowOutlines] as bool,
                        showPoints: args[kShowPoints] as bool,
                        showPolygon: args[kShowPolygon] as bool,
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
                      size: Size.square(side),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 20, width: 20),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            final side = _genSideLength(constraints);
            return Flex(
              direction: axis,
              children: [
                Card(
                  child: Container(
                    width: side,
                    height: side,
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final name in kAllBooleanArgsNames)
                            ListTileSwitch(
                              text: name,
                              value: args[name] as bool,
                              onChanged: (_) => setState(() => args[name] = _),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            );
          }),
        ),
      ];

  Axis _genAxis(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (screenSize.height > screenSize.width) return Axis.vertical;
    return Axis.horizontal;
  }

  @override
  Widget build(BuildContext context) {
    final axis = _genAxis(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Flex(
            direction: axis,
            children: _elements(axis),
          ),
        ),
      ),
    );
  }
}

class ListTileSwitch extends StatefulWidget {
  final String text;
  final bool value;
  final void Function(bool)? onChanged;

  const ListTileSwitch({
    Key? key,
    required this.text,
    this.value = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<ListTileSwitch> createState() => _ListTileSwitchState();
}

class _ListTileSwitchState extends State<ListTileSwitch> {
  late bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.text),
      trailing: Switch(
          value: value,
          onChanged: (value) {
            setState(() => this.value = value);
            widget.onChanged?.call(value);
          }),
    );
  }
}
