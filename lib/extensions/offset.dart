import 'package:flutter/material.dart';

import 'coord.dart';

extension OffsetExt on Offset {
  Coord get toCoord => (dx, dy);

  Offset get flipY => Offset(dx, -dy);
}
