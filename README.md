Finally!!, You can draw the polygon shapes like you want to!!. Get the polygons at the out circle.
Get the corner always passing through the corner points given by you!!.
This is the first package using which we can draw any shape, exactly like how we want.

[Click Here](https://polygons.vishnuworld.com) to try the Sample App.

## Features

Draw both in-circle corners as well as out-circle corners. With many customization, like different
radius for each corner.

## Getting started

First install the package using the steps given in the `Installing` Section.

To getting started we provide our
own [CustomPainter](https://api.flutter.dev/flutter/rendering/CustomPainter-class.html)
and [CustomClipper](https://api.flutter.dev/flutter/rendering/CustomClipper-class.html) Classes
as `PolygonPainter` and `PolygonClipper` respectively.

Example:

```dart
void build() {
  return CustomPaint(
    painter: PolygonPainter(
      args: PolygonArgs(
        coords: [
          (0.5, 0),
          (0.8, 0.8),
          (0.2, 0.8),
        ],
        radius: 20,
        useInCircle: true,
      ),
    ),
    size: Size.square(300),
  );
}
```

This will generate a triangle with which will lie completely inside the given coordinates.
If we want to get the border curve at the given coordinates only, then set `useInCircle` as `false`.

The further details of each class is given in the API Doc.
