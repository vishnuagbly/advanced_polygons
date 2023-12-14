import 'dart:math';

import 'package:advanced_polygons/extensions/coord.dart';
import 'package:advanced_polygons/extensions/num.dart';

class Angle {
  final num front;
  final num base;

  Angle.raw(this.front, this.base)
      : assert(front != 0 || base != 0, 'Both Front and Base should not be 0'),
        assert(!(front.isNaN || base.isNaN),
            'Neither of Front and Base should be NaN');

  factory Angle.fromSides(num front, num base) {
    final values = (front, base).normalize;
    return Angle.raw(values.$1, values.$2);
  }

  factory Angle.fromXY(num x, num y) => Angle.fromSides(y, x);

  factory Angle.fromCoord(Coord coord) => Angle.fromXY(coord.$1, coord.$2);

  factory Angle.fromTan(num tanValue, [num denominator = 1]) =>
      Angle.fromSides(tanValue, denominator);

  factory Angle.fromRadians(num radians) => Angle.fromTan(tan(radians));

  factory Angle.fromSin(num sinValue, [num denominator = 1]) =>
      Angle.fromSides(sinValue, sqrt(denominator.sq - sinValue.sq));

  factory Angle.fromCos(num cosValue, [num denominator = 1]) =>
      Angle.fromSides(sqrt(denominator.sq - cosValue.sq), cosValue);

  factory Angle.fromTwoPoints(Coord first, Coord second) =>
      Angle.fromSides(second.$2 - first.$2, second.$1 - first.$1);

  ///If used as a vector
  num get x => base;

  ///If used as a vector
  num get y => front;

  ///If used as slope, then value of 'a' in eqn: ax + by + c = 0
  num get a => front;

  ///If used as slope, then value of 'b' in eqn: ax + by + c = 0
  num get b => -base;

  num get _hypotenuse => sqrt(front.sq + base.sq);

  num get cosValue => base / _hypotenuse;

  num get sinValue => front / _hypotenuse;

  num get tanValue => front / base;

  Angle get flip => Angle.fromSides(-front, base);

  Angle rotate(Angle theta, [bool anticlockwise = true]) {
    if (!anticlockwise) theta = -theta;
    final x = (this.x * theta.cosValue) - (this.y * theta.sinValue);
    final y = (this.x * theta.sinValue) + (this.y * theta.cosValue);
    return Angle.fromXY(x, y);
  }

  Angle get perpendicular => Angle.fromSides(-base, front);

  Angle get abs => Angle.fromSides(front.abs(), base.abs());

  Angle get half => Angle.fromCos(sqrt((cosValue + 1) / 2));

  Angle operator -() => Angle.fromSides(-front, base);

  Angle operator +(Angle angle) => rotate(angle);

  Angle operator -(Angle angle) => rotate(angle, false);

  Angle operator *(num value) => Angle.fromSides(front * value.sign, base);
}
