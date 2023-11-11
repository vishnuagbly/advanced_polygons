import 'package:advanced_polygons/extensions/list.dart';

import 'corner.dart';
import 'edge.dart';
import 'polygon_args.dart';

class Polygon {
  List<Corner> corners;
  List<Edge> edges;
  List<num> radii;

  Polygon(this.corners, this.edges, this.radii)
      : assert(
          edges.length == corners.length,
          'There should be equal number of edges and corners',
        ),
        assert(
          radii.length == corners.length,
          'There should be equal number corners and their respective radius for each corner',
        );

  factory Polygon.fromArgs(PolygonArgs args) {
    final radii = args.radii ?? [args.radius];

    final corners = <Corner>[];
    for (int i = 0; i < args.coords.length; i++) {
      corners.add(Corner.fromList(
        args.coords,
        i,
        radii.getAlways(i),
        args.size,
        args.useInCircle,
      ));
    }

    final edges = <Edge>[];
    for (int i = 0; i < corners.length; i++) {
      edges.add(Edge.fromTangent(corners.getAlways(i - 1), corners[i]));
    }

    for (int i = radii.length; i < corners.length; i++) {
      radii.add(radii.getAlways(i));
    }

    return Polygon(corners, edges, radii);
  }

  Polygon get flipY => Polygon(
        corners.map((corner) => corner.flipY).toList(),
        edges.map((edge) => edge.flipY).toList(),
        radii,
      );
}
